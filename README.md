# Denis's .config Dotfiles

This repository contains a curated subset of my `~/.config` setup.
It is public on purpose, so feel free to copy anything useful.

## What's Included

- Terminal and shell configs (`zsh`, `tmux`, `alacritty`, `wezterm`)
- Developer tooling (`lazygit`, `mise`, `devcontainers`)
- CLI app configs (`yazi`, `opencode`, `pi`)
- Utility scripts (`bin/` and selected app-specific scripts)

## Notes

- This is not a full machine backup.
- The repo is allowlisted via `.gitignore`, so only selected files are tracked.
- Secrets and host-specific cache files should stay untracked.

## Using These Dotfiles

Pick the parts you need and copy or symlink them into your own setup.

Example:

```bash
cp zsh/.zshrc ~/.zshrc
cp tmux/tmux.conf ~/.config/tmux/tmux.conf
```

## License

MIT. See [LICENSE](LICENSE).
