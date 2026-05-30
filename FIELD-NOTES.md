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
