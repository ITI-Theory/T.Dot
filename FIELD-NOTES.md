# T.Dot FIELD-NOTES

System-level log. Append-only. Pull before reading on any device.
For research log see: U/paper/FIELD-NOTES.md

---

## 2026-05-30 — U restructure + HAL path fixes

**U root cleanup complete.**
- `instrument/` → `apps/instrument/`
- `src/` → `paper/proofs/`
- `facilities/` → `apps/facilities/`
- `images/` → `apps/facilities/gym/uppercut_bag/`
- `dist/`, `data/`, `DIARY*.md` deleted
- `PROCESS_PROCEDURES.md` → `PROCESS.md`
- U root is now clean: `paper/`, `apps/`, `PROCESS.md`, `README.md`, `docker-compose.yml`

**Litmus test principle established:**
> If something would normally have its own repo but doesn't, everything for it must live in one directory.

**HAL fixes (this commit):**
- `lean` pack: `U/src/*.lean` → `U/paper/proofs/*.lean`
- `process` pack: `PROCESS_PROCEDURES.md` → `PROCESS.md`
- Both HAL (bash) and HAL.bat updated

**T.Ops cleanup:**
- Deleted stale brainstorm scaffolding: epics/, issues/, workflow-governance.md
- Kept: standards/naming.md, standards/architecture.md, standards/formal-interop-lean-cyc.md

**[T]-Theory two-layer model announced:**
- Inner: Soma Field Theory (SFT) — science, Phase A complete, 11 Zenodo records
- Outer: [T]-Theory — art/culture umbrella, Phase B starting
- Phase B hardware setup tonight (tablets + Arch notebook); Alps + art stage tomorrow

**Open items:**
- HAL sync command (pull-first automation)
- paper/ root loose files audit (~15 .md files)
- Phase B: where does T-Art content live? (T.Art repo? T/art/?)

---

## 2026-06-12 — HAL host election + WSL2 desktop commands

**Problem diagnosed and fixed:**
- `ping tablet1.local` / `ping Laptop-P14s.local` slow/broken in WSL2
- Root cause: WSL2 mirrored mode + `dnsTunneling=true` (default) → Windows Bonjour intercepts `.local` → returns `fe80::` IPv6 link-local (unreachable)
- Fix: `[experimental] dnsTunneling=false` in `C:\Users\alist\.wslconfig`
- Also added: `kernelCommandLine=ipv6.disable=1` to disable IPv6 at kernel level
- Documented in `AJ-WiKi/Tech.md`

**Ansible site.yml bugs fixed:**
- Missing `- name:` header caused conflicting action error + duplicate `tags` key
- Added mDNS 4-step diagnostic check to wsl2 play (avahi → dnsTunneling → avahi-resolve -4 → ping)

**HAL architecture redesigned — host election model:**
- All 4 machines (P14s WSL2 + 3 tablets) run XFCE4 + awesomeWM — any can be host
- Host advertises via avahi: `_xpra._tcp` (Xpra server :10) + `_barrier._tcp` (Barrier/InputLeap port 24800)
- Clients auto-discover and attach during `HAL wsl2 startx` / `HAL tablets start`
- No hardcoded Tablet2-as-server — replaced with avahi-browse discovery

**New files:**
- `T.Dot/bin/HAL0-wsl2` — `start/stop/startx/stopx/ping/check`
- `T.Dot/bin/HAL0-host` — `start [xpra] [barrier] / stop / check`

**Updated files:**
- `HAL0` — sourced new modules, wired `wsl2` + `host` dispatch, updated stale stack notes (Arch→Debian, i3→awesomeWM, proot Arch→proot Debian)
- `HAL0-tablets` — removed hardcoded Tablet2 barriers logic; replaced with avahi discovery; removed `_do_start_barrier_server` (moved to `HAL0-host`)
- `T.Dot/README.md` — updated commands table + fixed stale pack paths
