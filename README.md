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
HAL sync               Pull --ff-only across all known repos.
HAL provision [limit]  Run Ansible playbook (limit: wsl2 or tablets).
HAL tablets <sub>      Manage tablets: check / start / stop / sshd / battery / pair
HAL wsl2 <sub>         WSL2 desktop: start / stop / startx / stopx / ping / check
HAL host <sub>         Host election: start [xpra] [barrier] / stop / check
HAL notes <topic>      Quick reference: tablets / dotfiles / stack
HAL init               Symlink HAL into PATH (~/.local/bin/HAL).
HAL help               List all commands.
```

## Packs (HAL prime extras)

| Pack      | Contents                                                         |
|-----------|------------------------------------------------------------------|
| `papers`  | All U paper source .md files                                     |
| `lean`    | All U/paper/proofs .lean files                                   |
| `process` | U/PROCESS.md in full                                             |
| `issues`  | Open GitHub issues across T.Ops, U, U.Ops (requires gh CLI)      |
| `tablets` | Tablet IPs, bootstrap sequence, Xpra, Ansible reference          |

## Architecture

See [DESIGN.md](DESIGN.md).
