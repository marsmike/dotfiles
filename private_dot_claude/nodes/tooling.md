# Tooling defaults

- **`uv`, always.** `uv venv`, `uv pip install`, `uv run`. Never `pip`, never `pip3`, never
  `--system`. Create the venv in the project or skill directory that owns it.
- **All env vars come from `~/.env`. Never create a `.envrc`** — standing convention, not a
  preference. Scripts source `~/.env` themselves rather than assuming the caller exported
  anything. Secrets live in `~/.env` or the macOS keychain.
- **Python over shell** for new tooling. Shell is fine as a thin launcher — activating a venv,
  sourcing env, exec'ing the real thing. When an existing shell script has outgrown that role,
  ask before extending it rather than converting unprompted.
- **No emojis in filenames.**
