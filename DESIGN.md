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
