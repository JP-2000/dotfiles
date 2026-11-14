# Dotfiles

My configuration files, tracked with Git.

## How it works

The files live in `~/dotfiles`. Symlinks let applications find them at their
usual locations.

Each application will have its own folder. For example:

```text
~/.tmux.conf -> ~/dotfiles/tmux/.tmux.conf
```

GNU Stow is the proposed tool for managing these links.

## Adding configs

Add one application at a time:

1. Choose its config files and back them up outside this repo.
2. Move them here without changing their contents.
3. Create the symlinks and check that the application still works.
4. Review and commit before adding the next application.

Keep passwords, API keys, installed plugins, and session data out of Git.

## Status

No configs added yet. No symlinks created.
