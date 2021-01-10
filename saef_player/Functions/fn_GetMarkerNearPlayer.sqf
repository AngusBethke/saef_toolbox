/*
	fn_GetMarkerNearPlayer.sqf

	Description:
		Locates a marker within certain thresholds based on a given tag

	How to Call:
		[
			_markerTag,					// Tag of the marker
			_maxSearchDistance,			// Max distance to search for the marker
			_playerDistanceThreshold	// How close the marker can be to the players
		] call RS_PLYR_fnc_GetMarkerNearPlayer;
*/

params
[
	"_markerTag"
	,["_maxSearchDistance", 1000]
	,["_playerDistanceThreshold", 250]
];

private
[
	"_markers"
	,"_hkMarkers"
	,"_possibleSpawnMarkers"
	,"_spawnMarkers"
	,"_marker"
];

// Check if any markers with the tag exist on the map
_markers = allMapMarkers;
_hkMarkers = [];

{
	if ([_markerTag, _x] call BIS_fnc_inString) then
	{
		_hkMarkers = _hkMarkers + [_x];
	};
} forEach _markers;

if (_hkMarkers isEqualTo []) exitWith
{
	["RS_PLYR_fnc_GetMarkerNearPlayer", 2, (format ["No Markers on Map with tag [%1]!", _markerTag])] call RS_fnc_LoggingHelper;

	// Return an empty string
	""
};

// Check for markers within the max search distance
_possibleSpawnMarkers = [];

{
	_closePlayer = [(markerPos _x), _maxSearchDistance] call RS_PLYR_fnc_GetClosestPlayer;
	if !(_closePlayer isEqualTo [0,0,0]) then
	{
		_possibleSpawnMarkers = _possibleSpawnMarkers + [_x];
	};
} forEach _hkMarkers;

if (_possibleSpawnMarkers isEqualTo []) exitWith
{
	["RS_PLYR_fnc_GetMarkerNearPlayer", 2, (format ["No Nearby Markers on Map with tag [%1]!", _markerTag])] call RS_fnc_LoggingHelper;

	// Return an empty string
	""
};

// If we have any of those markers make sure they are further away than the player threshold
_spawnMarkers = [];

{
	_closePlayer = [(markerPos _x), _playerDistanceThreshold] call RS_PLYR_fnc_GetClosestPlayer;
	if (_closePlayer isEqualTo [0,0,0]) then
	{
		_spawnMarkers = _spawnMarkers + [_x];
	};
} forEach _possibleSpawnMarkers;

if (_spawnMarkers isEqualTo []) exitWith
{
	["RS_PLYR_fnc_GetMarkerNearPlayer", 2, (format ["Players are too close to the Markers on Map with tag [%1]!", _markerTag])] call RS_fnc_LoggingHelper;

	// Return an empty string
	""
};

// If we have some markers after all the tests, then grab a random one
_marker = selectRandom _spawnMarkers;

// Return the Marker
_marker