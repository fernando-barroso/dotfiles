# CLAUDE.md — Instructions for Claude Code

This is a dotfiles repository managed with GNU Stow. All configuration
files live under `home/` and are symlinked to `~` via `stow -d ~/dotfiles -t ~ home`.

## Repository layout

- `dot` — CLI tool for managing dotfiles (init, update, doctor, stow, backup)
- `home/` — All stowable configs, mirrors home directory structure
- `packages/Brewfile` — Shared Homebrew packages (laptop + server)
- `packages/Brewfile.server` — Additional packages for headless Mac Mini

## Key conventions

- Shell: zsh with Powerlevel10k prompt
- Configs use XDG paths (~/.config/) where supported
- Stow target is ~ (run from ~/dotfiles: stow -t ~ home)
- Dev repos live at ~/dev/
- This repo lives at ~/dotfiles/

## When editing configs

- Edit files in home/, never directly in ~
- After changes, run `dot stow` to update symlinks
- Test with `dot doctor` to verify everything works

## Platform

- macOS (Apple Silicon)
- Used on both a MacBook laptop and a headless Mac Mini server (via Tailscale)
- Ghostty terminal config only applies on the laptop
