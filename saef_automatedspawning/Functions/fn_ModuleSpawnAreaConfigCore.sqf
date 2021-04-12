/*
	fn_ModuleSpawnAreaConfigCore.sqf

	Description:
		Handles module functionality for spawn areas
*/

if (!isServer) exitWith {};

if (is3DEN) exitWith {};

private
[
	"_scriptTag"
];
_scriptTag = "SAEF_AS_fnc_ModuleSpawnAreaConfigCore";

params
[
	 ["_logic", objNull, [objNull]]
	,["_units", [], [[]]]
	,["_activated", true, [true]]
];

private
[
	"_infoArray",
	"_tag"
];
_infoArray = [];
_tag = _logic getVariable ["Tag", ""]; 

// If our module is active then we execute
if (_activated) then 
{
	private
	[
		"_name"
		,"_sideString"
		,"_blockPatrol"
		,"_blockGarrison"
		,"_defaultEnding"
		,"_side"
		,"_areaTags"
		,"_tagFound"
	];

	_name = _logic getVariable ["Name", ""]; 
	_sideString = _logic getVariable ["Side", "east"]; 
	_blockPatrol = _logic getVariable ["BlockPatrol", false]; 
	_blockGarrison = _logic getVariable ["BlockGarrison", false]; 
	_defaultEnding = _logic getVariable ["DefaultEnding", true]; 

	if (_tag == "") exitWith
	{
		_infoArray pushBack [1, ("Tag is empty, configuration cannot be created!")];
	};

	// Forcefully lower case of tag
	_tag = toLower(_tag);

	// Remove white space
	_tag = (_tag splitString " ") joinString "";

	if (_name == "") then
	{
		_name = format ["%1_name", _tag];
	};

	// Process the side
	_sideString = toLower(_sideString);
	_side = (call compile _sideString);

	// Fetch our existing area tags
	_areaTags = (missionNamespace getVariable ["SAEF_AreaMarkerTags", []]);

	// If we already have a tag then we should ditch out, no overridding config
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
		};
	} forEach _areaTags;

	if (_tagFound) exitWith
	{
		_infoArray pushBack [1, (format ["Cannot create configuration that has already been defined!"])];
	};

	// Validation step
	([_logic, _tag] call SAEF_AS_fnc_ConfigCoreValidation) params
	[
		"_newConfigArray",
		"_valid",
		"_updatedInfoArray"
	];

	_infoArray = _infoArray + _updatedInfoArray;

	if (!_valid) exitWith {};

	// Validation complete, time for config setup
	private
	[
		"_tagConfig",
		"_tags",
		"_sideVariable",
		"_config"
	];

	// Tags first
	_tagConfig = (format ["%1_config", _tag]);

	_tags = 
	[
		_tag,
		_name,
		_tagConfig
	];

	_areaTags = (missionNamespace getVariable ["SAEF_AreaMarkerTags", []]);
	_areaTags pushBack _tags;
	missionNamespace setVariable ["SAEF_AreaMarkerTags", _areaTags, true];

	// Config second
	_sideVariable = (format ["%1_side", _tag]);

	_config = 
	[
		_blockPatrol 											// Block the Patrol Portion of the Area
		,_blockGarrison 										// Block the Garrison Portion of the Area
		,((_newConfigArray select 0) select 0) 					// Variable pointer to array of units for spawning
		,_sideVariable 											// Variable pointer to side of units for spawning
		,((_newConfigArray select 1) select 0)  					// Variable pointer to array of light vehicles for spawning
		,((_newConfigArray select 2) select 0)  					// Variable pointer to array of heavy vehicles for spawning
		,((_newConfigArray select 3) select 0) 					// Variable pointer to array of paradrop vehicles for spawning
		,{true} 												// Optional: Code block for extra validation passed to GetClosestPlayer
		,[] 													// Optional: Array of scripts run against the spawned group
		,{true}													// Optional: Code block for extra validation passed to the Message Queue
		,_defaultEnding											// Optional: Whether or not to include the default ending detector
	];

	missionNamespace setVariable [_tagConfig, _config, true];
	
	// Config pieces third
	missionNamespace setVariable [_sideVariable, _side, true];

	{
		_x params
		[
			"_configName"
			,"_classnames"
		];

		missionNamespace setVariable [_configName, _classnames, true];
	} forEach _newConfigArray;

	// Cleanup all the sync'd modules
	{
		deleteVehicle _x;
	} forEach (synchronizedObjects _logic);

	// Setup complete
	_infoArray pushBack [3, (format ["Setup Complete!"])];
};

// Compile our info hint and log messages
private
[
	"_tInfoHolder",
	"_infoString"
];

_infoString = "";
_tInfoHolder = (format ["[%1] Configuration Info:", _tag]);
[_scriptTag, 3, _tInfoHolder] call RS_fnc_LoggingHelper;

_infoString = _infoString + _tInfoHolder;
{
	_x params
	[
		"_logLevel"
		,"_tInfoString"
	];

	_tInfoHolder = (format ["[%1] %2", _tag, _tInfoString]);
	[_scriptTag, _logLevel, _tInfoHolder] call RS_fnc_LoggingHelper;

	_infoString = _infoString + "\n" + _tInfoHolder;
} forEach _infoArray;

// Hint the message to Zeus
if (missionNamespace getVariable ["SAEF_AutomatedSpawning_ZeusHint", false]) then
{
	[_infoString] remoteExecCall ["SAEF_AS_fnc_CuratorHint", 0, false];
};

// Processing Complete
_logic setVariable ["ProcessingComplete", true, true];

// Return Function Success
true