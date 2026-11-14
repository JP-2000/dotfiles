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

On a new machine, make sure the destination files do not already exist, then link:

```sh
mkdir -p "$HOME/.tmux/scripts"
ln -s "$HOME/dotfiles/tmux/.tmux.conf" "$HOME/.tmux.conf"
ln -s "$HOME/dotfiles/tmux/.tmux/scripts/center-pane.sh" "$HOME/.tmux/scripts/center-pane.sh"
```

The config uses TPM for plugins and `xclip` for clipboard copying. Install TPM
separately at `~/.tmux/plugins/tpm`, then press `Ctrl-a I` in tmux to install
plugins. Plugins and saved sessions stay outside this repo.

## Alacritty

Includes the terminal config and Everforest Dark Soft theme.
Uses JetBrainsMono Nerd Font Mono.

On a new machine, make sure `~/.config/alacritty` does not already exist, then link:

```sh
mkdir -p "$HOME/.config"
ln -s "$HOME/dotfiles/alacritty/.config/alacritty" "$HOME/.config/alacritty"
```

## Ghostty

Includes the terminal config and Everforest Dark Soft theme.
Uses JetBrainsMono Nerd Font Mono.

On a new machine, make sure `~/.config/ghostty` does not already exist, then link:

```sh
mkdir -p "$HOME/.config"
ln -s "$HOME/dotfiles/ghostty" "$HOME/.config/ghostty"
```

## Bash

Includes `.bashrc`, `.bash_aliases`, `.bash_profile`, and `.profile`.
Existing paths and tool setup are unchanged.

On a new machine, make sure these files do not already exist in your home, then link:

```sh
ln -s "$HOME/dotfiles/bash/.bashrc" "$HOME/.bashrc"
ln -s "$HOME/dotfiles/bash/.bash_aliases" "$HOME/.bash_aliases"
ln -s "$HOME/dotfiles/bash/.bash_profile" "$HOME/.bash_profile"
ln -s "$HOME/dotfiles/bash/.profile" "$HOME/.profile"
```

The startup files source `~/.local/bin/env`, `~/.cargo/env`, and
`~/apps/git-subrepo/.rc`. These are not included here.

## Git

Includes `.gitconfig` with my name, email, and default branch.

On a new machine, make sure `~/.gitconfig` does not already exist, then link:

```sh
ln -s "$HOME/dotfiles/git/.gitconfig" "$HOME/.gitconfig"
```

## Tridactyl

Includes `tridactylrc` with Firefox keyboard shortcuts.
Requires the Tridactyl extension and its native messenger.

On a new machine, make sure `~/.config/tridactyl` does not already exist, then link:

```sh
mkdir -p "$HOME/.config"
ln -s "$HOME/dotfiles/tridactyl" "$HOME/.config/tridactyl"
```

In Firefox, run `:source` or press `,r` to reload the config.

## Adding configs

Add one application at a time:

1. Choose its config files and check for conflicts.
2. Move them here without changing their contents.
3. Create the symlinks and check that the application still works.
4. Review and commit before adding the next application.

Keep passwords, API keys, installed plugins, and session data out of Git.

## Status

tmux, Alacritty, Ghostty, Bash, Git, and Tridactyl added and linked.
Other configs are unchanged.
