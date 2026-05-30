# T.Dot

T-level bootstrap repository. The first repo cloned on any new device.

Contains HAL — the cross-device command router — and any system-wide configuration
that belongs to the T (master) namespace rather than a specific lane.

## Bootstrap a new device

```bash
git clone https://github.com/ITI-Theory/T.Dot.git
cd T.Dot
bin/HAL init
```

Then clone the relevant lane repos on top (e.g. U.Dot for the U-lane desktop).

## Commands

```
HAL prime [pack ...]   Output AI context block for session priming. Pipe to clipboard.
HAL init               Symlink HAL into PATH (~/.local/bin/HAL).
HAL help               List commands.
```

## Packs (HAL prime extras)

| Pack | Contents |
|---|---|
| `papers` | All U paper source .md files |
| `lean` | All U/src .lean files |
| `process` | U/PROCESS_PROCEDURES.md in full |
| `issues` | Open GitHub issues across T.Ops, U, U.Ops (requires gh CLI) |

## Architecture

See [DESIGN.md](DESIGN.md).
