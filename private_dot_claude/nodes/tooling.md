# Tooling defaults

## Python over shell

Prefer Python for new tooling and automation. Shell is acceptable only as a thin launcher —
activating a venv, sourcing env, exec'ing the real thing.

When you hit an existing shell script that has outgrown that role, ask whether to convert it
to Python with `argparse` rather than extending it in place.

## uv, always

`uv venv` to create, `uv pip install` to install, `uv run` to execute. Never `pip`, never
`pip3`, never `--system`. Create the venv in the project or skill directory that owns it.

## Environment variables

Everything lives in `~/.env`. **Never create a `.envrc`** — that is a standing convention, not
a preference. Scripts that need config should source `~/.env` themselves rather than assuming
the caller exported anything.

Secrets belong in `~/.env` or the macOS keychain, never in a repo, never in a committed
config file, and never printed to stdout.

## File naming

Descriptive and search-friendly. No emojis in filenames. Folder organization beats elaborate
naming conventions.
