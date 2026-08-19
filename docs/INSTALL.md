# Guía de instalación paso a paso

`./install.sh` hace todo esto automáticamente. Esta guía existe para cuando
quieras entender qué está pasando, instalar solo una parte, o reproducir el
setup en una máquina donde no puedas clonar el repo.

Probado en **macOS (Apple Silicon)**. En Intel cambia `/opt/homebrew` por
`/usr/local`. Las herramientas también existen en Linux vía `brew`, `apt` o `pacman`.

---

## 0. Requisitos previos

Las Command Line Tools de Xcode (traen `git`, compiladores y demás):

```bash
xcode-select --install
```

---

## 1. Homebrew

El gestor de paquetes del que cuelga todo lo demás.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Al terminar, el instalador te dice que agregues `brew` al PATH. En Apple Silicon:

```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

Comprueba que quedó bien:

```bash
brew --version
```

---

## 2. Todos los paquetes de una vez

Con el repo clonado, el `Brewfile` instala formulae y casks en un solo comando:

```bash
brew bundle --file=Brewfile
```

Si prefieres ir uno por uno, o solo quieres algunos, aquí está el desglose.

### 2.1 Fuente con iconos

`lsd` y el prompt dibujan iconos que solo existen en una [Nerd Font](https://www.nerdfonts.com/).
Sin esto vas a ver cuadritos y signos de interrogación:

```bash
brew install --cask font-jetbrains-mono-nerd-font
```

### 2.2 Terminal

```bash
brew install --cask ghostty
```

### 2.3 Prompt

```bash
brew install jandedobbeleer/oh-my-posh/oh-my-posh
```

### 2.4 Reemplazos de comandos clásicos

```bash
brew install lsd bat ripgrep zoxide bottom fzf
```

| Paquete | Reemplaza a | Comando |
|---|---|---|
| `lsd` | `ls` | `lsd`, `lsd --tree` |
| `bat` | `cat` | `bat archivo.js` |
| `ripgrep` | `grep` | `rg "texto"` |
| `zoxide` | `cd` | `z proyecto`, `zi` |
| `bottom` | `top` | `btm`, `btm --expanded` |
| `fzf` | — | Búsqueda difusa (la usa `zi`) |

### 2.5 Cloud y Kubernetes

```bash
brew install awscli kubernetes-cli kubecolor
```

### 2.6 Contenedores

```bash
brew install podman-compose
brew install --cask podman-desktop
```

Podman necesita una máquina virtual la primera vez:

```bash
podman machine init
podman machine start
```

### 2.7 Editor: Neovim + LazyVim

```bash
brew install neovim fd
```

`fd` y `ripgrep` no son opcionales: LazyVim los usa para buscar archivos y texto.

La configuración ya está en este repo (`nvim/`), enlazada por `install.sh`. Si
quieres partir del starter oficial desde cero en otra máquina:

```bash
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git   # para que sea tuya, no un clon del starter
```

La primera vez que abras `nvim` va a descargar todos los plugins. `lazy-lock.json`
guarda las versiones exactas, así que en otra máquina obtienes el mismo setup.
Para actualizar plugins: `:Lazy update` (y commitea el `lazy-lock.json` que cambie).

### 2.8 Python con uv

```bash
brew install uv
```

`uv` reemplaza a `pyenv`, `pip`, `venv` y `poetry` de un solo golpe. macOS trae un
Python 3.9 del sistema que **no debes tocar**; deja que uv maneje los suyos:

```bash
uv python install 3.13      # Instala Python, sin pelearse con el del sistema
uv python list              # Ver los que tienes

