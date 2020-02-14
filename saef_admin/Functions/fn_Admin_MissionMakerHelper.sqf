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
		_markerError = true;
	} forEach _missingResMarkers;
	
	if (_markerError) then
	{
		_errorStr = _errorStr + "<br/>Respawn will be broken in this scenario!<br/>";
	};
};

// Test for Custom Marker Presence
_customMarkers = missionNamespace getVariable ["RS_Admin_CustomMarkerExistenceTest", []];

{
	if (!(_x in _allMapMarkers)) then
	{
		_errorStr = _errorStr + "<br/>The custom marker '" + _x + "', that should be present, is missing!";
	};
} forEach _customMarkers;

if (_errorStr != _evalErrorStr) then
{
	hint _errorStr;
};

/*
	END
*/