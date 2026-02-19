# Architecture

## Key Design Patterns

- **Stow-based symlinks**: all configs live in `home/`, mirroring the home directory structure. A single command (`stow -d ~/dotfiles -t ~ home`) symlinks everything into `~`. The `dot stow` wrapper uses `--restow` to cleanly handle updates.

- **XDG-compliant paths**: configs use `~/.config/` where the tool natively supports it. Git (`~/.config/git/`), tmux (`~/.config/tmux/`), ripgrep (`~/.config/ripgrep/`), Ghostty (`~/.config/ghostty/`), and opencode (`~/.config/opencode/`) all follow XDG conventions. Files that cannot move to XDG (`.zshrc`, `.p10k.zsh`, `.zsh_history`) remain at `~`.

- **Separate Brewfiles**: `packages/Brewfile` contains everything shared across laptop and server (CLI tools, shell plugins, dev runtimes, Tailscale GUI app). `packages/Brewfile.server` adds server-specific packages (Tailscale CLI daemon, Docker).

- **LaunchAgents for persistent services**: OpenCode server runs as a launchd service on the Mac Mini, auto-starts on login. A wrapper script (`~/.local/bin/opencode-server`) reads the password from file (avoiding process-list exposure) and resolves the Tailscale IP at launch via `tailscale ip -4` with a 60-second retry loop (daemon may still be starting after boot).

- **Casks only install on non-server init**: GUI apps (Discord, Chrome, Obsidian, Raycast, Slack, Spotify, etc.) are listed as casks in the shared Brewfile. On the headless Mac Mini, `dot init --server` skips cask installation since GUI apps are irrelevant.

- **Platform detection**: Homebrew path differs on Apple Silicon (`/opt/homebrew`) vs Intel (`/usr/local`). The `.zshrc` conditionally evaluates `/opt/homebrew/bin/brew shellenv` for Apple Silicon Macs.

- **dot CLI orchestrates setup**: `dot init` runs a deterministic bootstrap sequence: install Homebrew, `brew bundle` packages, stow configs, clone TPM, install global npm packages (repomix via pnpm). The `--server` flag additionally disables sleep, enables SSH remote login, and disables Spotlight indexing.

- **No plugin manager for zsh**: all shell plugins (zsh-autosuggestions, zsh-syntax-highlighting, powerlevel10k) are installed via Homebrew and sourced directly. No oh-my-zsh, zinit, or similar framework.

## Important Relationships

- **`.zshrc` loading order**: p10k instant prompt first (must be at top of file), then Homebrew shellenv, then powerlevel10k theme + p10k config, then navigation (zoxide, fzf), then direnv, then plugins (autosuggestions, syntax-highlighting last per its docs), then env vars, PATH, aliases, and history config.

- **direnv auto-loads `.envrc` per project directory**: the `direnv` hook is initialized in `.zshrc`, so entering a directory with an `.envrc` automatically loads/unloads environment variables.

- **`RIPGREP_CONFIG_PATH` env var** points ripgrep to `~/.config/ripgrep/config`. Without this variable, ripgrep does not read any config file by default.

- **tmux-resurrect + tmux-continuum auto-save/restore sessions**: resurrect persists tmux sessions across restarts, and continuum (`@continuum-restore 'on'`) automatically restores sessions when tmux starts. This is critical for the headless server where tmux sessions must survive reboots.

- **`~/.local/bin/` is in PATH** for custom scripts. The directory is scaffolded with a `.gitkeep` and prepended to `$PATH` in `.zshrc`.

- **Git uses bat as pager**: `git config core.pager` is set to `bat --style=changes`, providing syntax-highlighted diffs.

- **`dot doctor` checks tools, configs, and symlinks**. On servers (detected by Docker cask presence), it also checks: pmset values, Tailscale connectivity, auto-login status, auto-update install disabled, and OpenCode server process.

## Non-obvious Implementation Details

- **`dot init --server`** applies headless macOS settings: hardens pmset (disables sleep, auto-restarts after power loss, disables Power Nap and disk sleep), disables automatic macOS update installation, enables SSH remote login, and disables Spotlight indexing. After running, two manual steps are required:

  1. **Disable FileVault**: `sudo fdesetup disable` — disk encryption prevents auto-login. Wait for decryption to finish (`fdesetup status` to check progress).
  2. **Enable auto-login**: System Settings > Users & Groups > Automatic Login. Required so LaunchAgents (OpenCode server) start after reboot without manual login.
  3. **Authenticate Tailscale CLI**: `sudo tailscale up` — one-time auth, opens a URL to approve the node.

- **Tailscale runs as CLI daemon on server** (`brew "tailscale"` in `Brewfile.server`), not the GUI app. The CLI `tailscaled` runs as a system-level LaunchDaemon — starts at boot before user login, no GUI session needed. The laptop uses the GUI app (`cask "tailscale"` in shared Brewfile).

- **Ghostty config only relevant on laptop**: the server is headless and renders no fonts or terminal UI. The Ghostty config is still stowed on the server (harmless), but only the laptop uses it.

- **`.p10k.zsh` lives in `home/`** and is version controlled. It is generated by running `p10k configure` but then committed so the prompt looks identical on every machine. It is sourced from `~/.p10k.zsh` (symlinked by stow).

- **tmux plugins installed on first launch** by pressing `Ctrl+A, I` (the TPM install shortcut). `dot init` clones TPM to `~/.tmux/plugins/tpm`, but individual plugins (sensible, resurrect, continuum) are fetched on first key press.

- **Stow is a single command**: `stow -d ~/dotfiles -t ~ home`. The `-d` flag sets the stow directory, `-t ~` sets the target, and `home` is the package. The `dot stow` wrapper adds `--restow` to prune stale symlinks.

- **`dot update` bundles both Brewfiles on servers**: it detects server mode by checking if Docker cask is installed, and if so, also runs `Brewfile.server`.

- **`dot backup <name>`** creates timestamped tarballs in `backups/` (gitignored). It archives configs from `$HOME` (the live symlink targets), not from the repo, so it captures the actual running state.

- **OpenCode credentials stored outside dotfiles repo** at `~/.config/opencode/credentials/` (gitignored). Created interactively during `dot init --server`.

- **tmux prefix is `Ctrl+A`** (rebound from default `Ctrl+B`). Pane navigation uses vim-style `h/j/k/l` bindings.

## Server Operations

All operations performed from laptop via SSH (`ssh minas-tirith`).

### Updating dotfiles
```bash
dot update        # pulls repo, brew bundle, restow, plugin deps
dot doctor        # verify everything is healthy
```

If the OpenCode server wrapper script changed:
```bash
launchctl bootout gui/$(id -u)/com.opencode.server
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.opencode.server.plist
```

### Updating macOS
Auto-install is disabled — updates are manual and intentional.
```bash
# check available updates
softwareupdate -l

# install a specific update (will reboot)
sudo softwareupdate -i "update-name" --restart

# or install all available
sudo softwareupdate -ia --restart
```
The machine will reboot. With auto-login + Tailscale CLI daemon + autorestart pmset, it should come back online automatically. Verify after:
```bash
ssh minas-tirith dot doctor
```

### Updating Homebrew packages
```bash
brew update && brew upgrade
sudo brew services restart tailscale    # if tailscale was upgraded
dot doctor
```

### If server is unreachable
1. Check if machine is on local network: `ping minas-tirith.local` (from same LAN)
2. If reachable locally but no Tailscale: `ssh minas-tirith.local` then `sudo tailscale up`
3. If not reachable at all: physical access needed — likely stuck at login screen or powered off
4. After recovery, run `dot doctor` to verify all services
