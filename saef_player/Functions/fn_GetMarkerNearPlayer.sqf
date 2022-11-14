/**
	@namespace RS_PLYR
	@class PlayerFunctions
	@method RS_PLYR_fnc_GetMarkerNearPlayer
	@file fn_GetMarkerNearPlayer.sqf
	@summary Locates a marker within certain thresholds based on a given tag

	@param string _markerTag
	@param ?int _maxSearchDistance
	@param ?int _playerDistanceThreshold

	@return marker _marker

	@usage ```[_markerTag, _maxSearchDistance, _playerDistanceThreshold] call RS_PLYR_fnc_GetMarkerNearPlayer;```

**/

/*
	fn_GetMarkerNearPlayer.sqf

	Description:
		Locates a marker within certain thresholds based on a given tag

	How to Call:
		[
			_markerTag,					// Tag of the marker
			_maxSearchDistance,			// Max distance to search for the marker
			_playerDistanceThreshold,	// How close the marker can be to the players
			_useMarkerFilter			// Whether or not to use the filter mechanism
		] call RS_PLYR_fnc_GetMarkerNearPlayer;
*/

params
[
	"_markerTag"
	,["_maxSearchDistance", 1000]
	,["_playerDistanceThreshold", 250]
	,["_useMarkerFilter", false]
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

// If we use the marker filter
if (_useMarkerFilter) then
{
	private
	[
		"_filteredMarkers"
	];

	_filteredMarkers = [];

	// Check all the markers to see if any are currently locked
	{
		private
		[
			"_markerVariable"
		];

		_markerVariable = (format ["SAEF_PLYR_MarkerLocked_%1", _x]);

		if (!(missionNamespace getVariable [_markerVariable, false])) then
		{
			_filteredMarkers pushBack _x;
		};
	} forEach _spawnMarkers;

	// If any aren't locked, use them
	if (!(_filteredMarkers isEqualTo [])) then
	{
		_spawnMarkers = _filteredMarkers;
	};
};

// If we have some markers after all the tests, then grab a random one
_marker = selectRandom _spawnMarkers;

// Ensure that we lock the markers, then release the lock after 30 seconds
if (_useMarkerFilter) then
{
	private
	[
		"_markerVariable"
	];

	_markerVariable = (format ["SAEF_PLYR_MarkerLocked_%1", _marker]);

	missionNamespace setVariable [_markerVariable, true, true];

	[_markerVariable] spawn {
		params
		[
			"_markerVariable"
		];

		sleep 30;

		missionNamespace setVariable [_markerVariable, nil, true];
	};
};

// Return the Marker
_marker