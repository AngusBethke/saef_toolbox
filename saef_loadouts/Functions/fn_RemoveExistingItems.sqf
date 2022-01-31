/**
	@namespace RS_LD
	@class Loadouts
	@method RS_LD_fnc_RemoveExistingItems
	@file fn_RemoveExistingItems.sqf
	@summary Will remove all existing items ahead of the rest of the loadout being applied
	
	@param unit _unit The unit we're applying the loadout to

	@usage ```[_unit] call RS_LD_fnc_RemoveExistingItems;```
	
**/

/*
	fn_RemoveExistingItems.sqf

	Description:
		Will remove all existing items ahead of the rest of the loadout being applied

	How to Call:
		[
			_unit				// The unit we're applying the loadout to
		] call RS_LD_fnc_RemoveExistingItems
*/

params
[
	"_unit"
];

removeAllWeapons _unit;
removeAllItems _unit;
removeAllAssignedItems _unit;
removeUniform _unit;
removeVest _unit;
removeBackpack _unit;
removeHeadgear _unit;
removeGoggles _unit;