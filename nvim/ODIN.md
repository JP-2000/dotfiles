# Odin development

OLS provides completion, navigation, diagnostics, and formatting. Mason installs
OLS, and Conform uses its LSP formatting on save and with `<leader>F`.
Treesitter supplies Odin highlighting and the existing function text objects.

## Commands and keys

The task mappings are local to Odin buffers. `<leader>` is Space.

| Key | Action |
| --- | --- |
| `<leader>oc` | Check the package |
| `<leader>ob` | Build with debug information into `app` |
| `<leader>or` | Build and run the package |
| `<leader>ot` | Run the package's Odin tests |
| `<leader>oo` | Open or close the task list |
| `<leader>F` | Format through OLS |
| `<F5>` | Build and start debugging, or continue |
| `<F10>` / `<F11>` / `<F12>` | Step over / into / out |
| `<leader>b` | Toggle a breakpoint |
| `<leader>du` | Toggle the debugger UI |

`:OverseerRun` lists available tasks. `:OverseerTaskAction` provides actions such
as restarting a task or opening its output. Compiler errors populate quickfix;
use `[q` and `]q` to navigate them.

The Odin task mappings and default debugger save the current buffer first.
Use `:wall` to save changes in other buffers before building.

## Package targets

Default tasks find the nearest `ols.json` or `.git` above the source file.
If neither exists, they use the source file's directory. Their package target
is `.` relative to that root. The default debugger builds that package with
`-debug -o:none -out:app` before launching `app`.

For a one-off target such as `src`, run:

```vim
:lua require("overseer").run_task({ name = "Odin: build", params = { package = "src" } })
```

For persistent project-specific targets and flags, use the project files below.
They belong in the Odin project, rather than this Neovim configuration.

### `ols.json`

This example checks an application package in `src`. Use `.` instead for a
root-level package. Add collections and defines here as needed.

```json
{
  "$schema": "https://raw.githubusercontent.com/DanielGavin/ols/master/misc/ols.schema.json",
  "profile": "default",
  "profiles": [
    { "name": "default", "checker_path": ["src"] }
  ]
}
```

### `odinfmt.json`

This matches the editor's four-space indentation preference:

```json
{
  "tabs": false,
  "spaces": 4,
  "newline_style": "LF"
}
```

### `.vscode/tasks.json`

Overseer reads this format directly in Neovim. This example adds a custom build
task for `src`, available through `:OverseerRun`:

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Project: build",
      "type": "process",
      "command": "odin",
      "args": ["build", "src", "-debug", "-o:none", "-out:app", "-error-pos-style:unix"],
      "options": { "cwd": "${workspaceFolder}" },
      "group": "build",
      "problemMatcher": {
        "owner": "odin",
        "fileLocation": "absolute",
        "pattern": {
          "regexp": "^(.+):([0-9]+):([0-9]+): (.*)$",
          "file": 1,
          "line": 2,
          "column": 3,
          "message": 4
        }
      }
    }
  ]
}
```

### `.vscode/launch.json`

Start Neovim from the project root, or use `:tcd /path/to/project`, so nvim-dap
finds this file and resolves `${workspaceFolder}` correctly. Save your source,
then press F5 and select **Project: debug**. Overseer runs **Project: build** first.

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Project: debug",
      "type": "lldb",
      "request": "launch",
      "program": "${workspaceFolder}/app",
      "cwd": "${workspaceFolder}",
      "args": [],
      "stopOnEntry": false,
      "preLaunchTask": "Project: build"
    }
  ]
}
```

## Debugger dependency

On Fedora, install the adapter with:

```sh
sudo dnf install lldb
```

`lldb-dap` must be available on Neovim's PATH. Optional Odin type pretty-printers
can be loaded later through LLDB's `preRunCommands`.

## Troubleshooting

- `:checkhealth vim.lsp` shows whether OLS is attached.
- `:ConformInfo` shows formatter availability.
- `:Mason` manages the `ols` package, which also includes standalone `odinfmt`.
- `:OverseerTaskAction` opens task output, including linker errors and test logs.
