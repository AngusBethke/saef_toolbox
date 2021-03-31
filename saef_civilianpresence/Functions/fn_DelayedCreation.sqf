/*
	fn_DelayedCreation.sqf

	Description: Holds creation of the civ presence zone until players are near it
*/

params
[
	"_locationPos",
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
	"_location",
	"_script",
	"_j",
	"_locations"
];

// Get current location
_location = nearestLocation [_locationPos, ""];

_script = "RS Civilian Presence";
[_script, 4, (format ["Starting wait for Player: %1", (text _location)])] call RS_fnc_LoggingHelper;

// Get All Locations on Map
_locations = [] call RS_LC_fnc_ListLocations;

// Whitelisted Locations
if (_whiteList != "") then
{
	_locations = [_whiteList] call RS_CP_fnc_GetWhiteListedLocations;
};

([(getPos _location), _locations, (missionNamespace getVariable ["SAEF_CivilianPresence_SupportedLocationTypes", ["NameCity", "NameCityCapital", "NameVillage"]])] call RS_CP_fnc_GetPositionInfo) params
[
	"_posArray"
	,"_distArray"
	,"_minDist"
	,"_sizeLoc"
	,"_size"
];

_j = 1;
waitUntil {
	// Suspend
	sleep 5;

	private
	[
		"_valid",
		"_tooClose",
		"_closePlayer"
	];

	_valid = false;
	_tooClose = false;
	
	// Test if player is close by
	_closePlayer = [(getPos _location), (_size + 500)] call RS_PLYR_fnc_GetClosestPlayer;
	
	// If there is a player close by
	if (!(_closePlayer isEqualTo [0,0,0])) then
	{
		_tooClose = ((_closePlayer distance (getPos _location)) < 5);
		_valid = (!_tooClose);
	};
	
	// Log every 3 minutes
	if (_j == 36) then
	{
		_j = 1;
		
		if (_tooClose) then
		{
			[_script, 2, (format ["Polling | Players too close to conduct spawning: %1", (text _location)])] call RS_fnc_LoggingHelper;
		}
		else
		{
			[_script, 4, (format ["Polling | Waiting for Player: %1", (text _location)])] call RS_fnc_LoggingHelper;
		};
	};
	_j = _j + 1;
	
	// Condition met
	_valid
};

[_script, 4, (format ["Wait for Player Finished: %1", (text _location)])] call RS_fnc_LoggingHelper;

// Execute the spawn presence module now
[_location, _debug, _createdCode, _deletedCode, _useAgents, _usePanicMode, _whiteList, _unitTypes, _locations] spawn RS_CP_fnc_SpawnPresenceModule;