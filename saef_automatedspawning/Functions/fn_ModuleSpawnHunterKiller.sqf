/**
	@namespace SAEF_AS
	@class AutomatedSpawning
	@method SAEF_AS_fnc_ModuleSpawnHunterKiller
	@file fn_ModuleSpawnHunterKiller.sqf
	@summary Handles module functionality for Hunter killer

	@param object _logic
	@param array _units
	@param bool _activated
	@param bool _fromQueue

	@todo Empty script? Strange.
**/

/*
	fn_ModuleSpawnHunterKiller.sqf

	Description:
		Handles module functionality for Hunter killer
*/

if (!isServer) exitWith {};

if (is3DEN) exitWith {};

private
[
	"_scriptTag"
];
_scriptTag = "SAEF_AS_fnc_ModuleSpawnHunterKiller";

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

	["SAEF_AS_ModuleQueue", _params, "SAEF_AS_fnc_ModuleSpawnHunterKiller"] call RS_MQ_fnc_MessageEnqueue;
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
		,"_name"
		,"_config"
		,"_configOverrides"
	];

	if (_tag == "") exitWith
	{
		_infoArray pushBack ("Tag is empty, Hunter Killer will not be run!");
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

	if (!_tagFound) exitWith
	{
		_infoArray pushBack (format ["Tag [%1] not found in variable [SAEF_AreaMarkerTags], Hunter Killer will not be run!", _tag]);
	};
	
	private
	[
		 "_squadSize"
		,"_searchArea"
		,"_lightVehicle"
		,"_heavyVehicle"
		,"_persistence"
		,"_persistRespawnTime"
		,"_paraVehicle"
		,"_dynamicPosition"
	];

	// Load our variables from the module
	_squadSize = _logic getVariable ["SquadSize", 4]; 
	_searchArea = _logic getVariable ["SearchArea", 4000]; 
	_lightVehicle = _logic getVariable ["LightVehicle", false]; 
	_heavyVehicle = _logic getVariable ["HeavyVehicle", false]; 
	_persistence = _logic getVariable ["Persistence", false]; 
	_persistRespawnTime = _logic getVariable ["RespawnTime", 120]; 
	_paraVehicle = _logic getVariable ["ParaVehicle", false]; 
	_dynamicPosition = _logic getVariable ["DynamicPosition", false]; 

	(missionNamespace getVariable [_config, []]) params
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
	];

	// Validation step
	if (_tSpawnSide == "") exitWith
	{
		_infoArray pushBack (format ["Spawn side not defined for [%1], Hunter Killer will not be run!", _config]);
	};

	if (!(_heavyVehicle || _lightVehicle) && (_tSpawnUnits == "")) exitWith
	{
		_infoArray pushBack (format ["Spawn units not defined for [%1], Hunter Killer will not be run!", _config]);
	};

	if (_heavyVehicle && (_tHeavyVehicle == "")) exitWith
	{
		_infoArray pushBack (format ["Heavy Vehicle not defined for [%1], Hunter Killer will not be run!", _config]);
	};

	if (_lightVehicle && (_tLightVehicle == "")) exitWith
	{
		_infoArray pushBack (format ["Light Vehicle not defined for [%1], Hunter Killer will not be run!", _config]);
	};

	if (_paraVehicle && (_tParaVehicle == "")) exitWith
	{
		_infoArray pushBack (format ["Paradrop Vehicle not defined for [%1], Hunter Killer will not be run!", _config]);
	};

	/*
		Params List:
		[
			"_position"						// Array: Position array, the position to spawn the group
			,"_unitVar"						// String: Variable pointer to stored unit array
			,"_sideVar"						// String: Variable pointer to stored unit side
			,"_count"						// Integer: Number of units to spawn
			,"_area"						// Integer: Size of the area we are dealing with
			,"_groupCode"					// (Optional) Code Block: Code to run against the group
			,"_respawnVariable"				// (Optional) String: Variable that handles whether or not this group should be continuosly respawned
			,"_paraVariable"				// (Optional) String: Variable pointer to stored air vehicle array
			,"_respawnTime"					// (Optional) Integer: How long it takes for the group to respawn
			,"_customScripts				// (Optional) Array: String scripts for execution against spawned groups
			,"_queueValidation"				// (Optional) Code Block: Condition passed to the Message Queue to evaluate message for processing
			,"_customPositionTag"			// (Optional) String: Tag to help determine the custom spawn position for the Hunter Killer group
		]
	*/

	private
	[
		 "_position"
		,"_unitVar"
		,"_sideVar"
		,"_count"
		,"_area"
		,"_groupCode"
		,"_respawnVariable"
		,"_paraVariable"
		,"_respawnTime"
		,"_customScripts"
		,"_queueValidation"
		,"_customPositionTag"
	];

	_position = (getPos _logic);
	_position pushBack (getDir _logic);
	_count = _squadSize;

	_unitVar = _tSpawnUnits;
	if (_lightVehicle) then
	{
		_unitVar = _tLightVehicle;
		_count = 1;
	}
	else
	{
		if (_heavyVehicle) then
		{
			_unitVar = _tHeavyVehicle;
			_count = 1;
		};
	};

	_sideVar = _tSpawnSide;
	_area = _searchArea;

	_groupCode = 
	{
		_x enableFatigue false;
	};

	_respawnVariable = [_persistence, _tag] call {
		params
		[
			 "_persistence"
			,"_tag"
		];

		if (!_persistence) exitWith
		{
			// Return an empty string
			""
		};

		private
		[
			"_tagCreated"
			,"_variable"
			,"_counter"
		];

		_tagCreated = false;
		_variable = "";
		_counter = 1;
		while { !_tagCreated } do
		{
			private
			[
				"_checkVar"
			];

			_checkVar = (format ["%1_Run_HunterKiller_%2", _tag, _counter]);

			if (!(missionNamespace getVariable [_checkVar, false])) exitWith
			{
				_variable = _checkVar;
				_tagCreated = true;
			};

			_counter = _counter + 1;
		};

		// Return the variable
		_variable
	};

	_paraVariable = [_paraVehicle, _tParaVehicle, _heavyVehicle, _lightVehicle] call {
		params
		[
			 "_paraVehicle"
			,"_tParaVehicle"
			,"_heavyVehicle"
			,"_lightVehicle"
		];

		// If this is a vehicle we should not do the paradrop spawn
		if (!_paraVehicle || (_heavyVehicle || _lightVehicle)) exitWith
		{
			""
		};

		_tParaVehicle
	};

	_respawnTime = _persistRespawnTime;
	_customScripts = _tCustomScripts;
	_queueValidation = _tQueueValidation;

	_customPositionTag = "";
	if (_dynamicPosition) then
	{
		_customPositionTag = (format ["%1_hk", _tag]);
	};
	
	_infoArray pushBack (format ["Executed Hunter Killer with the following parameters: %1", ([_position, _unitVar, _sideVar, _count, _area, "_groupCode <Ommitted>", _respawnVariable, _paraVariable, _respawnTime, "_customScripts <Ommitted>", "_queueValidation <Ommitted>", _customPositionTag])]);

	// Run the Function
	_params = 
	[
		_position
		,_unitVar
		,_sideVar
		,_count
		,_area
		,_groupCode
		,_respawnVariable
		,_paraVariable
		,_respawnTime
		,_customScripts
		,_queueValidation
		,_customPositionTag
	];
	
	["SAEF_SpawnerQueue", _params, "SAEF_AS_fnc_HunterKiller", _queueValidation] call RS_MQ_fnc_MessageEnqueue;
}
else
{
	_infoArray pushBack ("Module is not active, hunter killer will not be run!");
};

// Compile our info hint and log messages
private
[
	"_tInfoHolder",
	"_infoString"
];

_infoString = "";
_tInfoHolder = (format ["[%1] Spawn Hunter Killer Info:", _tag]);
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