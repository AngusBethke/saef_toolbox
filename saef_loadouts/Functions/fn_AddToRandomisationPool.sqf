/**
	@namespace RS_LD
	@class Loadouts
	@method RS_LD_fnc_AddToRandomisationPool
	@file fn_AddToRandomisationPool.sqf
	@summary Adds to the randomisation pool for the specified tag
	
	@param string _gearItem
	@param string _randomisationTag

	
**/

/*
	fn_AddToRandomisationPool.sqf

	Description:
		Adds to the randomisation pool for the specified tag
*/

// Only the server should handle this
if (!isServer) exitWith {};

params
[
	"_gearItem", 
	"_randomisationTag"
];

private
[
	"_variable",
	"_values"
];

// Generate our variable name
_variable = (format ["SAEF_Loadout_%1", _randomisationTag]);

// Get the values and add to them
_values = missionNamespace getVariable [_variable, []];
_values pushBackUnique _gearItem;

// Update the variable
missionNamespace setVariable [_variable, _values, true];