# Neovim

LazyVim config for a VS Code-ish terminal editor.

## Start

```sh
nvim .
```

First run installs plugins. After install, run:

```vim
:LazyHealth
```

## Survival Keys

| Action | Keys |
|---|---|
| Leader key | `Space` |
| Save | `Ctrl-s` or `:w` |
| Quit | `:q` |
| Save quit | `:wq` |
| Force quit | `:q!` |
| Exit insert mode | `Esc` or `jk` |
| Command palette | `Space Space` |
| Find file | `Space f f` |
| Search project | `Space s g` |
| File explorer | `Space e` |
| Recent files | `Space f r` |
| Buffers | `Space ,` |
| Terminal | `Ctrl-/` |
| Lazy plugin UI | `Space l` |
| Mason tools UI | `Space c m` |

## Modes

| Mode | Meaning |
|---|---|
| Normal | Navigate/commands |
| Insert | Typing text |
| Visual | Selecting text |

Most beginner pain is forgetting you are in Normal mode. Press `i` to type. Press `Esc` to stop typing.
