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

	// Check Logic Objects that are nearby or sync'd
	private
	[
		"_syncedObjects"
	];

	_syncedObjects = (synchronizedObjects _logic);

	if (_syncedObjects isEqualTo []) exitWith
	{
		_infoArray pushBack [1, (format ["Cannot create configuration with no synchronised entities!"])];
	};

	// Fetch information from sync'd objects
	private
	[
		"_failed"
		,"_configArray"
	];
	
	_failed = false;
	_configArray = [];

	{
		_x params ["_syncedObject"];

		_childSyncedObjects = (synchronizedObjects _syncedObject);

		if (_childSyncedObjects isEqualTo []) exitWith
		{
			_failed = true;
			_infoArray pushBack [1, (format ["Synchronised object [%1: %2] has no child synchronised objects!", _syncedObject, (typeOf _syncedObject)])];
		};

		private
		[
			"_classnames"
		];

		_classnames = [];
		{
			_x params ["_object"];
			_classnames pushBack (typeOf (vehicle _object));

			// After we've gotten the classname we need to pull this object out of the array
			_childSyncedObjects = _childSyncedObjects - [_object];

			// If this is a vehicle we need to delete the crew
			{
				_x params ["_crew"];

				if (_crew != _object) then
				{
					deleteVehicle _crew;
				};
			} forEach crew _object;

			// Cleanup the object
			deleteVehicle _object;

		} forEach _childSyncedObjects;

		switch (typeOf _syncedObject) do
		{
			case "SAEF_ModuleSpawnAreaConfigUnits":
			{
				_configArray pushBack [(format ["%1_units", _tag]), _classnames];
			};
			case "SAEF_ModuleSpawnAreaConfigLightVehicles":
			{
				_configArray pushBack [(format ["%1_lightvehicles", _tag]), _classnames];
			};
			case "SAEF_ModuleSpawnAreaConfigHeavyVehicles":
			{
				_configArray pushBack [(format ["%1_heavyvehicles", _tag]), _classnames];
			};
			case "SAEF_ModuleSpawnAreaConfigParaVehicles":
			{
				_configArray pushBack [(format ["%1_paravehicles", _tag]), _classnames];
			};
			default {};
		};
	} forEach _syncedObjects;

	if (_failed) exitWith
	{
		_infoArray pushBack [1, (format ["Synchronised object processing failed!"])];
	};

	// Validation step
	private
	[
		"_valid",
		"_newConfigArray"
	];

	_valid = true;
	_newConfigArray = [["", []],["", []],["", []],["", []]];

	{
		_x params
		[
			"_configName"
			,"_classnames"
		];

		switch _configName do
		{
			case (format ["%1_units", _tag]):
			{
				{
					_x params ["_classname"];

					// If our classname is not a man, this needs to be pulled out
					if (!(_classname isKindOf ["Man", configFile >> "CfgVehicles"])) then
					{
						_classnames = _classnames - [_classname];
					};
				} forEach _classnames;

				if (_classnames isEqualTo []) then
				{
					_valid = false;
					_infoArray pushBack [1, (format ["Unit classname validation removed all classnames!"])];
				}
				else
				{
					_newConfigArray set [0, [_configName, _classnames]];
				};
			};
			case (format ["%1_lightvehicles", _tag]):
			{
				{
					_x params ["_classname"];

					// If our classname is not a vehicle, this needs to be pulled out
					if (!(_classname isKindOf ["LandVehicle", configFile >> "CfgVehicles"])) then
					{
						_classnames = _classnames - [_classname];
					};
				} forEach _classnames;

				if (_classnames isEqualTo []) then
				{
					_valid = false;
					_infoArray pushBack [1, (format ["Light vehicle classname validation removed all classnames!"])];
				}
				else
				{
					_newConfigArray set [1, [_configName, _classnames]];
				};
			};
			case (format ["%1_heavyvehicles", _tag]):
			{
				{
					_x params ["_classname"];

					// If our classname is not a vehicle, this needs to be pulled out
					if (!(_classname isKindOf ["LandVehicle", configFile >> "CfgVehicles"])) then
					{
						_classnames = _classnames - [_classname];
					};
				} forEach _classnames;

				if (_classnames isEqualTo []) then
				{
					_valid = false;
					_infoArray pushBack [1, (format ["Heavy vehicle classname validation removed all classnames!"])];
				}
				else
				{
					_newConfigArray set [2, [_configName, _classnames]];
				};
			};
			case (format ["%1_paravehicles", _tag]):
			{
				{
					_x params ["_classname"];

					// If our classname is not a plane or helicopter, this needs to be pulled out
					if (!((_classname isKindOf ["Helicopter", configFile >> "CfgVehicles"]) || (_classname isKindOf ["Plane", configFile >> "CfgVehicles"]))) then
					{
						_classnames = _classnames - [_classname];
					};
				} forEach _classnames;

				if (_classnames isEqualTo []) then
				{
					_valid = false;
					_infoArray pushBack [1, (format ["Paradrop vehicle classname validation removed all classnames!"])];
				}
				else
				{
					_newConfigArray set [3, [_configName, _classnames]];
				};
			};
			default {};
		};

		if (!_valid) exitWith {};
	} forEach _configArray;

	if (!_valid) exitWith
	{
		_infoArray pushBack [1, (format ["Validation for synchronised objects failed!"])];
	};

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
	} forEach _syncedObjects;

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