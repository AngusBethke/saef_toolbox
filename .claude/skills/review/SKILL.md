---
name: review
description: How to review a SAEF pull request or diff (SAEF-Mission-Framework or saef_toolbox) — scope, what to check (correctness, locality and multiplayer, scheduler, mission overrides, mission.sqm, toolbox API compatibility, tests, clean code, structure, performance), and how to report findings. Use when asked to review a PR, a branch or a diff, or to check whether a change is ready to merge.
---

# Reviewing a pull request

A review answers one question: is this change safe to merge, and if not, what has to change? It is
read by the author, so every finding says where, what is wrong, and what to do instead.

This skill says *what to look at*. The rules live in the other skills; point at them, don't restate
them: `clean-code` for SQF style and design, `naming-and-structure` for where things live,
`pr-format` for title, description and commits.

## Scope: the diff plus one hop

1. Read the PR description and any PR it depends on in the other repo.
2. Read every changed `.sqf`, `.hpp`, `.cpp` and `description.ext` in full, not just the hunks.
3. Look **one hop out**: callers of each changed function (search `framework/`, `missions/` and the
   toolbox for its name and its old path), what it calls, and the tests that cover it.
4. Go further only when a hop shows a real problem. Say where you stopped and why.

Problems in code the PR didn't touch are **pre-existing**, never blocking.

## Data files: skim, don't study

`mission.sqm` (outside trigger and init code), loadout arrays, `cba_settings.sqf` values, images and
sounds are data. Check only:

- `mission.sqm` is text, not binarized.
- Trigger `onActivation`/`condition` and object `init` code in `mission.sqm`: review it as code.
- `addons[]` in `mission.sqm` lists no dead mods (ACEX, ASR AI3); every addon is in the preset.
- Paths and function names still resolve after a move (`saef check` covers most of this).
- No generated files are committed: `build/`, `.pbo`, `.rpt`, `.bisign`.

`config.cpp`, `CfgFunctions`, `description.ext`, `presets/*/mods.txt` and `tools/saef.ps1` are
config, not data. Review those changes in full.

## What to check, in order

### 1. Correctness

Does it do what the description says, and nothing else? Look for undefined variables, wrong
`params` order, missing defaults, `nil` objects (deleted units, empty groups), unhandled
`objNull`/`grpNull`, and edge cases such as no players connected or a player disconnecting mid-way.

### 2. Locality and multiplayer

SAEF missions run on a dedicated server with clients and often a headless client.

- Where does each piece run? `initServer`, `initPlayerLocal`, headless client, triggers
  (`isServerOnly`?), event handlers (local to the unit's owner). Is there an `isServer`/
  `hasInterface`/`local` guard where it matters?
- Commands with local effect (`addAction`, `setDamage` on remote units, markers `*Local`) run on the
  machine that needs the effect.
- `remoteExec` targets are as narrow as possible; JIP flags are set only when a joining player needs
  the effect.
- Join-in-progress: does a player who joins late get the same state (actions, tasks, respawn points)?
- Broadcasts: `publicVariable` and `setVariable [..., true]` in loops are a finding.

### 3. Scheduler

- Code that `sleep`s or `waitUntil`s runs scheduled (`spawn`), never directly in a trigger, event
  handler or other unscheduled context.
- Long loops in scheduled code have a sleep; `waitUntil` conditions are cheap.
- Callers that waited on an `execVM` handle (`scriptDone`) still work after switching to `call`/
  `spawn`.

### 4. Framework, missions and overrides

- Per-mission switches (`SAEF_FMW_<Context>_<Step>`) are respected; a new init step gets a switch
  and a guard through `SAEF_FMW_fnc_Enabled`.
- A mission file at the same path overrides the framework's. A changed framework file: check which
  missions own their own copy and whether they need the change too.
- A toolbox function in `configFile` beats a mission's copy with the same name; a change that
  expects a mission override of a toolbox function is a finding.

### 5. Toolbox API compatibility (saef_toolbox PRs)

The toolbox is published on the Workshop and old missions call it.

- A published function's name, parameter order and meaning don't change. Add optional parameters at
  the end with defaults; add a new function rather than changing an old one's contract.
- New components add a `config.cpp` with `CfgPatches` and correct `requiredAddons` (`saef toolbox`
  packs every component folder that has a `config.cpp`).
- Headers are filled in (`@summary`, `@param`) so `saef_toolbox.json` stays useful.
- New toolbox code uses the `_type` method pattern (clean-code). When an old single-purpose function
  is folded into a class, the old function name stays as a deprecated alias that calls the new
  method, until no mission in `missions/` uses it.
- State lives in `SAEF_<TAG>_*` `missionNamespace` variables behind the class's `Get`/`Set` methods.

### 6. Tests

- Changed or deleted tests: what behaviour did they pin, and is the change justified? A test
  loosened, deleted or added to `tests/known-issues.txt` just to get green is blocking.
- New init steps or functions the framework relies on are listed in `tests/framework/01_init.sqf`.
- New behaviour without a test is a finding when a `saef test` script could reasonably cover it.

### 7. Clean code and structure

Apply `clean-code` and `naming-and-structure` to the changed code only. Watch for `execVM` of paths
where a function exists, wrapper scripts, `#include` in `.sqf`, copied code that belongs in the
framework or toolbox, and moves mixed into a feature PR.

### 8. Performance

Separate hot paths (per-frame handlers, `onEachFrame`, `Draw3D`, fired/hit event handlers, loops
over all units, per-AI-spawn code) from cold ones (init, briefing, one-off triggers). Flag in hot
paths:

- `allUnits`/`allPlayers`/`nearestObjects` scans that could run less often or be cached.
- Network traffic: `remoteExec` or public variables per frame or per unit.
- Spawned scripts per unit that never end.
- AI counts that grow without a cap or cleanup (body cleanup, despawn when players leave).

### 9. The PR itself

Title, description, testing notes and commits follow `pr-format`. One concern per PR, and the merge
order between repos is stated.

## Building and running

When the environment allows, run `saef check` on the changed missions (or all of them for a
framework change) and `saef test <mission>` on a spread, with `-LocalToolbox` when the PR depends on
unreleased toolbox changes (build it first with `saef toolbox`). Say what you ran and what you
couldn't; an in-game play-through is usually left to Angus.

## Reporting

Give each finding a severity, a `file:line`, what is wrong and what to do instead:

- **Blocking**: a bug, a locality or JIP hole, unscheduled code that sleeps, a broken toolbox
  contract, a broken or weakened test. Must change before merge.
- **Should fix**: clean-code, structure or practice problems that will cost later.
- **Nit**: small and optional. Keep these few.
- **Question**: something you don't understand or a choice you'd challenge.
- **Pre-existing**: problems outside the diff. Never blocking.

Open with a one-line verdict (ready to merge, ready after the blocking items, or needs another
look), then the findings, most severe first. Leave out praise and restatement of the diff. If you
found nothing, say so and say what you checked.

Post line findings as inline PR comments and the verdict as the review summary when you have access
to post (`gh`); otherwise report them in the same shape in chat.
