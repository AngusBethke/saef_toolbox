/*
	fn_Admin_MissionMakerHelper.sqf
	Description: Hints out a bunch of useful information to the mission maker to let them know if something is missing
*/

// Throw in a little delay in case some stuff needs initialisation
sleep 10;

// Default Variables
_errorStr = "Mission Evaluation (the following errors were found): ";
_evalErrorStr = _errorStr;

// Check if there is a Respawn Marker
_respawnMarkers = [];
{
	switch (side _x) do 
	{
		case WEST : {
			_respawnMarkers pushbackUnique "respawn_west";
		};
		case EAST : {
			_respawnMarkers pushbackUnique "respawn_east";
		};
		case INDEPENDENT : {
			_respawnMarkers pushbackUnique "respawn_guerrila";
		};
		case CIVILIAN : {
			_respawnMarkers pushbackUnique "respawn_civilian";
		};
		default {
			diag_log format ["[RS] [ADMIN] [Mission Maker Helper] [WARNING] Side (%1) not recognised!", (side _x)];
		};
	};
} forEach (allPlayers - entities "HeadlessClient_F");

// Test our respawn markers against the existing map markers
_missingResMarkers = [];
_allMapMarkers = allMapMarkers;
{
	if (!(_x in _allMapMarkers)) then
	{
		_missingResMarkers = _missingResMarkers + [_x];
	};
} forEach _respawnMarkers;

// Check if the default marker is present
_defResFound = false;
if ("respawn" in _allMapMarkers) then
{
	_defResFound = true;
};

if (!_defResFound) then
{
	_markerError = false;
	{
		_errorStr = _errorStr + "<br/>The respawn marker '" + _x + "' is missing from your mission.";
		diag_log format ["[RS] [ADMIN] [Mission Maker Helper] [WARNING] The respawn marker '%1' is missing from your mission.", _x];
		_markerError = true;
	} forEach _missingResMarkers;
	
	if (_markerError) then
	{
		_errorStr = _errorStr + "<br/>Respawn will be broken in this scenario!<br/>";
	};
};

// Test if the Headless Client is present
if (isNil "HC1") then
{
	_errorStr = _errorStr + "<br/>The headless client module [HC1] is missing from your mission.<br/>";
	diag_log format ["[RS] [ADMIN] [Mission Maker Helper] [WARNING] The headless client module [HC1] is missing from your mission."];
};

// Test for Custom Marker Presence
_customMarkers = missionNamespace getVariable ["RS_Admin_CustomMarkerExistenceTest", []];

{
	if (!(_x in _allMapMarkers)) then
	{
		_errorStr = _errorStr + "<br/>The custom marker '" + _x + "', that should be present, is missing!";
		diag_log format ["[RS] [ADMIN] [Mission Maker Helper] [WARNING] The custom marker '%1', that should be present, is missing!", _x];
	};
} forEach _customMarkers;

if (_errorStr != _evalErrorStr) then
{
	hint parseText _errorStr;
};

/*
	END
*/