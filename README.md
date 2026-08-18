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
├── zsh/
│   └── .zshrc            # Aliases, prompt, integraciones
├── ghostty/
│   └── config            # Fuente, tema y colores del terminal
├── ohmyposh/
│   └── half-life.omp.json  # Tema del prompt, versionado aquí
└── docs/
    └── INSTALL.md        # Guía manual, paso a paso
```

Las configuraciones se enlazan con symlinks a su lugar en `$HOME`, así que
editar `~/.zshrc` es editar el archivo del repo. Un `git diff` te dice siempre
qué has cambiado.

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
- [ ] [LazyVim](https://www.lazyvim.org/) como editor
- [ ] Entorno de Python con [uv](https://github.com/astral-sh/uv)
- [ ] Config de Git (`.gitconfig`, aliases, delta)
- [ ] tmux

## Licencia

[MIT](LICENSE). Llévate lo que te sirva.
