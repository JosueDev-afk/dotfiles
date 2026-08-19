#!/usr/bin/env bash
# ==============================================================================
# sync.sh — Sube los cambios de tu config a GitHub en un solo comando.
#
#   dotsync              Muestra el diff, pregunta el mensaje, commitea y empuja
#   dotsync "mensaje"    Igual, pero sin preguntar el mensaje
#   dotsync --pull       Trae lo que cambiaste en otra máquina
#   dotsync --status     Solo dice cómo está, sin tocar nada
#
# Nada se sube sin que confirmes.
# ==============================================================================

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES"

bold()  { printf '\033[1m%s\033[0m\n' "$*"; }
info()  { printf '  \033[38;5;214m→\033[0m %s\n' "$*"; }
ok()    { printf '  \033[32m✓\033[0m %s\n' "$*"; }
warn()  { printf '  \033[33m!\033[0m %s\n' "$*"; }

# Cuántos archivos sin commitear y cuántos commits sin subir
dirty_count()  { git status --porcelain | grep -c . || true; }
ahead_count()  { git rev-list --count '@{u}..HEAD' 2>/dev/null || echo 0; }

# Traduce las rutas tocadas a un mensaje legible: "Actualizo zsh y Ghostty"
auto_message() {
  local paths name
  paths="$(git diff --cached --name-only; git diff --name-only; git ls-files -o --exclude-standard)"

  local -a parts=()
  while read -r top; do
    [[ -z "$top" ]] && continue
    case "$top" in
      zsh)         name="zsh" ;;
      ghostty)     name="Ghostty" ;;
      nvim)        name="Neovim" ;;
      tmux)        name="tmux" ;;
      git)         name="Git" ;;
      lazygit)     name="lazygit" ;;
      ohmyposh)    name="el prompt" ;;
      docs)        name="la guía" ;;
      Brewfile)    name="el Brewfile" ;;
      install.sh)  name="el instalador" ;;
      sync.sh)     name="sync.sh" ;;
      README.md)   name="el README" ;;
      *)           name="$top" ;;
    esac
    parts+=("$name")
  done < <(echo "$paths" | sed 's|/.*||' | sort -u)

  # Nota: macOS trae bash 3.2, que no soporta ${parts[-1]}. Se indexa a mano.
  local n=${#parts[@]}
  if   [[ $n -eq 0 ]]; then echo "Actualizo la config"
  elif [[ $n -eq 1 ]]; then echo "Actualizo ${parts[0]}"
  elif [[ $n -eq 2 ]]; then echo "Actualizo ${parts[0]} y ${parts[1]}"
  else
    local last_idx=$((n - 1)) head="" i
    for (( i = 0; i < last_idx; i++ )); do
      [[ -n "$head" ]] && head="$head, "
      head="$head${parts[$i]}"
    done
    echo "Actualizo $head y ${parts[$last_idx]}"
  fi
}

show_status() {
  local dirty ahead
  dirty=$(dirty_count); ahead=$(ahead_count)

  if [[ $dirty -eq 0 && $ahead -eq 0 ]]; then
    ok "Todo sincronizado con GitHub"
    return 1
  fi

  [[ $dirty -gt 0 ]] && { info "$dirty archivo(s) sin commitear:"; git status --short | sed 's/^/     /'; }
  [[ $ahead -gt 0 ]] && info "$ahead commit(s) hechos pero sin subir"
  return 0
}

do_pull() {
  bold ""; bold "  Trayendo cambios de GitHub"
  git pull --rebase
  ok "Al día"
  bold ""
  exit 0
}

# --- argumentos ---------------------------------------------------------------
MESSAGE=""
case "${1:-}" in
  --pull|-p)      do_pull ;;
  --status|-s)    bold ""; bold "  Dotfiles · $DOTFILES"; bold ""; show_status || true; bold ""; exit 0 ;;
  -h|--help)      sed -n '3,10p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0 ;;
  -*)             echo "Opción desconocida: $1" >&2; exit 1 ;;
  "")             ;;
  *)              MESSAGE="$1" ;;
esac

# --- main ---------------------------------------------------------------------
bold ""
bold "  Dotfiles · $DOTFILES"
bold ""

if ! show_status; then
  bold ""
  exit 0
fi

# El diff, con delta si está configurado como paginador
if [[ $(dirty_count) -gt 0 ]]; then
  echo
  git --no-pager diff --stat HEAD 2>/dev/null | sed 's/^/  /' || true
  echo
  read -rp "  ¿Ver el diff completo? [y/N] " see
  [[ "$see" =~ ^[yYsS]$ ]] && git diff HEAD
fi

# Mensaje del commit
if [[ -z "$MESSAGE" ]]; then
  suggested="$(auto_message)"
  echo
  read -rp "  Mensaje [$suggested]: " MESSAGE
  MESSAGE="${MESSAGE:-$suggested}"
fi

echo
read -rp "  Commitear y subir a GitHub? [Y/n] " go
if [[ "$go" =~ ^[nN]$ ]]; then
  warn "Cancelado. No se subió nada."
  bold ""
  exit 0
fi

echo
if [[ $(dirty_count) -gt 0 ]]; then
  git add -A
  git commit -q -m "$MESSAGE"
  ok "Commit: $MESSAGE"
fi

git push -q
ok "Subido a $(git remote get-url origin)"
bold ""
