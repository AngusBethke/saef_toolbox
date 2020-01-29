#include "\A3\Modules_F_Tacops\Ambient\CivilianPresence\defines.inc"

/*
	fn_CP_SpawnPresenceModule.sqf
	Description: Handles creation of the Civilian Presence Safe Point
	Parameters:	
		_pos			- position
		_capacity 		- int
		_isTerminal 	- bool (possibly int enum)
		_type 			- int(enum) | 1 Safe Spot, 2 Waypoint and Safe Spot, 3 Waypoint
		_useBuiilding 	- bool (possibly int enum)
*/

// Input Parameters
_pos = _this select 0;
_group = _this select 1;
_capacity = _this select 2;
_isTerminal = _this select 3;
_type = _this select 4;
_useBuilding = _this select 5;

// Create the Logic
_logic = _group createUnit ["ModuleCivilianPresenceSafeSpot_F",_pos,[],0,"NONE"]; 

// Set the Logic's Parameters
_logic setVariable ["#capacity", _capacity]; 
_logic setVariable ["#isTerminal", _isTerminal]; 
_logic setVariable ["#type", _type]; 
_logic setVariable ["#useBuilding", _useBuilding]; 

// Return Module
_logic

// _logic setVariable ["CivilianPresenceSafeSpot_Capacity", _capacity]; 
// _logic setVariable ["CivilianPresenceSafeSpot_IsTerminal", _isTerminal]; 
// _logic setVariable ["CivilianPresenceSafeSpot_Type", _type]; 
// _logic setVariable ["CivilianPresenceSafeSpot_UseBuilding", _useBuiilding]; 