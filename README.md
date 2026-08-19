<div align="center">

# `λ` dotfiles

**Zsh + Ghostty + oh-my-posh** en macOS, con paleta estilo Black Mesa.
Naranja ámbar sobre gris metálico, y los clásicos de Unix cambiados por sus versiones en Rust.

```
nietzshn in ~ λ
```

</div>

---

## Qué hay aquí

| | |
|---|---|
| **Shell** | Zsh (el que trae macOS) |
| **Terminal** | [Ghostty](https://ghostty.org) |
| **Prompt** | [oh-my-posh](https://ohmyposh.dev) · tema `half-life` |
| **Editor** | Neovim + [LazyVim](https://www.lazyvim.org) |
| **Python** | [uv](https://github.com/astral-sh/uv) |
| **Git** | [delta](https://github.com/dandavison/delta) + [lazygit](https://github.com/jesseduffield/lazygit) |
| **Multiplexor** | [tmux](https://github.com/tmux/tmux) · prefijo `Ctrl-a` |
| **Fuente** | JetBrainsMono Nerd Font |
| **Colores** | `#1c1c1c` fondo · `#f1a53b` texto |

## Instalación rápida

En una Mac recién formateada, esto instala todo y enlaza las configuraciones:

```bash
git clone https://github.com/JosueDev-afk/dotfiles.git ~/Development/dotfiles
cd ~/Development/dotfiles
./install.sh
```

¿Quieres ver primero qué va a hacer, sin que toque nada?

```bash
./install.sh --dry-run
```

El script es idempotente y **respalda cualquier archivo que ya exista** como
`<archivo>.backup-<fecha>` antes de reemplazarlo. Si prefieres el paso a paso
manual (o instalar solo una parte), está todo en **[docs/INSTALL.md](docs/INSTALL.md)**.

## Estructura

```
dotfiles/
├── Brewfile              # Todos los paquetes, en un solo archivo
├── install.sh            # Instala + enlaza (idempotente, con backups)
├── sync.sh               # Sube tus cambios de config a GitHub (`dotsync`)
├── zsh/
│   └── .zshrc            # Aliases, prompt, integraciones
├── ghostty/
│   └── config            # Fuente, tema y colores del terminal
├── nvim/                 # LazyVim (starter + lazy-lock.json con las versiones)
├── git/
│   ├── .gitconfig        # Identidad, aliases y delta como paginador
│   └── ignore            # .gitignore global (.DS_Store y demás basura)
├── lazygit/
│   └── config.yml        # Interfaz de git, con la misma paleta
├── tmux/
│   └── tmux.conf         # Prefijo Ctrl-a, mouse, y colores reales en Ghostty
├── ohmyposh/
│   └── half-life.omp.json  # Tema del prompt, versionado aquí
└── docs/
    └── INSTALL.md        # Guía manual, paso a paso
```

Las configuraciones se enlazan con symlinks a su lugar en `$HOME`, así que
editar `~/.zshrc` es editar el archivo del repo. Un `git diff` te dice siempre
qué has cambiado.

## Mantener el repo al día

Como los archivos están enlazados, tus cambios ya están en el repo en cuanto
guardas. Lo único manual es subirlos, y para eso está `dotsync`:

```bash
dotsync                 # Muestra qué cambió, pregunta el mensaje, commitea y empuja
dotsync "Agrego alias"  # Con el mensaje ya puesto
dotsync --pull          # Trae lo que cambiaste en otra máquina
dotsync --status        # Solo dice cómo está, sin tocar nada
```

Nada se sube sin que confirmes. Si le das Enter en el mensaje, arma uno a partir
de los archivos tocados (`Actualizo zsh y Ghostty`).

Además, al abrir una terminal te avisa si tienes config sin subir:

```
dotfiles · 2 sin commitear, 0 sin subir — corre dotsync
```

Si prefieres control fino sobre qué entra en cada commit, `lg` (lazygit) hace lo
mismo con más detalle.

## Las herramientas

Los comandos de siempre, reemplazados:

| Antes | Ahora | Qué gana |
|---|---|---|
| `ls` | [lsd](https://github.com/lsd-rs/lsd) | Iconos, colores, `lt` para ver el árbol |
| `cat` | [bat](https://github.com/sharkdp/bat) | Resaltado de sintaxis y números de línea |
| `grep` | [ripgrep](https://github.com/BurntSushi/ripgrep) | Muchísimo más rápido, respeta `.gitignore` |
| `cd` | [zoxide](https://github.com/ajeetdsouza/zoxide) | Salta a carpetas por historial: `z proyecto` |
| `top` | [bottom](https://github.com/ClementTsang/bottom) | Gráficas de CPU/RAM en la terminal |
| `kubectl` | [kubecolor](https://github.com/kubecolor/kubecolor) | La misma salida, pero coloreada |
| `vim` | [Neovim](https://neovim.io) + [LazyVim](https://www.lazyvim.org) | LSP, autocompletado y plugins ya configurados |
| `pip`/`venv` | [uv](https://github.com/astral-sh/uv) | Instala Python y resuelve dependencias en segundos |
| `git diff` | [delta](https://github.com/dandavison/delta) | Diffs con sintaxis coloreada y números de línea |

Y además: [fzf](https://github.com/junegunn/fzf) (búsqueda difusa, lo usa `cdi`),
AWS CLI, kubectl, Podman y Go.

### Aliases que vale la pena recordar

```bash
lt              # Árbol de carpetas
lla             # Todo: detallado + ocultos
cdi             # Buscador difuso entre las carpetas que más visitas
confzsh         # Editar este .zshrc
confghostty     # Editar la config de Ghostty
reload          # Recargar la shell tras un cambio
system          # Monitor de sistema expandido
lg              # lazygit: staging, commits y ramas sin escribir comandos
tn trabajo      # Sesión de tmux llamada "trabajo"
ta trabajo      # Reconectarte a ella (aunque cierres la terminal)
```

Dentro de tmux, el prefijo es `Ctrl-a`:

```
Ctrl-a |        Dividir en vertical
Ctrl-a -        Dividir en horizontal
Ctrl-a h/j/k/l  Moverse entre paneles
Ctrl-a d        Desconectarse (la sesión sigue viva)
Ctrl-a r        Recargar la config
```

Y los de git, ya dentro del `.gitconfig`:

```bash
git s           # status corto
git lg          # log gráfico de una línea por commit
git undo        # deshace el último commit sin perder el código
git wip         # guardado rápido a medio trabajo
git pushf       # force push que no pisa el trabajo de otros
```

## Cosas privadas

Nada de tokens ni credenciales en este repo. Lo que sea privado o específico de
una máquina va en `~/.zshrc.local`, que el `.zshrc` carga al final si existe y
que nunca se versiona:

```bash
echo 'export MI_TOKEN="…"' >> ~/.zshrc.local
```

## Roadmap

- [x] Zsh + aliases
- [x] Ghostty + oh-my-posh (`half-life`)
- [x] Brewfile e instalador
- [x] [LazyVim](https://www.lazyvim.org/) como editor
- [x] Entorno de Python con [uv](https://github.com/astral-sh/uv)
- [x] Config de Git (`.gitconfig`, aliases, delta, lazygit)
- [x] tmux

## Licencia

[MIT](LICENSE). Llévate lo que te sirva.
