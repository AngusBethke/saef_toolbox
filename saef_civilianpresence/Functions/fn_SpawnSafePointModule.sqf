#include "\A3\Modules_F_Tacops\Ambient\CivilianPresence\defines.inc"

/*
	fn_SpawnPresenceModule.sqf
	Description: Handles creation of the Civilian Presence Safe Point
	Parameters:	
		_pos			- position
		_capacity 		- int
		_isTerminal 	- bool (possibly int enum)
		_type 			- int(enum) | 1 Safe Spot, 2 Waypoint and Safe Spot, 3 Waypoint
		_useBuiilding 	- bool (possibly int enum)
*/

params
[
	"_pos",
	"_group",
	"_capacity",
	"_isTerminal",
	"_type",
	"_useBuilding"
];

private
[
	"_logic"
];

// Create the Logic
_logic = _group createUnit ["Logic",_pos,[],0,"NONE"]; // ModuleCivilianPresenceSafeSpot_F
_logic setVariable ["LogicType", "ModuleCivilianPresenceSafeSpot_F", true];

// Set the Logic's Parameters
_logic setVariable ["#capacity", _capacity, true]; 
_logic setVariable ["#isTerminal", _isTerminal, true]; 
_logic setVariable ["#type", _type, true]; 
_logic setVariable ["#useBuilding", _useBuilding, true]; 

// Return Module
_logic

// _logic setVariable ["CivilianPresenceSafeSpot_Capacity", _capacity]; 
// _logic setVariable ["CivilianPresenceSafeSpot_IsTerminal", _isTerminal]; 
// _logic setVariable ["CivilianPresenceSafeSpot_Type", _type]; 
// _logic setVariable ["CivilianPresenceSafeSpot_UseBuilding", _useBuiilding]; 