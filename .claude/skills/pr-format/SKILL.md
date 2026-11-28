---
name: pr-format
description: How pull requests, commits and branches are shaped in the SAEF repos (SAEF-Mission-Framework and saef_toolbox) — PR scope, title, description sections, testing notes, commit messages, branch names, and the merge order between the two repos. Use when opening or updating a PR, writing a commit message, or reviewing whether a PR is ready.
---

# Pull requests

A PR is read by someone who did not write it, often days later. It should tell them what changed
for the players, the mission maker or the Zeus, why, and how it was checked, without them opening
the diff first.

## Scope

- One concern per PR. A refactor and a behaviour change go in separate PRs.
- If the description needs "and also", split it.
- A batch of mission ports is one concern: one campaign or one batch per branch and PR
  (`feature/<campaign>` or `feature/<batch>`), agreed with Angus.
- Toolbox changes and the framework changes that depend on them are separate PRs in their own repos.

## Branches

- One branch per batch, cut from the latest `master`: `feature/<short-topic>`, kebab-case.
  Example: `feature/toolbox-wave2`, `feature/altis-2021`.
- Never commit straight to `master`.

## Title

- `<type>: <summary>` (Conventional Commits). Types:
  - `feat` – new behaviour a player, Zeus or mission maker can use; a newly ported mission
  - `fix` – a bug fix
  - `refactor` – structure changes with no behaviour change
  - `perf` – performance work (AI counts, network traffic, scheduler load)
  - `test` – tests only (`tests/`, `FMW\Tests`)
  - `docs` – documentation only
  - `build` – presets, mod lists, `saef` tooling that builds or packs
  - `chore` – housekeeping that fits nowhere else
- Summary: imperative, lower case, no trailing full stop, whole title 72 characters or fewer.
- Say the outcome, not the activity: `fix: stop extraction helicopters leaving without players`, not
  `fix: extraction fixes`.

## Description

Start with the attribution lines the session gives you, then these sections:

- **Before / After** – what players, Zeus or the mission maker saw before and see now.
- **Why** – one or two sentences, only when the reason isn't obvious from Before/After.
- **How** – a short paragraph on the approach and any decision a reviewer should challenge.
- **Testing** – what was run and on what:
  - `saef check` (which missions, or "all N missions")
  - `saef test <mission>` / `saef test <mission> -LocalToolbox` (which missions, pass/fail)
  - hosted or dedicated play-tests, and by whom
  List anything not yet tested and who needs to test it (usually an in-game play-through by Angus).
- **Depends on** – the other repo's PR that must merge first, when there is one.
- **Follow-ups** – known gaps left on purpose, if any.

## Cross-repo changes

- When a framework or mission change needs new toolbox functions, the toolbox PR merges first and
  the framework PR says `Depends on AngusBethke/saef_toolbox#<n>`.
- Missions only work for players once the toolbox is released to the Workshop; say so in the
  framework PR when a release is needed.

## Merging

- Angus reviews and merges. Don't merge or enable auto-merge unless he asks.
- Open as a draft while work or testing is unfinished. Mark ready only when Testing has nothing
  left that the author can do.

## Commits

- Subject: same `<type>: <summary>` form as PR titles.
- Body (optional): why the change was made, wrapped at 72.
- Only commit what belongs to the change. In the framework repo, commit only the ported files of a
  mission, never `build/` output or a whole mission working copy.
- Don't commit generated or local files: `build/`, packed `.pbo`s, `.rpt` logs, `.bisign` keys.
