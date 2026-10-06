# HAL — Design Rationale

## What HAL is

HAL is a single command that bootstraps and operates any device in this system.
It is not a collection of shell scripts.
It is an entry point that grows.

## The name

The name comes from Red Dwarf.

In Red Dwarf, Rimmer died and was brought back as a hologram — marked with an H on his forehead.
The author's name is Alistair, shortened to Al.
Hologram + Al = H-AL.

HAL is a hologram of Alistair: a projected, digital presence that acts on his behalf.
The HAL 9000 resonance is real but secondary — a happy accident, not the origin.

Even before HAL can speak, the interface feels like speech:

```
HAL init
HAL prime
HAL help
```

You are addressing it. It responds.

## Why T.Dot, not U.Dot

HAL bootstraps the *system* — any device, any lane. That is T-level work.
It should live in the T namespace, not tied to the U lane.

U.Dot holds U-lane-specific configs: desktop environment, shell aliases for Lean,
paper build shortcuts. Those stay in U.Dot.

The boot sequence is now explicit:

```
1. git clone T.Dot         → system bootstrap (HAL, PATH)
2. git clone U.Dot         → U-lane desktop configs (i3, picom, bash)
```

If you are on a device that does not run the U-lane desktop, step 2 is optional.
Step 1 is always required.

## Why one command, not many

Rather than ten script files that each do one thing, one command knows which
thing to do. The interface stays stable as internals change.
A user (or a voice layer, or an AI) always has one address: `HAL`.

## The prime command

`HAL prime` solves the AI session-start problem: any AI tool (Claude, Copilot,
GPT) needs full context before it can help. Without priming it has no idea what
the project is.

`HAL prime` outputs a complete context block — master instructions, domain
instructions, recent research log, live git status — to stdout. Pipe to
clipboard and paste into any AI chat.

Packs extend prime for deeper context: `HAL prime papers` loads all paper
sources; `HAL prime lean` loads all proof files. Multiple packs combine.

This is the same architecture webpack uses for JS bundles: a base entry point
plus named modules, assembled on demand into a single output stream.

`HAL copilot start` (below) is prime grown up: an AI runs it *itself* (no
clipboard), and it reads the current front door (the lane's README.md), the
"you are here" page (U/docs/agent/CURRENT.md) and the tail of the active chat
file, not the older research log. `HAL prime` stays as an alias.

## The vocabulary: noun, then verb

As HAL grows, a flat list of verbs collides: `start` means one thing for a
tablet and another for an AI session. Commands are therefore **noun, then
verb**, never deeper than two levels (the git / kubectl / az pattern):

```
HAL tablets start
HAL copilot start          # begin an AI session (replaces bare `prime`)
HAL copilot save           # interim save: chat export + "in progress" note
HAL copilot wrapup         # end of session: save, rewrite CURRENT, commit
HAL chat new <name>        # name a new chat and create its folder
HAL mother ask "..."       # ask the public notebook (through the bridge)
HAL hal ask "..."          # ask the private notebook (H-AL's memory)
HAL uat scope              # release scope check in a fresh nlm-uat notebook
```

Rules:

- **Few shared verbs.** `start`, `stop`, `save`, `status`, `check`, `ask`,
  `new`, `help`. A new capability adds a noun, not new verbs.
- **One list.** `HAL help` lists the nouns; `HAL <noun> help` lists that
  noun's verbs. Both are generated from the scripts, so they cannot go stale.
  Documentation points to `HAL help` instead of copying it.
- **Context.** `HAL context <noun>` sets a default noun, so a bare `HAL start`
  means `HAL <noun> start`. It is detected where possible (the VS Code
  terminal sets `TERM_PROGRAM=vscode`), `HAL_CONTEXT` overrides it for one
  terminal, and every output line starts with `[HAL <context>]` so the hidden
  state is never hidden.
- **AI uses the full form.** An AI's commands must mean the same thing in any
  terminal, so AI never relies on context. People may use the short form.
- **Layers.** Generic nouns (`copilot`, `chat`, `mother`, `hal`) live in
  HAL0; lane-specific ones (U paths, notebook ids, `uat`) in the lane's layer
  (HAL1 for U). The dispatcher already sends each command to the highest
  layer, which forwards what it does not know.

## Dry run: look before you leap

`HAL -n <noun> <verb>` (or `HAL_DRY_RUN=1`) runs a command without changing
anything: reads and checks happen for real, and every change is printed as a
`[would]` line instead (`[would] rm -f ...`, `[would] write <file>:` with the
contents). Every state-changing command in HAL goes through `_hal_do` or
`_hal_write`, so the dry run cannot miss one. Make targets have the same thing
for free: `make -n <target>`.

Rule for people and AI: run anything that changes state with `-n` first, read
the `[would]` lines, then run it for real.

## Platforms and capabilities

`HAL_OS` names the shell world: `gitbash` (Windows), `termux` (the tablets),
`wsl`, or `unix` (any real Linux: a bare-metal mini PC, a VirtualBox VM).
Whether a command can run is decided by the tools it needs
(`_hal_requires host xpra avahi-browse`), not by the platform's name, so a new
machine works as soon as it has the tools. A command whose tools are missing
says which ones and stops before changing anything.

## What HAL is bootstrapping

This is the initialisation sequence of a new operating system.

HAL starts minimal — symlinks, paths, a working shell.
Then lane-specific configs are added. Then voice. Then AI.
At each stage, HAL absorbs the new capability.
The command stays the same; what it can do grows.

## The AI branch

A future `HAL` will include branches like:

```bash
if ai_available; then
    # delegate to AI agent with full context
else
    # run the local deterministic version
fi
```

This is not a later bolt-on. It is in the design now.
The local version is the fallback, not the default.
When AI is present, HAL becomes a different kind of thing.
