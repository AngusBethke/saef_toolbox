---
name: clean-code
description: Clean-code rules for SQF in the SAEF repos (summary of "Clean Code" by Robert C. Martin, adapted to Arma 3) — general and design rules, naming, functions, comments, structure, tests, code smells, and the SQF house rules (params, private, locality, scheduled code, no includes in .sqf). Use when writing or refactoring any SQF, config or tooling code, when asked "is this clean", "clean this up", or when judging the maintainability of a change under review.
---

# Clean Code

Code is clean if it can be understood easily – by everyone in the group who makes missions. Clean
code can be read and enhanced by a mission maker other than its original author.

## Scope

- Apply these rules to the code you write or change. Flag problems in surrounding code (much of it
  is years old) instead of rewriting it, unless cleaning it up is the task.
- When two rules conflict, readability for the next mission maker wins.
- When a rule here conflicts with how Arma or CBA works, the engine wins.

## General rules

- Follow standard conventions (BI and CBA function patterns, the toolbox's existing style).
- Keep it simple. Reduce complexity as much as possible.
- Always find the root cause. Read the RPT before changing code.

## Design rules

- Keep configurable data at high levels: per-mission switches in `description.ext`, unit lists and
  areas in `initMissionSetup.sqf`, not buried in functions.
- Prevent over-configurability. Add a parameter when a second mission needs it, not before.
- Pass what a function needs as parameters; don't reach for mission globals from inside a toolbox
  function.
- Reuse before writing: check the toolbox, CBA and BI functions (`BIS_fnc_*`) first.

## SQF house rules

- Every function starts with `params` and gives optional parameters defaults and types:
  `params ["_unit", ["_force", false, [false]]];`.
- Declare locals with `private`. Never leak `_vars` into a caller's scope.
- Guard clauses with `exitWith` instead of deep `if` nesting.
- Call functions (`call`/`spawn SAEF_X_fnc_Y`), don't `execVM` paths. Compile-once functions are
  faster and show up by name in errors. `execVM` a path only where an API demands a path.
- No `#include` in `.sqf` files. Register functions through `CfgFunctions` instead.
- `call` when the caller is scheduled or the code is quick; `spawn` when the code `sleep`s,
  `waitUntil`s, or must not block an unscheduled caller (event handlers, triggers).
- Know where code runs. Check `isServer`, `hasInterface` and `local` at the top of anything that
  must run on one machine; use `remoteExec`/`remoteExecCall` with the narrowest target.
- Broadcast deliberately: `setVariable [..., true]` and `publicVariable` send to every machine and
  every JIP client. Only share what others need.
- Log through `RS_fnc_LoggingHelper` with the function name, not bare `diag_log`.

## Names rules

- Choose descriptive and unambiguous names. `_extractionHeli`, not `_h`.
- Make meaningful distinctions. Use searchable names.
- Replace magic numbers with named values or parameters.
- Globals and `missionNamespace` variables carry a tag (`SAEF_`, `RS_`) so they don't collide with
  other mods.

## Functions rules

- Small. Do one thing. Prefer fewer arguments.
- No hidden side effects: a function's name (or method name, below) says what state it changes.
- Don't use boolean flag arguments to select behaviour. Use a separate method instead.

## Toolbox functions are "classes" with methods

New and refactored toolbox code follows the pattern in `saef_aidirector`: one `fn_<Class>.sqf` per
concept, called as `["<Method>", [<args>]] call SAEF_<TAG>_fnc_<Class>`.

```sqf
params ["_type", ["_params", []]];

private _scriptTag = "SAEF AID Player";

/*
	-- GETGROUPSTATUSFACTOR --
	What the method does, what it returns.
*/
if (toUpper _type == "GETGROUPSTATUSFACTOR") exitWith
{
	_params params ["_group", ["_logStatus", false]];
	...
};

[_scriptTag, 2, format ["Unrecognised type [%1], nothing is being executed!", _type]] call RS_fnc_LoggingHelper;
```

- Each method is one `if (toUpper _type == "METHOD") exitWith { ... };` block with its own
  `_params params [...]` and a header comment; the method name is PascalCase at the call site.
- Methods call each other through the function (`["Get"] call SAEF_AID_fnc_Difficulty`), and helper
  methods live in the same file as the methods that use them.
- The file ends by logging an unrecognised `_type`, so a typo shows in the RPT instead of doing
  nothing.
- State is not held by the function. Keep it in `missionNamespace` variables named
  `SAEF_<TAG>_<Name>`, read and written through `Get`/`Set` methods of the owning class so no other
  code touches the variable directly. Broadcast (`true`) only when other machines read it.
- Keep a class to one concept. When a file grows past a handful of unrelated methods, split it.
- Existing published functions keep working while they are converted (see review, toolbox API
  compatibility).

## Comments rules

- Explain yourself in code first.
- Don't be redundant or add obvious noise. Don't comment out code; delete it (git remembers).
- Use comments for intent, clarification, and warnings ("runs on every client", "must be spawned").
- Toolbox functions keep the documentation header (see naming-and-structure).

## Source code structure

- Separate concepts vertically; keep related code dense.
- Declare variables close to their usage.
- Keep lines at 120 characters or fewer. Tabs for indentation, as the existing code does.
- Don't break indentation.

## Tests

- One concept per test; several asserts are fine when they check the same behaviour
  (`SAEF_FMW_fnc_Assert`).
- Readable, fast, independent, repeatable. A test that needs a player connected says so.

## Code smells

- Rigidity: a small change causes a cascade of changes across missions.
- Fragility: one change breaks many missions. Run `saef check` on all of them.
- Immobility: code copied into every mission instead of shared through the framework or toolbox.
- Needless complexity. Needless repetition. Opacity.
