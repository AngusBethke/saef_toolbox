/*
	fn_Handler.sqf
	Description: Handles creation of Civilian Presence Modules
	Parameters:	
		_debug 			- bool (possibly int enum)
		_createdCode 	- string
		_deletedCode 	- string
		_useAgents 		- bool (possibly int enum)
		_usePanicMode 	- bool (possibly int enum)
*/

params
[
	"_debug",
	"_createdCode",
	"_deletedCode",
	"_useAgents",
	"_usePanicMode",
	"_whiteList",
	"_unitTypes"
];

private
[
	"_locations"
];

// Get All Locations on Map
_locations = [] call RS_LC_fnc_ListLocations;

// Whitelisted Locations
if (_whiteList != "") then
{
	_locations = [_whiteList] call RS_CP_fnc_GetWhiteListedLocations;
};

{
	["RS Civilian Presence", 3, (format ["Creating Civilian Presence Module at Location: %1", text _x])] call RS_fnc_LoggingHelper;
	
	[_x, _debug, _createdCode, _deletedCode, _useAgents, _usePanicMode, _whiteList, _unitTypes, _locations] call RS_CP_fnc_SpawnPresenceModule;
} forEach _locations;