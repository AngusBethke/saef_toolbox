/*
	fn_CP_Handler.sqf
	Description: Handles creation of Civilian Presence Modules
	Parameters:	
		_debug 			- bool (possibly int enum)
		_createdCode 	- string
		_deletedCode 	- string
		_useAgents 		- bool (possibly int enum)
		_usePanicMode 	- bool (possibly int enum)
*/

// Input Parameters
_debug = _this select 0;
_createdCode = _this select 1;
_deletedCode = _this select 2;
_useAgents = _this select 3;
_usePanicMode = _this select 4;
_whiteList = _this select 5;

// Get All Locations on Map
_locations = [] call RS_LC_fnc_ListLocations;

// Whitelisted Locations
if (_whiteList) then
{
	_locations = [] call RS_fnc_CP_GetWhiteListedLocations;
};

// Spawn Civilian Presence Modules
diag_log format ["[RS Civilian Presence] [INFO] Civilian Presence Launching..."];

{
	diag_log format ["[RS Civilian Presence] [INFO] Creating Civilian Presence Module at Location: %1", text _x];
	
	[_x, _debug, _createdCode, _deletedCode, _useAgents, _usePanicMode] call RS_fnc_CP_SpawnPresenceModule;
} forEach _locations;