# ~/.config/tmux/tmux.conf

Config is split across two files:
- `tmux.conf` — options, settings, plugins
- `tmux.keybinds.conf` — all keybindings + full reference comment block at the top

## Bootstrap TPM

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Then inside tmux: `prefix + I` (capital i) to install plugins.

## Plugin management

| Action | Key |
|--------|-----|
| Install new plugins | `prefix + I` |
| Update plugins | `prefix + U` |
| Remove unlisted plugins | `prefix + Alt+U` |

## Theme

Catppuccin **Latte** (light) via `omerxx/catppuccin-tmux`.
To switch flavour, change `@catppuccin_flavor` in `tmux.conf`:
`latte` · `frappe` · `macchiato` · `mocha`
