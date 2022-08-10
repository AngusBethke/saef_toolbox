/**
	@namespace RS
	@class Admin
	@method RS_fnc_Admin_MissionMakerHelper
	@file fn_Admin_MissionMakerHelper.sqf
	@summary Hints out a bunch of useful information to the mission maker to let them know if something is missing.
	@param array _objects
	@param array _markers
	@param array _systems
**/

/*
	fn_Admin_MissionMakerHelper.sqf
	Description: Hints out a bunch of useful information to the mission maker to let them know if something is missing
	How to Call: [_objects, _markers, _systems] call RS_fnc_Admin_MissionMakerHelper;
*/

params
[
	"_objects",
	"_markers",
	"_systems"
];

private
[
	"_errorStr",
	"_respawnMarkers"
];

// Default Variables
_errorStr = "";

// Check if there is a Respawn Marker
_respawnMarkers = [];
{
	_isPlayable = ((_x get3DENAttribute "ControlMP") select 0);
	if (_isPlayable) then
	{
		_side = (side _x);
		switch _side do 
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
				_text = format ["Side [%1] not recognised!", _side];
				["SAEF Toolbox Mission Maker Helper", 2, _text] call RS_fnc_LoggingHelper;
			};
		};
	};
} forEach _objects;

private
[
	"_allMapMarkers",
	"_missingResMarkers",
	"_defResFound"
];

// Get the names of our map Markers
_allMapMarkers = [];
{
	_allMapMarkers pushBack ((_x get3DENAttribute "markerName") select 0);
} forEach _markers;

// Test our respawn markers against the existing map markers
_missingResMarkers = [];
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
		_text = format ["The respawn marker '%1' is missing from your mission.", _x];
		["SAEF Toolbox Mission Maker Helper", 2, _text] call RS_fnc_LoggingHelper;
		_errorStr = _errorStr + "<br/>[SAEF Toolbox Mission Maker Helper] " + _text;

		_markerError = true;
	} forEach _missingResMarkers;
	
	if (_markerError) then
	{
		_errorStr = _errorStr + "<br/>Respawn will be broken in this scenario!<br/>";
	};
};

private
[
	"_systemNames",
	"_requiredHeadlessClients"
];

_requiredHeadlessClients =
[
	"HC1",
	"HC2",
	"HC3"
];

// Get all of our system names
_systemNames = [];
{
	if (((_x get3DENAttribute "itemClass") select 0) == "HeadlessClient_F") then
	{
		_systemNames pushBack ((_x get3DENAttribute "Name") select 0);
	};
} forEach _systems;

// Test if the Headless Client is present
{
	if (!(_x in _systemNames)) then
	{
		_text = (format ["The headless client module [%1] is missing from your mission.", _x]);
		["SAEF Toolbox Mission Maker Helper", 2, _text] call RS_fnc_LoggingHelper;
		_errorStr = _errorStr + "<br/>[SAEF Toolbox Mission Maker Helper] " + _text;
	};
} foreach _requiredHeadlessClients;

// Look for a Virtual Spectator
private
[
	"_virtualSpectatorAttributes",
	"_virtualSpectators"
];

_virtualSpectatorAttributes =
[
	["Allow3PPCamera", true],
	["AllowAI", true],
	["AllowFreeCamera", true],
	["ShowFocusInfo", false],
	["WhitelistedSides", []]
];

_virtualSpectators = [];
{
	if (((_x get3DENAttribute "itemClass") select 0) == "VirtualSpectator_F") then
	{
		_virtualSpectators pushback _x;
	};
} forEach _systems;

// If we can't find one, log it
if (_virtualSpectators isEqualTo []) then
{
	_text = "The Virtual Spectator entity is missing from your mission.";
	["SAEF Toolbox Mission Maker Helper", 2, _text] call RS_fnc_LoggingHelper;
	_errorStr = _errorStr + "<br/>[SAEF Toolbox Mission Maker Helper] " + _text;
};

// Ensure the virtual spectator has the right attributes
{
	private
	[
		"_virtualSpectator"
	];

	_virtualSpectator = _x;

	{
		_x params
		[
			"_virtualSpectatorAttribute",
			"_virtualSpectatorExpectedValue"
		];

		(_virtualSpectator get3DENAttribute _virtualSpectatorAttribute) params ["_virtualSpectatorActualValue"];

		if (!(_virtualSpectatorActualValue isEqualTo _virtualSpectatorExpectedValue)) then
		{
			_text = (format ["The Virtual Spectator attribute [%1] is currently [%2] but should be [%3]", _virtualSpectatorAttribute, _virtualSpectatorActualValue, _virtualSpectatorExpectedValue]);
			["SAEF Toolbox Mission Maker Helper", 2, _text] call RS_fnc_LoggingHelper;
			_errorStr = _errorStr + "<br/>[SAEF Toolbox Mission Maker Helper] " + _text;
		};
	} forEach _virtualSpectatorAttributes;
} forEach _virtualSpectators;

private
[
	"_zeusFound"
];

// Look for a Zeus Module
_zeusFound = false;
{
	if (((_x get3DENAttribute "itemClass") select 0) == "ModuleCurator_F") then
	{
		_zeusFound = true;
	};
} forEach _systems;

// If we can't find one, log it
if (!_zeusFound) then
{
	_text = "The Zeus Game Master Module is missing from your mission.";
	["SAEF Toolbox Mission Maker Helper", 2, _text] call RS_fnc_LoggingHelper;
	_errorStr = _errorStr + "<br/>[SAEF Toolbox Mission Maker Helper] " + _text;
};

// Return our error string
_errorStr

/*
	END
*/