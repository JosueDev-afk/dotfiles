# ==============================================================================
# Brewfile — todo lo que necesita este setup
# Uso:  brew bundle --file=Brewfile
# ==============================================================================

tap "jandedobbeleer/oh-my-posh"

# --- Terminal & prompt -------------------------------------------------------
cask "ghostty"                                    # Emulador de terminal (GPU, nativo)
brew "jandedobbeleer/oh-my-posh/oh-my-posh"       # Motor de prompt (tema: half-life)
cask "font-jetbrains-mono-nerd-font"              # Fuente con iconos (requerida por lsd y el prompt)

# --- Reemplazos modernos de comandos clásicos --------------------------------
brew "lsd"                                        # ls  -> lsd     (iconos y colores)
brew "bat"                                        # cat -> bat     (syntax highlighting)
brew "ripgrep"                                    # grep -> rg     (búsqueda ultrarrápida)
brew "zoxide"                                     # cd  -> z       (salta a carpetas por historial)
brew "bottom"                                     # top -> btm     (monitor de sistema)
brew "fzf"                                        # Buscador difuso (lo usa zoxide con `zi`)

# --- Cloud / Kubernetes ------------------------------------------------------
brew "awscli"                                     # CLI de AWS
brew "kubernetes-cli"                             # kubectl
brew "kubecolor"                                  # kubectl con colores

# --- Contenedores ------------------------------------------------------------
brew "podman-compose"                             # Alternativa a docker-compose (arrastra podman)
cask "podman-desktop"                             # GUI para contenedores

# --- Editor ------------------------------------------------------------------
brew "neovim"                                     # Editor (config: LazyVim)
brew "fd"                                         # Búsqueda de archivos (la usa LazyVim)

# --- Python ------------------------------------------------------------------
brew "uv"                                         # Gestor de Python, venvs y paquetes

# --- Desarrollo --------------------------------------------------------------
brew "go"                                         # Toolchain de Go
brew "git"                                        # Git actualizado (macOS trae uno viejo)
brew "gh"                                         # GitHub CLI
brew "git-delta"                                  # Diffs legibles (lo que bat es a cat)
brew "lazygit"                                    # Interfaz de git en la terminal
