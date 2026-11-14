# Debugging Python in Neovim

Start your Python program in a terminal, then connect Neovim to pause execution,
inspect variables, and step through the code.

This guide uses the data-engine pipeline as an example. Run the commands from
the **application repository root**, not the Neovim configuration directory.

## Before you start

- Make sure `uv` is available and the project's Python environment has `debugpy`.
- Neovim's Python debugger expects `debugpy-adapter` to be available on your PATH.
- Keep your development database tunnel running if the pipeline needs it.

## 1. Start the pipeline

In a terminal, run:

```bash
uv run --package data-engine --env-file insights/data-engine/.env.dev -m debugpy --listen 5678 --wait-for-client -m data_engine.pipeline.run
```

The command waits for Neovim to connect before running the pipeline. This is
expected. Leave this terminal open; pipeline logs will appear here.

## 2. Open the source and set a breakpoint

In a second terminal, from the same repository root, run:

```bash
nvim insights/data-engine/src/data_engine/pipeline/run.py
```

In Neovim:

1. Press `Esc` to enter Normal mode.
2. Type `:29` and press `Enter` to go to line 29.
3. Find `shopify_sync_service.run()` (the line number may change).
4. Press `Space`, then `b` to set a breakpoint on that line.

A breakpoint tells the debugger to pause before executing that line.

## 3. Connect Neovim to the pipeline

1. Press `F5`.
2. Select **attach** and press `Enter`.
3. At the host prompt, press `Enter` to accept `127.0.0.1`.
4. At the port prompt, press `Enter` to accept `5678`.

The debugger UI opens automatically. The pipeline starts and pauses when it
reaches your breakpoint.

## 4. Step through the code

Use these shortcuts in Normal mode. For shortcuts starting with `Space`, press
the keys one after another.

| Shortcut | What it does |
| --- | --- |
| `F5` | Continue until the next breakpoint or the program finishes |
| `F10` | Run the current line without stepping into its function calls |
| `F11` | Step into a function call to follow its code |
| `F12` | Run the rest of the current function and return to its caller |
| `Space b` | Add or remove a breakpoint on the current line |
| `Space Shift+B` | Enter a condition for a breakpoint on the current line |
| `Space du` | Show or hide the debugger UI |
| `Space dr` | Open the debug console (REPL) to evaluate Python expressions |

While paused, inspect local variables in the debugger UI. You can also open the
REPL and type a variable name or Python expression to inspect its value.

Pipeline logs stay in the terminal where you started the command.

### Pause only when a condition is true

1. In Normal mode, move to the line where you want to pause.
2. Press `Space`, then `Shift+B` (uppercase `B`).
3. At the `Breakpoint condition:` prompt, type a Python condition, such as
   `shop_id == 123`. Do not include `if`.
4. Press `Enter` to save it.

The debugger pauses on that line only when the condition is true. Use variables
that are available at that line.

To change the condition, press `Space Shift+B` on the same line again. To remove
the breakpoint, press `Space b`.

## 5. Debug another run

Once the pipeline finishes, run the command from step 1 again, then attach with
`F5` as described in step 3.

## Debug a different Python file

Use the same workflow, but replace the pipeline command with your own script or
module. Run it in a Python environment that has `debugpy` and your project's
dependencies.

For a Python file:

```bash
python -m debugpy --listen 5678 --wait-for-client path/to/script.py
```

For a Python module:

```bash
python -m debugpy --listen 5678 --wait-for-client -m your_package.your_module
```

Open the matching source file in Neovim, set a breakpoint, and attach to
`127.0.0.1:5678` using the same steps above.
