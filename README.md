# Dotfiles

My configuration files, tracked with Git.

## How it works

The files live in `~/dotfiles`. Symlinks let applications find them at their
usual locations.

Each application has its own folder. For example:

```text
~/.tmux.conf -> ~/dotfiles/tmux/.tmux.conf
```

Links are currently created with `ln -s`; no extra tools are needed.

## tmux

Includes `.tmux.conf` and the centered-pane script.

On a new machine, back up any existing files at these locations, then link:

```sh
mkdir -p "$HOME/.tmux/scripts"
ln -s "$HOME/dotfiles/tmux/.tmux.conf" "$HOME/.tmux.conf"
ln -s "$HOME/dotfiles/tmux/.tmux/scripts/center-pane.sh" "$HOME/.tmux/scripts/center-pane.sh"
```

The config uses TPM for plugins and `xclip` for clipboard copying. Install TPM
separately at `~/.tmux/plugins/tpm`, then press `Ctrl-a I` in tmux to install
plugins. Plugins and saved sessions stay outside this repo.

## Adding configs

Add one application at a time:

1. Choose its config files and back them up outside this repo.
2. Move them here without changing their contents.
3. Create the symlinks and check that the application still works.
4. Review and commit before adding the next application.

Keep passwords, API keys, installed plugins, and session data out of Git.

## Status

tmux added and linked. Other configs are unchanged.
