#!/usr/bin/env bash
# ==============================================================================
# install.sh — Instala herramientas y enlaza las configuraciones.
#
#   ./install.sh            Instala todo (Homebrew + Brewfile + symlinks)
#   ./install.sh --link     Solo crea los symlinks
#   ./install.sh --dry-run  Muestra qué haría, sin tocar nada
#
# Es idempotente: puedes correrlo las veces que quieras.
# Cualquier archivo existente se respalda como <archivo>.backup-<fecha>.
# ==============================================================================

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"
DRY_RUN=false
LINK_ONLY=false

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
    --link)    LINK_ONLY=true ;;
    -h|--help) sed -n '2,12p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *)         echo "Opción desconocida: $arg" >&2; exit 1 ;;
  esac
done

# --- helpers ------------------------------------------------------------------
bold()  { printf '\033[1m%s\033[0m\n' "$*"; }
info()  { printf '  \033[38;5;214m→\033[0m %s\n' "$*"; }
ok()    { printf '  \033[32m✓\033[0m %s\n' "$*"; }
warn()  { printf '  \033[33m!\033[0m %s\n' "$*"; }

run() {
  if $DRY_RUN; then printf '  \033[90m[dry-run] %s\033[0m\n' "$*"; else "$@"; fi
}

# Enlaza $1 (dentro del repo) a $2 (destino en $HOME), respaldando lo que haya.
link() {
  local src="$DOTFILES/$1" dest="$2"

  if [[ ! -e "$src" ]]; then
    warn "no existe en el repo: $1"; return
  fi

  if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
    ok "$dest (ya enlazado)"; return
  fi

  run mkdir -p "$(dirname "$dest")"

  if [[ -e "$dest" || -L "$dest" ]]; then
    info "respaldo: $dest → $dest.backup-$STAMP"
    run mv "$dest" "$dest.backup-$STAMP"
  fi

  run ln -s "$src" "$dest"
  ok "$dest → $1"
}

# --- 1. Homebrew --------------------------------------------------------------
install_brew() {
  bold "1. Homebrew"
  if command -v brew &>/dev/null; then
    ok "ya instalado ($(brew --prefix))"
  else
    info "instalando Homebrew…"
    run /bin/bash -c \
      "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Apple Silicon: /opt/homebrew — Intel: /usr/local
    for p in /opt/homebrew /usr/local; do
      [[ -x "$p/bin/brew" ]] && eval "$("$p/bin/brew" shellenv)" && break
    done
  fi
}

# --- 2. Paquetes --------------------------------------------------------------
install_packages() {
  bold "2. Paquetes (Brewfile)"
  info "brew bundle — esto puede tardar unos minutos"
  run brew bundle --file="$DOTFILES/Brewfile"
  ok "paquetes instalados"
}

# --- 3. Symlinks --------------------------------------------------------------
link_configs() {
  bold "3. Configuraciones"
  link "zsh/.zshrc"     "$HOME/.zshrc"
  link "ghostty/config" "$HOME/.config/ghostty/config"

  # En macOS, Ghostty también lee este directorio. Si quedó una config vieja ahí,
  # se aplicaría encima de la del repo, así que la apartamos.
  local legacy="$HOME/Library/Application Support/com.mitchellh.ghostty"
  if [[ -d "$legacy" ]]; then
    local f
    for f in "$legacy"/config "$legacy"/config.ghostty; do
      if [[ -e "$f" && ! -L "$f" ]]; then
        info "config duplicada de Ghostty: $(basename "$f") → respaldada"
        run mv "$f" "$f.backup-$STAMP"
      fi
    done
  fi
}

# --- main ---------------------------------------------------------------------
bold ""
bold "  Dotfiles  ·  $DOTFILES"
$DRY_RUN && warn "modo dry-run: no se modifica nada"
bold ""

if ! $LINK_ONLY; then
  install_brew
  install_packages
fi
link_configs

bold ""
bold "  Listo."
echo "  Reinicia Ghostty y corre 'exec zsh' para aplicar los cambios."
echo "  Lo privado (tokens, rutas de trabajo) va en ~/.zshrc.local — no se versiona."
bold ""
