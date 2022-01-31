/**
	@namespace SAEF_AS
	@class AutomatedSpawning
	@method SAEF_AS_fnc_ModuleSpawnHunterKillerPosition
	@file fn_ModuleSpawnHunterKiller.sqf
	@summary Handles module functionality for hunter killer dynamic positions

	@param object _logic
	@param array _units
	@param bool _activated
	@param bool _fromQueue

	@todo Empty script? Strange.
**/
/*
	fn_ModuleSpawnHunterKillerPosition.sqf

	Description:
		Handles module functionality for hunter killer dynamic positions
*/

if (!isServer) exitWith {};

if (is3DEN) exitWith {};

private
[
	"_scriptTag"
];
_scriptTag = "SAEF_AS_fnc_ModuleSpawnHunterKillerPosition";

// Debug full parameter logging
if (missionNamespace getVariable ["SAEF_AutomatedSpawning_ExtendedLogging", false]) then
{
	[_scriptTag, 4, (format ["Debug Parameters: %1", _this])] call RS_fnc_LoggingHelper;
};

params
[
	 ["_logic", objNull, [objNull]]
	,["_units", [], [[]]]
	,["_activated", true, [true]]
	,["_fromQueue", false, [false]]
];

private
[
	"_active"
];

// Check if the module is active
_active = _logic getVariable ["Active", false]; 

// We need to yeet out of here if the module is not yet active
if (!_active) exitWith {};

// Recursive call to make sure all of these are processed in the queue
if (!_fromQueue) exitWith
{
	private
	[
		"_params"
	];

	_params = _this;
	_params set [3, true];

	["SAEF_AS_ModuleQueue", _params, "SAEF_AS_fnc_ModuleSpawnHunterKillerPosition"] call RS_MQ_fnc_MessageEnqueue;
};

private
[
	"_infoArray",
	"_tag"
];
_infoArray = [];
_tag = _logic getVariable ["Tag", ""]; 

// If our module is active then we execute
if (_activated && _active) then 
{
	private
	[
		"_areaTags"
		,"_tagFound"
		,"_tagRelatedMarkers"
		,"_markerCode"
		,"_markerName"
		,"_marker"
	];

	if (_tag == "") exitWith
	{
		_infoArray pushBack ("Tag is empty, Spawn area will not be run!");
	};

	// Fetch our existing area tags
	_areaTags = (missionNamespace getVariable ["SAEF_AreaMarkerTags", []]);

	// Set tag settings if we have them
	_tagFound = false;
	{
		_x params
		[
			"_mTag"
			,"_tName"
			,"_configVar"
			,["_overrides", []]
		];

		if (toUpper(_mTag) == toUpper(_tag)) exitWith
		{
			_tagFound = true;
			_infoArray pushBack (format ["Found Existing Tag: %1", _mTag]);
		};
	} forEach _areaTags;

	// Find markers with our tag
	_tagRelatedMarkers = [];
	{
		if ([_tag, _x] call BIS_fnc_InString) then
		{
			_tagRelatedMarkers pushBack _x;
		};
	} forEach allMapMarkers;

	// Find an available marker name
	_markerCode = {
		params
		[
			"_tag"
			,"_tagRelatedMarkers"
		];

		private
		[
			"_markerName"
			,"_markerCreated"
			,"_counter"
		];

		_markerName = "";
		_markerCreated = false;
		_counter = 1;
		while {!(_markerCreated)} do
		{
			private
			[
				"_testMarker",
				"_testMarkerFound"
			];

			// Look for our marker
			_testMarker = toLower(format ["%1_hk_%2", _tag, _counter]);

			_testMarkerFound = false;
			{
				if (_testMarker == toLower(_x)) exitWith
				{
					_testMarkerFound = true;
				};
			} forEach _tagRelatedMarkers;

			// If we don't find it then we can use this marker
			if (!_testMarkerFound) then
			{
				_markerName = _testMarker;
				_markerCreated = true;
			};

			_counter = _counter + 1;
		};

		// Returns Marker Name
		_markerName
	};

	_markerName = [(format ["%1", _tag]), _tagRelatedMarkers] call _markerCode;

	// Create the marker
	_marker = createMarker [_markerName, (getPos _logic)];
	_marker setMarkerDir (getDir _logic);
	_marker setMarkerType "Empty";
	_infoArray pushBack (format ["Created Marker: %1", _markerName]);
}
else
{
	_infoArray pushBack ("Module is not active, hunter killer position will not be created!");
};

// Compile our info hint and log messages
private
[
	"_tInfoHolder",
	"_infoString"
];

_infoString = "";
_tInfoHolder = (format ["[%1] Hunter Killer Position Info:", _tag]);
[_scriptTag, 3, _tInfoHolder] call RS_fnc_LoggingHelper;

_infoString = _infoString + _tInfoHolder;
{
	_tInfoHolder = (format ["[%1] %2", _tag, _x]);
	[_scriptTag, 3, _tInfoHolder] call RS_fnc_LoggingHelper;

	_infoString = _infoString + "\n" + _tInfoHolder;
} forEach _infoArray;

// Hint the message to Zeus
if (missionNamespace getVariable ["SAEF_AutomatedSpawning_ZeusHint", false]) then
{
	[_infoString] remoteExecCall ["SAEF_AS_fnc_CuratorHint", 0, false];
};

// We are going to cleanup the module at this point
deleteVehicle _logic;

// Return Function Success
true