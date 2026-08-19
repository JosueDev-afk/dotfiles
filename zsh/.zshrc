# ==============================================================================
# .zshrc — https://github.com/JosueDev-afk/dotfiles
# ==============================================================================

# INICIALIZACIÓN DE HOMEBREW (Agregado aquí)
# Si usas Apple Silicon (M1/M2/M3/M4):
eval "$(/opt/homebrew/bin/brew shellenv)"

# Raíz del repo, resuelta desde la ruta real de este archivo (aguanta el symlink),
# para que funcione sin importar dónde lo clones.
export DOTFILES="${DOTFILES:-${${(%):-%N}:A:h:h}}"

# ======================
# PROMPT (oh-my-posh)
# ======================
# Tema "half-life". Usa la copia local del repo; si no está, cae al remoto.
() {
  local theme="$DOTFILES/ohmyposh/half-life.omp.json"
  [[ -f $theme ]] || theme="https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/half-life.omp.json"
  command -v oh-my-posh &>/dev/null && eval "$(oh-my-posh init zsh --config "$theme")"
}

# ======================
# ALIAS DE HERRAMIENTAS
# ======================

# --- 1. LSD (Reemplazo de ls con iconos) ---
alias ls='lsd'                  # Listado básico estilizado
alias l='lsd -l'                # Lista detallada (permisos, tamaños)
alias la='lsd -a'               # Muestra archivos ocultos
alias lla='lsd -la'             # Todo junto (detallado y ocultos)
alias lt='lsd --tree'           # Estructura de carpetas en árbol visual

# --- 2. BAT (Reemplazo de cat con esteroides) ---
alias cat='bat'                 # Reemplaza cat por completo
alias catp='bat --style=plain'  # Muestra texto plano sin bordes ni números si lo necesitas
alias catn='bat --number'       # Fuerza únicamente los números de línea

# --- 3. ZOXIDE (Navegación inteligente con cd) ---
# Primero inicializa zoxide en tu shell agregando esto:
eval "$(zoxide init zsh)"
alias cd='z'                    # Reemplaza cd para saltar a carpetas usando historial
alias cdi='zi'                  # Buscador interactivo difuso de carpetas visitadas

# --- 4. BOTTOM / HTOP (Monitor de sistema) ---
alias top='btm'                 # Reemplaza el monitor clásico por la interfaz gráfica de Rust
alias system='btm --expanded'   # Abre el monitor expandiendo los gráficos de CPU/Ram

# --- 5. RIPGREP (Buscador rápido de texto) ---
alias grep='rg'                 # Reemplaza grep por la versión ultra rápida
alias findtext='rg --files-with-matches' # Solo muestra nombres de archivos que tengan el texto

# --- 6. ATAJOS DE CONFIGURACIÓN RÁPIDA ---
alias confghostty='nano ~/.config/ghostty/config'  # Editar Ghostty al instante
alias confzsh='nano ~/.zshrc'                      # Editar tus alias rápido
alias reload='exec zsh'                             # Recargar la terminal tras un cambio

# --- 7. KUBERNETES & KUBECOLOR ---
if command -v kubecolor &> /dev/null; then
    alias kubectl='kubecolor'

    # Inicializar el sistema de autocompletado nativo de Zsh
    autoload -Uz compinit && compinit

    # Ahora sí se puede usar compdef sin errores
    compdef __start_kubectl kubecolor
fi

# --- 8. ACCESOS RÁPIDOS KUBERNETES CONFIG ---
alias confkube='nano ~/.kube/config'               # Editar el archivo kubeconfig actual
alias viewkube='bat ~/.kube/config'               # Ver el archivo kubeconfig con colores (usando bat)
alias cdkube='cd ~/.kube'                          # Ir directo a la carpeta de Kubernetes

# --- 9. ACCESOS RÁPIDOS AWS CLI CONFIG ---
alias confaws='nano ~/.aws/config'                 # Editar el archivo de configuración (regiones/perfiles)
alias confawscred='nano ~/.aws/credentials'       # Editar tus llaves de acceso secretas
alias viewaws='bat ~/.aws/config'                 # Ver la configuración con el resaltado de bat
alias viewawscred='bat ~/.aws/credentials'         # Ver tus credenciales de forma estructurada
alias cdaws='cd ~/.aws'                            # Ir directo al directorio de configuración de AWS

# --- 10. GIT ---
alias lg='lazygit'                                 # Interfaz de git en la terminal
alias confgit='nano ~/.gitconfig'                  # Editar la config de git
alias viewgit='bat ~/.gitconfig'                   # Ver la config con colores

# --- 11. TMUX ---
alias t='tmux'                                     # Sesión nueva sin nombre
alias tn='tmux new -s'                             # Sesión con nombre: tn trabajo
alias ta='tmux attach -t'                          # Reconectar: ta trabajo
alias tls='tmux ls'                                # Ver las sesiones abiertas
alias conftmux='nano ~/.config/tmux/tmux.conf'     # Editar la config de tmux

# --- 12. DOTFILES ---
alias dotsync="$DOTFILES/sync.sh"                  # Subir cambios de config a GitHub
alias cddot='cd $DOTFILES'                         # Ir al repo de dotfiles

# Aviso discreto al abrir la terminal si hay config sin subir.
# Callado cuando todo está al día. Se usa wc y no grep porque grep está
# aliaseado a rg más arriba y la expansión de alias también aplica aquí.
() {
  [[ -d $DOTFILES/.git ]] || return
  local dirty ahead
  dirty=$(git -C $DOTFILES status --porcelain 2>/dev/null | wc -l | tr -d ' ')
  ahead=$(git -C $DOTFILES rev-list --count '@{u}..HEAD' 2>/dev/null || echo 0)
  (( dirty + ahead > 0 )) && \
    print -P "%F{214}dotfiles%f · ${dirty} sin commitear, ${ahead} sin subir — corre %F{214}dotsync%f"
}

# --- 13. LOCAL / PRIVADO ---
# Todo lo que no debe subir al repo (tokens, rutas de trabajo, etc.) va aquí.
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

