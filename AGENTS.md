# DOTFILES

macOS dev env via GNU Stow. Zsh + Powerlevel10k + Neovim + Tmux + Git.

## STRUCTURE
```
dotfiles/
├── dot                 # CLI: init/update/doctor/stow/backup
├── home/.config/       # Stowed to ~/.config/
│   ├── git/            # Git config, global ignore
│   ├── ghostty/        # Terminal (laptop only)
│   ├── nvim/           # Editor (TODO)
│   ├── opencode/       # AI agent config (TODO)
│   ├── ripgrep/        # Search defaults
│   └── tmux/           # Multiplexer + TPM plugins
├── home/.zshrc         # Shell config (p10k, plugins, aliases)
├── home/.p10k.zsh      # Powerlevel10k prompt config
├── home/.local/bin/    # Custom scripts
├── packages/
│   ├── Brewfile        # Shared packages (laptop + server)
│   └── Brewfile.server # Headless Mac Mini additions
└── docs/
    └── architecture.md
```

## WHERE TO LOOK

| Task | Location |
|------|----------|
| Add package | `dot package add <name>` or edit `packages/Brewfile` |
| Shell alias | `home/.zshrc` aliases section |
| Custom script | `home/.local/bin/` |
| Git alias | `home/.config/git/config` [alias] section |
| Neovim plugin | `home/.config/nvim/` (TODO) |
| Tmux binding | `home/.config/tmux/tmux.conf` |
| Ghostty theme | `home/.config/ghostty/config` |
| Ripgrep defaults | `home/.config/ripgrep/config` |

## CONVENTIONS

- Stow layout: `home/` mirrors `~`, single stow command links everything
- Stow command: `stow -d ~/dotfiles -t ~ home`
- XDG paths: configs use `~/.config/` where supported
- Dev repos: `~/dev/`
- Dotfiles repo: `~/dotfiles/`
- Shell: zsh with Powerlevel10k (instant prompt enabled)
- Platform: macOS Apple Silicon, used on MacBook + headless Mac Mini
- Server access: Tailscale only, SSH via tailscale hostname

## ANTI-PATTERNS

- Edit `~/.config/*` directly (changes lost on restow)
- Hardcode paths (use `$HOME`, `$XDG_CONFIG_HOME`)
- Put GUI casks in `Brewfile.server` (headless, no GUI)
- Nested git repos in stowed dirs
- Commit secrets or .env files

## COMMANDS
```bash
dot init              # Full setup (brew, stow, tpm, global packages)
dot init --server     # Above + headless macOS settings + server Brewfile
dot update            # Pull + brew upgrade + restow
dot doctor            # Health check (tools, symlinks, PATH)
dot stow              # Resymlink only
dot backup      # Compressed backup of current configs
dot edit              # Open dotfiles in $EDITOR
```

## KEY CONFIGS

| Tool | Entry | Notes |
|------|-------|-------|
| Zsh | `.zshrc` | p10k instant prompt at top, direnv, fzf, zoxide |
| Tmux | `tmux.conf` | Prefix `C-a`, resurrect + continuum for session persistence |
| Git | `config` | `pull.rebase`, bat as pager, nvim as editor |
| Ghostty | `config` | Berkeley Mono font, laptop only |
| Ripgrep | `config` | Smart-case, hidden files, ignores .git/ and node_modules/ |

## NOTES

- Ghostty config irrelevant on server (headless, no font rendering)
- tmux-resurrect + continuum auto-save sessions (critical for server)
- direnv auto-loads .envrc per project in ~/dev/
- RIPGREP_CONFIG_PATH env var set in .zshrc
- After editing any config, run `dot stow` to update symlinks