uv init mi-proyecto         # Proyecto nuevo con pyproject.toml
cd mi-proyecto
uv add requests             # Agrega una dependencia (crea el venv solo)
uv run main.py              # Corre dentro del venv, sin activarlo a mano
```

Para herramientas de línea de comandos escritas en Python, sin instalarlas
globalmente:

```bash
uvx ruff check .            # Las corre en un entorno temporal
```

### 2.9 Desarrollo y Git

```bash
brew install go git gh git-delta lazygit
```

- **delta** hace que `git diff` se vea como `bat`: sintaxis coloreada, números de
  línea y rutas clicables. Ya está conectado en el `.gitconfig` de este repo.
- **lazygit** es una interfaz de git en la terminal: staging por líneas, commits,
  ramas y rebase interactivo sin memorizar comandos. Se abre con `lg`.

Dentro de lazygit: `espacio` agrega/quita archivos, `c` hace commit, `P` empuja,
`?` abre la ayuda y `q` sale.

---

### 2.10 tmux

```bash
brew install tmux
```

tmux mantiene tus sesiones vivas aunque cierres la terminal: abres varios paneles,
te desconectas, y al día siguiente `tmux attach` te devuelve todo como estaba.
Sobre SSH es la diferencia entre perder el trabajo al caerse la conexión y no
perder nada.

Con Ghostty hay **dos ajustes que no son opcionales**, ambos ya incluidos en
`tmux/tmux.conf`:

```tmux
set -g default-terminal "tmux-256color"
set -as terminal-features ",xterm-ghostty:RGB"
```

Sin ellos tmux asume una terminal de 256 colores y los temas de Neovim se ven
lavados o directamente mal, porque pierde los 24 bits de color que Ghostty sí
soporta. El otro imprescindible es `escape-time 10`: con el valor por defecto,
la tecla ESC en Neovim tarda medio segundo en responder.

Del lado de Ghostty, `ghostty/config` incluye:

```
macos-option-as-alt = true
```

para que la tecla Option funcione como Alt y los atajos de tmux y Neovim
respondan.

> **Nota sobre `TERM`:** Ghostty usa `xterm-ghostty`, un terminfo que trae dentro
> de la app. Localmente funciona solo. Si haces SSH a un servidor que no lo
> conoce, copia el terminfo con:
> `infocmp -x | ssh servidor -- tic -x -`

Comandos básicos:

```bash
tmux new -s trabajo    # Sesión nueva con nombre
tmux ls                # Ver sesiones
tmux attach -t trabajo # Reconectarse
```

Y dentro, con prefijo `Ctrl-a`: `|` y `-` dividen, `h/j/k/l` navegan entre
paneles, `d` te desconecta, `r` recarga la config, `Ctrl-a Enter` entra al modo
copia (con `v` seleccionas y `y` copias al portapapeles de macOS).

Si prefieres el prefijo original `Ctrl-b`, cambia las tres primeras líneas del
`tmux.conf`.

## 3. Enlazar las configuraciones

La idea: los archivos **viven en el repo** y en `$HOME` solo hay symlinks
apuntando a ellos. Así editas tu config normal y el repo se entera solo.

```bash
# Respalda lo que ya tengas
mv ~/.zshrc ~/.zshrc.backup 2>/dev/null

# Enlaza
ln -s ~/Development/dotfiles/zsh/.zshrc ~/.zshrc

mkdir -p ~/.config/ghostty
ln -s ~/Development/dotfiles/ghostty/config ~/.config/ghostty/config

ln -s ~/Development/dotfiles/nvim ~/.config/nvim

mkdir -p ~/.config/tmux
ln -s ~/Development/dotfiles/tmux/tmux.conf ~/.config/tmux/tmux.conf

ln -s ~/Development/dotfiles/git/.gitconfig ~/.gitconfig
mkdir -p ~/.config/git
ln -s ~/Development/dotfiles/git/ignore ~/.config/git/ignore

# lazygit en macOS no lee ~/.config, sino Application Support
mkdir -p ~/Library/Application\ Support/lazygit
ln -s ~/Development/dotfiles/lazygit/config.yml \
      ~/Library/Application\ Support/lazygit/config.yml
