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

### 2.7 Desarrollo

```bash
brew install go git gh
```

---

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

```bash
git config --global user.name  "Tu Nombre"
git config --global user.email "tu@email.com"
git config --global init.defaultBranch main
```

Y autenticar el GitHub CLI (abre el navegador, no escribas tu contraseña en la terminal):

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
oh-my-posh --version
```

Si ves cuadritos en vez de iconos, la fuente no está seleccionada: en Ghostty
debe estar `font-family = "JetBrainsMono Nerd Font"`.

---

## Personalizar

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

Lo que falta por agregar, en orden:

1. **[LazyVim](https://www.lazyvim.org/)** — `brew install neovim` y clonar el starter en `~/.config/nvim`.
2. **Python con [uv](https://github.com/astral-sh/uv)** — `brew install uv`.
3. **Git** — `.gitconfig` versionado, con aliases y [delta](https://github.com/dandavison/delta) para los diffs.
4. **tmux** — sesiones persistentes.
