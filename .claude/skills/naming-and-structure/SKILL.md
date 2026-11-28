---
name: naming-and-structure
description: Where SAEF code and files live and what they are called — mission folder layout, the framework overlay, toolbox components, CfgFunctions tags and fn_ files, which layer (mission, framework or toolbox) owns a piece of code, and how to move files. Use when adding a file or function, creating a folder, choosing a function tag, deciding where shared code goes, or moving or renaming files in SAEF-Mission-Framework or saef_toolbox.
---

# Naming conventions and folder structure

Names inside code (variables, params) follow the clean-code skill.

## Three layers, one direction

| Layer | Repo / folder | Holds | Ships as |
| --- | --- | --- | --- |
| Toolbox | `saef_toolbox/<component>/` | Reusable functions any mission can call | Workshop mod `@saef_toolbox` |
| Framework | `SAEF-Mission-Framework/framework/` | The standard mission skeleton: init flow (`FMW`), loadout helpers, glue scripts | Linked into each mission |
| Mission | `SAEF-Mission-Framework/missions/<modset>/<campaign>/<Mission.World>/` | What only this mission does: `mission.sqm`, briefing, tasks, loadouts, mission scripts | The mission PBO |

- Missions may use the framework and the toolbox; the framework may use the toolbox; the toolbox uses
  neither. Nothing in the toolbox names a mission, a campaign or a framework path.
- Code used by **two or more missions** belongs in the framework; code that is useful outside the
  mission skeleton (a reusable feature) belongs in the toolbox. Code one mission uses stays in that
  mission.
- Missions call toolbox functions directly. Don't add wrapper scripts that forward to a function.

## Missions

- Layout: `missions/<modset>/<campaign>/<Mission.World>/`. Modsets are `modern` (after 1989) and
  `historic` (1989 and earlier). Campaign folders are kebab-case slugs (`operation-anaconda`,
  `the-long-road`); missions with no campaign go in `missions/<modset>/misc/`.
- Only missions whose folder starts with `SAEF_` are in scope.
- The mission folder name is the released name, `SAEF_<Name>.<worldName>`, and never changes.
- `mission.sqm` is kept as **text**, never binarized, so it diffs and `saef check` can read its
  trigger code.
- A mission owns only the files it changes. Everything else comes from `framework/` through
  `saef link` (junctions for whole folders, hard links for single files). A mission file at the same
  path wins over the framework's.
- Per-mission switches go in `description.ext` as `SAEF_FMW_<Context>_<Step> = 0;`; CBA setting
  overrides go in `cba_settings.mission.sqf`.

## Framework

`framework/` mirrors a mission root: `FMW/`, `Toolbox/`, `Loadouts/Helpers`, `Loadouts/Factions`,
`Scripts/<Area>/`.

- `FMW/Functions/` holds the framework's own functions, registered in `FMW/Functions.hpp` under the
  `SAEF_FMW` tag (`SAEF_FMW_fnc_InitServer`, `SAEF_FMW_fnc_Enabled`).
- Mission scripts are grouped by area: `Scripts/Mission/`, `Scripts/Player/`, `Scripts/AI/`,
  `Scripts/Vehicle/`, `Scripts/Utility/`.
- Tests live in `tests/` (framework tests) and a mission's `FMW\Tests\TestList.sqf`.
- Presets per modset: `presets/<modset>/mods.txt` and `presets/<modset>/cba_settings.sqf`.

## Toolbox

- One component per system: `saef_<system>/` (lower case, no separators), with `config.cpp`
  declaring `CfgPatches` class `SAEF_TOOLBOX_<SYSTEM>` and its `CfgFunctions`.
- Functions live in `saef_<system>/Functions/fn_<Name>.sqf`. New code groups methods into a class
  file called with a `_type` method name (`["GetAll"] call SAEF_AID_fnc_Track`; see clean-code), so
  `<Name>` is the concept (`Player`, `Track`, `Difficulty`), not a verb. Scripts that must be run by path (for
  example admin actions that `execVM` a path) live in `saef_<system>/Scripts/<Name>.sqf` and are
  referenced as `\saef_<system>\Scripts\<Name>.sqf`.
- Function tags: new components use `SAEF_<SHORT>` (`SAEF_ENV`, `SAEF_VEH`, `SAEF_AS`); older ones
  use `RS` / `RS_<SHORT>` (`RS_fnc_RespawnPoints`, `RS_LD_fnc_GroupLoadout`). Keep a component's
  existing tag; don't rename published functions, because missions call them by name.
- Every function starts with the documentation header (`@namespace`, `@class`, `@method`, `@file`,
  `@summary`, `@param`, `@return`) that `saef_toolbox.json` is generated from.

## Names stand alone

A function is read without its folder: in RPT logs, in Zeus debug consoles and in search. Its name
says what it does: `SAEF_VEH_fnc_WaitForPlayersInVehicle`, not `SAEF_VEH_fnc_Wait`.
PascalCase for function names, file names and folders inside a component (`Functions/`, `Scripts/`).

## Moving files

- Moves go in **their own PR** (`refactor:`), never mixed into a feature, so the real diff stays
  readable.
- Moving code into the toolbox is a cross-repo change: the toolbox PR adds the function, then the
  framework PR switches every caller to it and deletes the old file (see pr-format).
- Update in the same PR every caller: `.sqf`, `.hpp`, `description.ext`, and trigger and init code
  in `mission.sqm`. Search for the old path or name across `framework/` and `missions/`, and note any
  mission that owns its own copy (its copy wins and keeps working).
- Run `saef check` on every affected mission and `saef test` on a spread before pushing.