```

> **Ojo con Ghostty en macOS:** además de `~/.config/ghostty/`, Ghostty lee
> `~/Library/Application Support/com.mitchellh.ghostty/`. Si tienes un archivo
> de config ahí, se aplica **encima** del que acabas de enlazar y vas a estar
> depurando un fantasma. Bórralo o muévelo:
>
> ```bash
> mv ~/Library/Application\ Support/com.mitchellh.ghostty/config* ~/ 2>/dev/null
> ```
>
> Para ver qué config está usando Ghostty realmente:
> `ghostty +show-config --default=false`

Aplica los cambios:

```bash
exec zsh
```

Y reinicia Ghostty (los cambios de fuente y colores se leen al arrancar).

---

## 4. Configurar Git

Si usas el `.gitconfig` de este repo, la identidad ya viene dentro y no hay nada
que hacer. Si es la de otra persona, cámbiala ahí o ponla en `~/.gitconfig.local`,
que el `.gitconfig` incluye al final y que nunca se versiona:

```bash
git config --file ~/.gitconfig.local user.name  "Tu Nombre"
git config --file ~/.gitconfig.local user.email "tu@email.com"
```

Comprueba qué identidad quedó activa:

```bash
git config --show-origin --get user.email
```

Y autentica el GitHub CLI (abre el navegador, no escribas tu contraseña en la terminal):

```bash
gh auth login
```

---

## 5. Comprobación final

```bash
lsd --tree --depth 1   # ¿Se ven los iconos?
bat README.md          # ¿Hay colores?
z -                    # ¿Salta zoxide?
btm                    # ¿Abre el monitor? (q para salir)
nvim                   # ¿Arranca LazyVim? (:q para salir)
uv python list         # ¿Ve los Python instalados?
git lg                 # ¿Sale el log gráfico? (q para salir)
lg                     # ¿Abre lazygit? (q para salir)
tmux new -s prueba     # ¿Arranca con la barra ámbar? (Ctrl-a d para salir)
oh-my-posh --version
```

Si ves cuadritos en vez de iconos, la fuente no está seleccionada: en Ghostty
debe estar `font-family = "JetBrainsMono Nerd Font"`.

---

## Personalizar

### Cambiar el tema de Ghostty

El `theme` aporta la **paleta ANSI de 16 colores** — la que usan `lsd`, `bat`,
Neovim y cualquier programa que coloree su salida. El `background`, `foreground`
y `cursor-color` que van después lo sobrescriben en esos tres puntos, y por eso
el fondo sigue siendo `#1c1c1c` aunque el tema traiga otro.

Para ver los 463 temas que trae Ghostty, con vista previa:

```bash
ghostty +list-themes
```

Los nombres llevan mayúsculas y espacios tal cual (`Gruvbox Dark`, no
`gruvbox-dark`). Si te equivocas, Ghostty abre un diálogo de error al arrancar y
usa su paleta por defecto — que es exactamente lo que pasa si escribes un tema
inexistente. Para comprobar que tu config es válida antes de reiniciar:

```bash
ghostty +validate-config --config-file=~/.config/ghostty/config
ghostty +show-config --default=false     # Qué quedó activo de verdad
```

### Cambiar el tema del prompt

Los temas están en `$(brew --prefix oh-my-posh)/themes/`. Míralos todos:

```bash
for t in $(brew --prefix oh-my-posh)/themes/*.omp.json; do
  echo "── $(basename "$t" .omp.json)"
  oh-my-posh print primary --config "$t" --shell zsh; echo
done
```

Para quedarte con uno, cópialo a `ohmyposh/` y apunta ahí el `.zshrc`. El de
este repo es `half-life`.

### Cosas privadas

Tokens, rutas de trabajo, aliases de un solo cliente — nada de eso va al repo.
Ponlo en `~/.zshrc.local`, que el `.zshrc` carga al final si existe:

```bash
echo 'export AWS_PROFILE="trabajo"' >> ~/.zshrc.local
```

---

## Pendientes

Nada crítico. Ideas para más adelante:

- **[vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator)** —
  moverse entre paneles de tmux y ventanas de Neovim con las mismas teclas.
- **Extras de LazyVim** — `:LazyExtras` para agregar soporte de lenguajes.
