/*
	fn_DynamicAttack.sqf

	Description:
		Handles methods associated with the Dynamic Attack functionality

	How to Call: 
		[
			"_type",						// String: type of script execution
			"_params"						// Array: Params for script
		] spawn SAEF_AS_fnc_DynamicAttack;
*/

params
[
	"_type",
	["_params", []]
];

private
[
	"_scriptTag"
];

_scriptTag = "SAEF AS - Dynamic Attack";

/*
	------------
	-- HANDLE --
	------------

	Handles the dynamic attack
*/
if (toUpper(_type) == "HANDLE") exitWith
{
	if (!canSuspend) exitWith
	{
		_this spawn SAEF_AS_fnc_DynamicAttack;
	};

	_params params
	[
		"_position",
		"_areaTag",
		["_areaSize", "MED"],
		["_waveInfo", []],
		["_hunterKillerOptionalParams", []],
		["_escalatingParams", []]
	];

	_waveInfo params
	[
		["_waveNumber", 1],
		["_waveDelay", 300],
		["_waveInfantryMax", 48],
		["_waveLightVehicleMax", 4],
		["_waveHeavyVehicleMax", 2],
		["_waveInfantryTotal", 0],
		["_waveLightVehicleTotal", 0],
		["_waveHeavyVehicleTotal", 0]
	];

	_hunterKillerOptionalParams params
	[
		["_paradrop", false],
		["_useDynamicPosition", false],
		["_respawnTime", 120],
		["_groupCode", { _x enableFatigue false; }]
	];
	
	_escalatingParams params
	[
		["_waveForLightVehicleSpawns", 2],
		["_waveForHeavyVehicleSpawns", 4]
	];

	// Exit out if this has been ended
	private
	[
		"_runVariable"
	];

	_runVariable = format ["saef_ac_run_dynamicattack_%1", _areaTag];

	if (_waveNumber == 1) then
	{
		missionNamespace setVariable [_runVariable, true, true];
	};

	if ((_waveNumber > 1) && !(missionNamespace getVariable [_runVariable, false])) exitWith
	{
		[_scriptTag, 0, (format ["Ending dynamic attack, variable: [%1] is set to false!", _runVariable])] call RS_fnc_LoggingHelper;
	};

	(["GetConfigByTagOrMarker", [_areaTag]] call SAEF_AC_fnc_Helpers) params
	[
		"_blockPatrol",
		"_blockGarrison",
		"_units",
		"_side",
		"_lightVehicles",
		"_heavyVehicles",
		"_paraVehicles",
		"_playerValidation",
		"_groupScripts",
		"_queueValidation",
		"_defaultDetector",
		"_useAiDirector",
		"_aiDirectorParams",
		"_paraStartPosVariable"
	];

	private
	[
		"_startPos",
		"_endPos",
		"_count",
		"_respawnVariable",
		"_customPositionTag",
		"_customParaStartPoint"
	];

	// Set the positions
	_startPos = [0,0,0];
	_endPos = _position;

	// Get the area min and max
	(["GetAreaMinMax", [_areaSize]] call SAEF_AID_fnc_Difficulty) params
	[
		"_min",
		"_max"
	];

	// Count will be defaulted to the max
	_count = _max;

	// Variable for AI respawn
	_respawnVariable = _runVariable;

	// Variable for custom position
	_customPositionTag = "";
	if (_useDynamicPosition) then
	{
		_customPositionTag = format ["%1_hk", _areaTag];

		// Set the positions for the case of custom positions
		_startPos = _position;
		_endPos = [];
	};

	// Variable for para start position
	_customParaStartPoint = (format ["%1_parastart", _areaTag]);

	// If paradrop is not enabled, reset some variables
	if (!_paradrop) then
	{
		_customParaStartPoint = "";
		_paraVehicles = "";

		// Set the positions for the case of no paradrop
		_startPos = _position;
		_endPos = [];
	};

	// Start the spawns
	private
	[
		"_anySpawnConducted"
	];

	_anySpawnConducted = false;

	// Spawn the infantry
	if (_waveInfantryTotal < _waveInfantryMax) then
	{
		_waveInfantryTotal = _waveInfantryTotal + _count;
		_params = 
		[
			_startPos
			,_units
			,_side
			,_count
			,4000
			,_groupCode
			,_respawnVariable
			,_paraVehicles
			,_respawnTime
			,_groupScripts
			,_queueValidation
			,_customPositionTag
			,_endPos
			,_customParaStartPoint
			,[
				true,
				_areaSize
			]
		];
		
		["SAEF_SpawnerQueue", _params, "SAEF_AS_fnc_HunterKiller", _queueValidation] call RS_MQ_fnc_MessageEnqueue;

		_anySpawnConducted = true;
	};

	if (_waveNumber >= _waveForLightVehicleSpawns) then
	{
		// Spawn the light vehicle
		if (_waveLightVehicleTotal < _waveLightVehicleMax) then
		{
			_waveLightVehicleTotal = _waveLightVehicleTotal + 1;
			_params = 
			[
				_startPos
				,_lightVehicles
				,_side
				,1
				,4000
				,_groupCode
				,_respawnVariable
				,_paraVehicles
				,_respawnTime
				,_groupScripts
				,_queueValidation
				,_customPositionTag
				,_endPos
				,_customParaStartPoint
				,[
					true,
					_areaSize,
					false
				]
			];
			
			["SAEF_SpawnerQueue", _params, "SAEF_AS_fnc_HunterKiller", _queueValidation] call RS_MQ_fnc_MessageEnqueue;

			_anySpawnConducted = true;
		};
	};

	if (_waveNumber >= _waveForHeavyVehicleSpawns) then
	{
		// Spawn the heavy vehicle
		if (_waveHeavyVehicleTotal < _waveHeavyVehicleMax) then
		{
			_waveHeavyVehicleTotal = _waveHeavyVehicleTotal + 1;
			_params = 
			[
				_startPos
				,_heavyVehicles
				,_side
				,1
				,4000
				,_groupCode
				,_respawnVariable
				,_paraVehicles
				,_respawnTime
				,_groupScripts
				,_queueValidation
				,_customPositionTag
				,_endPos
				,_customParaStartPoint
				,[
					true,
					_areaSize,
					true
				]
			];
			
			["SAEF_SpawnerQueue", _params, "SAEF_AS_fnc_HunterKiller", _queueValidation] call RS_MQ_fnc_MessageEnqueue;

			_anySpawnConducted = true;
		};
	};

	if (_anySpawnConducted) exitWith
	{
		// Ensure we wait before creating the next wave
		sleep _waveDelay;

		private
		[
			"_newWaveInfo",
			"_newParams"
		];

		_newWaveInfo = 
		[
			(_waveNumber + 1),
			_waveDelay,
			_waveInfantryMax,
			_waveLightVehicleMax,
			_waveHeavyVehicleMax,
			_waveInfantryTotal,
			_waveLightVehicleTotal,
			_waveHeavyVehicleTotal
		];

		_newParams =
		[
			_position,
			_areaTag,
			_areaSize,
			_newWaveInfo,
			_hunterKillerOptionalParams,
			_escalatingParams
		];

		[_scriptTag, 4, (format ["Recursing with params: %1", _newParams])] call RS_fnc_LoggingHelper;

		["Handle", _newParams] spawn SAEF_AS_fnc_DynamicAttack;
	};

	[_scriptTag, 0, (format ["Cannot add any more units to spawn, the attack limit has been reached. This must now be ended with the following command: ['End', ['%1']] call SAEF_AS_fnc_DynamicAttack;", _areaTag])] call RS_fnc_LoggingHelper;
};

/*
	---------
	-- END --
	---------

	Ends the dynamic attack
*/
if (toUpper(_type) == "END") exitWith
{
	_params params
	[
		"_areaTag"
	];

	private
	[
		"_runVariable"
	];

	_runVariable = format ["saef_ac_run_dynamicattack_%1", _areaTag];
	missionNamespace setVariable [_runVariable, false, true];

	[_scriptTag, 0, (format ["Ended dynamic attack for this variable: [%1]", _runVariable])] call RS_fnc_LoggingHelper;
};

// Log warning if type is not recognised
[_scriptTag, 2, (format ["Unrecognised type [%1], nothing is being executed!", _type])] call RS_fnc_LoggingHelper;