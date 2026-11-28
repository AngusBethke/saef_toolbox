/*
	Moved to saef_toolbox from the SAEF Mission Framework (Scripts\AI\GroupLoadout.sqf).
*/

/*
	GroupLoadout.sqf

	Description;
		Distributes loadout to a group

	How to Call:
		[_group] spawn RS_LD_fnc_GroupLoadout;
*/

params
[
	"_group"
];

{
	_x params ["_unit"];

	[_unit] execVM "Loadouts\Core.sqf";
} forEach (units _group);