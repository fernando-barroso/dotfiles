# dotfiles

Personal dotfiles for macOS, managed with [GNU Stow](https://www.gnu.org/software/stow/).

Used on a MacBook (laptop) and a headless Mac Mini (server).

## Quick Start

```bash
git clone https://github.com/fernando-barroso/dotfiles.git ~/dotfiles
cd ~/dotfiles
./dot init           # laptop
./dot init --server  # headless Mac Mini
```

## Structure

```
dotfiles/
├── dot                    # CLI tool for managing dotfiles
├── CLAUDE.md              # Instructions for Claude Code
├── home/                  # Stowable configs (symlinked to ~)
│   ├── .zshrc
│   ├── .config/
│   │   ├── ghostty/       # Terminal config (laptop only)
│   │   ├── git/           # Git config & global ignore
│   │   ├── opencode/      # OpenCode config
│   │   ├── ripgrep/       # Ripgrep defaults
│   │   └── tmux/          # Tmux config
│   └── .local/bin/        # Custom scripts
└── packages/
    ├── Brewfile           # Shared Homebrew packages
    └── Brewfile.server    # Server-only packages
```

## Usage

| Command              | Description                                  |
|----------------------|----------------------------------------------|
| `dot init`           | Full setup (Homebrew, packages, stow, tpm)   |
| `dot init --server`  | Full setup + server-specific settings        |
| `dot update`         | Pull latest, brew bundle, re-stow            |
| `dot doctor`         | Check that all expected tools are installed   |
| `dot stow`           | Re-link dotfiles with stow                   |
| `dot edit`           | Open dotfiles in $EDITOR                     |
| `dot backup <name>`  | Create a tar.gz backup of current configs    |
| `dot help`           | Show usage                                   |

## Adding New Configs

1. Create the file under `home/` mirroring the home directory structure.
   For example, to add `~/.config/starship.toml`:
   ```bash
   mkdir -p home/.config
   vim home/.config/starship.toml
   ```
2. Run `dot stow` to create the symlink.
3. Commit and push.

## Post-Install Steps

After running `dot init`, complete these manual steps:

1. **Git email** — Update `YOUR_EMAIL_HERE` in `home/.config/git/config`
2. **Prompt** — Run `p10k configure` to set up Powerlevel10k
3. **Tmux plugins** — Open tmux, press `Ctrl+A I` to install plugins via tpm
4. **Tailscale** (server) — Run `tailscale up` to connect
