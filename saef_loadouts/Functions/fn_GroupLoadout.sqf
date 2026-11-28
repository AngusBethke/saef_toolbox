/*
	Moved to saef_toolbox from the SAEF Mission Framework (Scripts\AI\GroupLoadout.sqf).
	The framework keeps Scripts\AI\GroupLoadout.sqf as a wrapper that forwards to RS_LD_fnc_GroupLoadout.
*/

/*
	GroupLoadout.sqf

	Description;
		Distributes loadout to a group

	How to Call:
		[_group] execVM "Scripts\AI\GroupLoadout.sqf";
*/

params
[
	"_group"
];

{
	_x params ["_unit"];

	[_unit] execVM "Loadouts\Core.sqf";
} forEach (units _group);