/**
	@namespace SAEF_AS
	@class AutomatedSpawning
	@method SAEF_AS_fnc_ModuleSpawnArea
	@file fn_ModuleSpawnArea.sqf
	@summary Handles module functionality for spawn areas

	@param object _logic
	@param array _units
	@param bool _activated
	@param bool _fromQueue
**/
/*
	fn_ModuleSpawnArea.sqf

	Description:
		Handles module functionality for spawn areas
*/

if (!isServer) exitWith {};

if (is3DEN) exitWith {};

private
[
	"_scriptTag"
];
_scriptTag = "SAEF_AS_fnc_ModuleSpawnArea";

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

	["SAEF_AS_ModuleQueue", _params, "SAEF_AS_fnc_ModuleSpawnArea"] call RS_MQ_fnc_MessageEnqueue;
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
		"_size"
		,"_blockPatrol"
		,"_blockGarrison"
		,"_spawnSide"
		,"_spawnUnits"
		,"_spawnLightVehicles"
		,"_spawnHeavyVehicles"
		,"_spawnParaVehicles"
		,"_areaTags"
		,"_tagFound"
		,"_name"
		,"_config"
		,"_configOverrides"
		,"_tagRelatedMarkers"
		,"_markerCode"
		,"_markerName"
		,"_marker"
		,"_createOverride"
		,"_dynamicOverrides"
		,"_markerConfig"
	];

	// Load our variables from the module
	_size = _logic getVariable ["Size", "SML"]; 
	_blockPatrol = _logic getVariable ["BlockPatrol", false]; 
	_blockGarrison = _logic getVariable ["BlockGarrison", false]; 
	_spawnSide = _logic getVariable ["SpawnSide", ""]; 
	_spawnUnits = _logic getVariable ["SpawnUnits", ""]; 
	_spawnLightVehicles = _logic getVariable ["SpawnLightVehicles", ""]; 
	_spawnHeavyVehicles = _logic getVariable ["SpawnHeavyVehicles", ""]; 
	_spawnParaVehicles = _logic getVariable ["SpawnParaVehicles", ""]; 

	if (_tag == "") exitWith
	{
		_infoArray pushBack ("Tag is empty, Spawn area will not be run!");
	};

	// Fetch our existing area tags
	_areaTags = (missionNamespace getVariable ["SAEF_AreaMarkerTags", []]);

	// Set tag settings if we have them
	_tagFound = false;
	_name = (format ["name_%1", _tag]);
	_config = "";
	_configOverrides = [];
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
			_name = _tName;
			_config = _configVar;
			_configOverrides = _overrides;
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
			_testMarker = toLower(format ["%1_%2", _tag, _counter]);

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

	_markerName = [(format ["%1_%2", _tag, _size]), _tagRelatedMarkers] call _markerCode;

	// Create the marker
	_marker = createMarker [_markerName, (getPos _logic)];
	_marker setMarkerDir (getDir _logic);
	_marker setMarkerType "Empty";
	_infoArray pushBack (format ["Created Marker: %1", _markerName]);

	// Check Logic Objects that are nearby or sync'd
	private
	[
		"_syncedObjects",
		"_vehicleMarkerCode"
	];

	_syncedObjects = (synchronizedObjects _logic);
	_vehicleMarkerCode = {
		_x params ["_syncedObject"];

		_tagRelatedMarkers = [];
		{
			if ([_tag, _x] call BIS_fnc_InString) then
			{
				_tagRelatedMarkers pushBack _x;
			};
		} forEach allMapMarkers;

		if (_syncedObject isKindOf "SAEF_ModuleSpawnAreaVehicle") then
		{
			private
			[
				"_lightVehicle",
				"_heavyVehicle"
			];

			_lightVehicle = _syncedObject getVariable ["LightVehicle", false];
			_heavyVehicle = _syncedObject getVariable ["HeavyVehicle", false];

			if (_lightVehicle) then
			{
				private
				[
					"_tMarkerName"
					,"_tMarker"
				];

				_tMarkerName = [(format ["%1_%2", _markerName, "lveh"]), _tagRelatedMarkers] call _markerCode;

				_tMarker = createMarker [_tMarkerName, (getPos _syncedObject)];
				_tMarker setMarkerType "Empty";
				_tMarker setMarkerDir (getDir _syncedObject);
				_infoArray pushBack (format ["Created Marker: %1", _tMarkerName]);
			}
			else
			{
				if (_heavyVehicle) then
				{
					private
					[
						"_tMarkerName"
						,"_tMarker"
					];

					_tMarkerName = [(format ["%1_%2", _markerName, "hveh"]), _tagRelatedMarkers] call _markerCode;

					_tMarker = createMarker [_tMarkerName, (getPos _syncedObject)];
					_tMarker setMarkerType "Empty";
					_tMarker setMarkerDir (getDir _syncedObject);
					_infoArray pushBack (format ["Created Marker: %1", _tMarkerName]);
				}
				else
				{
					_infoArray pushBack (format ["Unable to create marker for module as both heavy and light vehicle params were set to false!"]);
				};
			};

			// Cleanup the objects after we have created the markers
			deleteVehicle _syncedObject;
		};
	};

	if (_syncedObjects isEqualTo []) then
	{
		private
		[
			"_areaSize",
			"_nearObjects"
		];

		_areaSize = 50;
		switch toUpper(_size) do
		{
			case "SML": 
			{
				(missionNamespace getVariable ["SAEF_AreaSpawner_Small_Params", []]) params
				[
					["_tBaseAICount", 12],
					["_tBaseAreaSize", 60],
					["_tBaseActivationRange", 500]
				];

				_areaSize = _tBaseAreaSize;
			};
			case "MED": 
			{
				(missionNamespace getVariable ["SAEF_AreaSpawner_Small_Params", []]) params
				[
					["_tBaseAICount", 12],
					["_tBaseAreaSize", 60],
					["_tBaseActivationRange", 500]
				];
				
				_areaSize = _tBaseAreaSize;
			};
			case "LRG":
			{
				(missionNamespace getVariable ["SAEF_AreaSpawner_Small_Params", []]) params
				[
					["_tBaseAICount", 12],
					["_tBaseAreaSize", 60],
					["_tBaseActivationRange", 500]
				];
				
				_areaSize = _tBaseAreaSize;
			};
			default {};
		};

		_nearObjects = _logic nearEntities ["SAEF_ModuleSpawnAreaVehicle", _areaSize];

		_vehicleMarkerCode forEach _nearObjects;
	}
	else
	{
		_vehicleMarkerCode forEach _syncedObjects;
	};

	// Do we need to create an override?
	_createOverride = (
		(
			 _blockPatrol
			|| _blockGarrison
			|| (_spawnSide != "")
			|| (_spawnUnits != "")
			|| (_spawnLightVehicles != "")
			|| (_spawnHeavyVehicles != "")
			|| (_spawnParaVehicles != "")
		)
		&& (_config != "")
	);

	// Setup the override if necessary
	_dynamicOverrides = [];
	_markerConfig = (format ["%1_config", _markerName]);
	if (_createOverride) then
	{
		_infoArray pushBack (format ["Created Override: %1", _markerConfig]);

		_dynamicOverrides pushBack _markerName;
		_dynamicOverrides pushBack _markerConfig;

		private
		[
			"_overrideSettings"
		];

		// Get our existing config settings
		(missionNamespace getVariable [_config, []]) params
		[
			 ["_tBlockPatrol", _blockPatrol]
			,["_tBlockGarrison", _blockGarrison]
			,["_tSpawnUnits", _spawnUnits]
			,["_tSpawnSide", _spawnSide]
			,["_tLightVehicle", _spawnLightVehicles]
			,["_tHeavyVehicle", _spawnHeavyVehicles]
			,["_tParaVehicle", _spawnParaVehicles]
			,["_tPlayerValidationCodeBlock", {true}]
			,["_tCustomScripts", []]
			,["_tQueueValidation", {true}]
			,["_tIncludeDetector", true]
		];

		// Do the overrides if necessary
		if (_blockPatrol) then
		{
			_tBlockPatrol = _blockPatrol;
		};

		if (_blockGarrison) then
		{
			_tBlockGarrison = _blockGarrison;
		};

		if (_spawnUnits != "") then
		{
			_tSpawnUnits = _spawnUnits;
		};

		if (_spawnSide != "") then
		{
			_tSpawnSide = _spawnSide;
		};

		if (_spawnLightVehicles != "") then
		{
			_tLightVehicle = _spawnLightVehicles;
		};

		if (_spawnHeavyVehicles != "") then
		{
			_tHeavyVehicle = _spawnHeavyVehicles;
		};

		if (_spawnParaVehicles != "") then
		{
			_tParaVehicle = _spawnParaVehicles;
		};

		// Build our overrides
		_overrideSettings =
		[
			_tBlockPatrol,
			_tBlockGarrison,
			_tSpawnUnits,
			_tSpawnSide,
			_tLightVehicle,
			_tHeavyVehicle,
			_tParaVehicle,
			_tPlayerValidationCodeBlock,
			_tCustomScripts,
			_tQueueValidation,
			_tIncludeDetector
		];

		_infoArray pushBack (format ["Override is using params: %1", (_overrideSettings - [_tPlayerValidationCodeBlock, _tCustomScripts, _tQueueValidation])]);

		// Save the variable
		missionNamespace setVariable [_markerConfig, _overrideSettings, true];
	};

	// If we don't find a tag then we need to create a new one
	if (!_tagFound) then
	{
		private
		[
			"_newConfig",
			"_createConfig",
			"_newConfigSettings"
		];

		_newConfig = (format ["%1_config", _tag]);

		// We're going to fetch our area tags again incase they were edited while we were busy
		_areaTags = (missionNamespace getVariable ["SAEF_AreaMarkerTags", []]);

		_configOverrides pushBack _dynamicOverrides;
		_areaTags pushBack [_tag, _name, _newConfig, _configOverrides];

		_infoArray pushBack (format ["No existing tag found, creating new tag: %1", ([_tag, _newConfig, _configOverrides])]);
		
		// Save away our area tags
		missionNamespace setVariable ["SAEF_AreaMarkerTags", _areaTags, true];

		// If we have filled in any of the parameters we should create the config, otherwise we'll leave it so that it can error intelligently
		_createConfig = (
			_blockPatrol
			|| _blockGarrison
			|| (_spawnSide != "")
			|| (_spawnUnits != "")
			|| (_spawnLightVehicles != "")
			|| (_spawnHeavyVehicles != "")
			|| (_spawnParaVehicles != "")
		);

		if (_createConfig) then
		{
			[_blockPatrol, _blockGarrison, _spawnUnits, _spawnSide, _spawnLightVehicles, _spawnHeavyVehicles, _spawnParaVehicles] params
			[
				 ["_tBlockPatrol", false]
				,["_tBlockGarrison", false]
				,["_tSpawnUnits", ""]
				,["_tSpawnSide", ""]
				,["_tLightVehicle", ""]
				,["_tHeavyVehicle", ""]
				,["_tParaVehicle", ""]
				,["_tPlayerValidationCodeBlock", {true}]
				,["_tCustomScripts", []]
				,["_tQueueValidation", {true}]
				,["_tIncludeDetector", true]
			];

			_newConfigSettings = 
			[
				_tBlockPatrol,
				_tBlockGarrison,
				_tSpawnUnits,
				_tSpawnSide,
				_tLightVehicle,
				_tHeavyVehicle,
				_tParaVehicle,
				_tPlayerValidationCodeBlock,
				_tCustomScripts,
				_tQueueValidation,
				_tIncludeDetector
			];

			_infoArray pushBack (format ["New tag is using config: %1", (_newConfigSettings - [_tPlayerValidationCodeBlock, _tCustomScripts, _tQueueValidation])]);

			// Save the config settings
			missionNamespace setVariable [_newConfig, _newConfigSettings, true];
		}
		else
		{
			[_scriptTag, 2, (format ["Unable to create config for [%1] you will likely encounter errors upon area creation.", _newConfig])] call RS_fnc_LoggingHelper;
		};
	}
	else
	{
		// If we have any dynamic overrides then we need to apply them
		if (!(_dynamicOverrides isEqualTo [])) then
		{
			private
			[
				"_index"
			];

			// We're going to fetch our area tags again incase they were edited while we were busy
			_areaTags = (missionNamespace getVariable ["SAEF_AreaMarkerTags", []]);

			_index = -1;
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
					_index = _forEachIndex;
					_configOverrides = _overrides;
				};
			} forEach _areaTags;

			// If our index is still -1 then our tag was nuked somehow
			if (_index != -1) then
			{
				// Then we need to update our tags at the right index to fulfill the overrides
				_configOverrides pushBack _dynamicOverrides;
				_areaTags set [_index, [toLower(_tag), _name, toLower(_config), _configOverrides]];

				_infoArray pushBack (format ["Adding Dynamic Overrides to our tag: %1", _dynamicOverrides]);
				missionNamespace setVariable ["SAEF_AreaMarkerTags", _areaTags, true];
			}
			else
			{
				[_scriptTag, 1, (format ["SAEF_AreaMarkerTags index missing! Unable to create dynamic override %1", _dynamicOverrides])] call RS_fnc_LoggingHelper;
			};
		};
	};
	
	_infoArray pushBack "Executed the Handler";

	// Run the Handler
	[] call SAEF_AS_fnc_Handler;
}
else
{
	_infoArray pushBack ("Module is not active, Spawn area will not be run!");
};

// Compile our info hint and log messages
private
[
	"_tInfoHolder",
	"_infoString"
];

_infoString = "";
_tInfoHolder = (format ["[%1] Spawn Area Info:", _tag]);
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