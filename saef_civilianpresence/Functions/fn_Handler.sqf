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
	,"_isWhitelisted"
];

// Get All Locations on Map
_locations = [] call RS_LC_fnc_ListLocations;

// Whitelisted Locations
_isWhitelisted = false;
if (_whiteList != "") then
{
	_locations = [_whiteList] call RS_CP_fnc_GetWhiteListedLocations;
	_isWhitelisted = true;
};

{
	["RS Civilian Presence", 4, (format ["Creating Civilian Presence Module at Location: %1", text _x])] call RS_fnc_LoggingHelper;
	
	if (_isWhitelisted) then
	{
		[_x, _debug, _createdCode, _deletedCode, _useAgents, _usePanicMode, _whiteList, _unitTypes, _locations] call RS_CP_fnc_SpawnPresenceModule;
	}
	else
	{
		["RS_CP_ModuleCreationQueue", [(getPos _x), _debug, _createdCode, _deletedCode, _useAgents, _usePanicMode, _whiteList, _unitTypes], "RS_CP_fnc_DelegateHandler"] call RS_MQ_fnc_MessageEnqueue;
	};
} forEach _locations;