/* 
	fn_CounterAttack.sqf

	Description: 
		Creates a counter attack for an area

	How to Call: 
		[
			"_type",						// String: type of script execution
			"_params"						// Array: Params for script
		] spawn SAEF_AS_fnc_CounterAttack;
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

_scriptTag = "SAEF AS - Counter Attack";

/*
	------------
	-- CREATE --
	------------

	Creates the counter attack
*/
if (toUpper(_type) == "CREATE") exitWith
{
	_params params
	[
		"_marker"
	];
	
	// Determine our current area tag
	private
	[
		"_areaTags",
		"_areaTag",
		"_areaConfigVar",
		"_areaUnderAttackVar"
	];

	_areaUnderAttackVar = (format["Area_%1_UnderAttack", _marker]);
	missionNamespace setVariable [_areaUnderAttackVar, true, true];

	_areaTags = (missionNamespace getVariable ["SAEF_AreaMarkerTags", []]);
	_areaTag = "";

	{
		_x params
		[
			"_tag"
			,"_name"
			,"_config"
			,["_overrides", []]
		];
		
		if ([toUpper(_tag), toUpper(_marker)] call BIS_fnc_InString) then
		{
			_areaTag = _tag;
			_areaConfigVar = _config;
		};
	} forEach _areaTags;

	// Load the configuration for the area
	(missionNamespace getVariable [_areaConfigVar, []]) params
	[
		["_blockPatrol", false],
		["_blockGarrison", false],
		["_units", ""],
		["_side", ""],
		["_lightVehicles", ""],
		["_heavyVehicles", ""],
		["_paraVehicles", ""],
		["_playerValidation", {true}],
		["_groupScripts", []],
		["_queueValidation", {true}],
		["_defaultDetector", true],
		["_useAiDirector", true],
		["_aiDirectorParams", []],
		["_paraStartPosVariable", ""]
	];

	// Load the AI Director params
	_aiDirectorParams params
	[
		["_areaAllowedParadrop", false],
		["_counterAttackDistance", 2000]
	];

	// Once we have the area tag, we need to locate the closest active areas
	private
	[
		"_activeAreas"
	];

	_activeAreas = [];

	// Find active areas
	{
		if (([toUpper(_areaTag), toUpper(_x)] call BIS_fnc_InString) && (_marker != _x)) then
		{
			private
			[
				"_activeVariable"
			];

			_activeVariable = (format["Area_%1_Active", _x]);
			
			if (missionNamespace getVariable [_activeVariable, false]) then
			{
				private
				[
					"_distance"
				];

				_distance = ((markerPos _x) distance (markerPos _marker));

				if ((_distance <= _counterAttackDistance) && (_distance >= 500)) then
				{
					_activeAreas pushBack _x;
				};
			};
		};
	} forEach allMapMarkers;

	if (!(_activeAreas isEqualTo [])) then
	{
		// Get safe spawn positions
		private
		[
			"_spawnPositions"
		];

		_spawnPositions = [];

		if (_areaAllowedParadrop) then
		{
			_spawnPositions = ["GetSafeSpawnPositions", [(markerPos _marker), 250, (markerPos _marker)]] call SAEF_AS_fnc_Vehicle;
		}
		else
		{
			_paraVehicles = "";
		};

		// Get current difficulty (to determine how many areas we should utilise)
		(["GetCount"] call SAEF_AID_fnc_Difficulty) params
		[
			"_difficulty",
			"_difficultyCount"
		];

		{
			private
			[
				"_timeDelay"
			];

			// Setup the time delay
			_timeDelay = ceil (((markerPos _x) distance (markerPos _marker)) / 10);

			// Ensure we don't utilise all of the areas
			if (_forEachIndex < _difficultyCount) then
			{
				private
				[
					"_executeParams"
				];

				_executeParams = 
				[
					_timeDelay, 
					_x, 
					_marker, 
					_areaAllowedParadrop, 
					_spawnPositions, 
					_units, 
					_side, 
					_paraVehicles, 
					_groupScripts, 
					_queueValidation, 
					_paraStartPosVariable,
					_lightVehicles,
					_heavyVehicles
				];

				["Execute", _executeParams] spawn SAEF_AS_fnc_CounterAttack;
			};
		} forEach _activeAreas;
	}
	else
	{
		// If we found no active areas, then no counter attack can be staged
		[_scriptTag, 0, (format["No active areas remaining for tag [%1], no counter attack can be staged.", _areaTag])] call RS_fnc_LoggingHelper;
	};
};

/*
	-------------
	-- EXECUTE --
	-------------

	Executes the counter attack
*/
if (toUpper(_type) == "EXECUTE") exitWith
{
	if (!canSuspend) exitWith
	{
		_this spawn SAEF_AS_fnc_CounterAttack;
	};

	_params params
	[
		"_timeDelay",
		"_thisArea",
		"_marker",
		"_areaAllowedParadrop",
		"_spawnPositions",
		"_units",
		"_side",
		"_paraVehicles",
		"_groupScripts",
		"_queueValidation",
		"_paraStartPosVariable",
		"_lightVehicles",
		"_heavyVehicles"
	];

	// Ensure delay occurs before counter attack is created
	sleep _timeDelay;

	// Get current difficulty (after the delay - as we need to ensure we evaluate player conditions at the time of the counter attack)
	(["GetCount"] call SAEF_AID_fnc_Difficulty) params
	[
		"_difficulty",
		"_difficultyCount"
	];

	private
	[
		"_areaSize"
	];

	// Determine parameters for setting up the spawns
	_areaSize = ["DetermineAreaSize", [_thisArea]] call SAEF_AID_fnc_Difficulty;

	(["GetNumberOfGroupsToSpawn", [_areaSize, _marker]] call SAEF_AID_fnc_Difficulty) params
	[
		"_groupNumber",
		"_countPerGroup",
		"_lightVehicleNumber",
		"_heavyVehicleNumber"
	];

	["SAEF_AID_ProcessQueue", ["Add", [(format ["CounterAttackInfantry_%1", _areaSize]), (_countPerGroup * _groupNumber)]], "SAEF_AID_fnc_Track"] call RS_MQ_fnc_MessageEnqueue;
	["SAEF_AID_ProcessQueue", ["Add", [(format ["CounterAttackLightVehicles_%1", _areaSize]), _lightVehicleNumber]], "SAEF_AID_fnc_Track"] call RS_MQ_fnc_MessageEnqueue;
	["SAEF_AID_ProcessQueue", ["Add", [(format ["CounterAttackHeavyVehicles_%1", _areaSize]), _heavyVehicleNumber]], "SAEF_AID_fnc_Track"] call RS_MQ_fnc_MessageEnqueue;

	// Setup group code
	private
	[
		"_groupCode"
	];

	_groupCode = 
	{
		_x enableFatigue false;
	};

	// Ensure paradrop only occurs if allowed - get safe spawn positions
	if (!_areaAllowedParadrop) then
	{
		_spawnPositions = ["GetSafeSpawnPositions", [(markerPos _thisArea), 250, (markerPos _marker)]] call SAEF_AS_fnc_Vehicle;
	};

	// Spawn counter attack groups
	for "_i" from 1 to _groupNumber do
	{
		private
		[
			"_hkParams"
		];

		_hkParams = 
		[
			[0,0,0]
			,_units
			,_side
			,_countPerGroup
			,4000
			,_groupCode
			,""
			,_paraVehicles
			,120
			,_groupScripts
			,_queueValidation
			,""
		];

		if (!(_spawnPositions isEqualTo [])) then
		{
			private
			[
				"_spawnPosition"
			];

			_spawnPosition = (selectRandom _spawnPositions);
			_spawnPositions = _spawnPositions - [_spawnPosition];

			_hkParams = _hkParams + [_spawnPosition, _paraStartPosVariable];
		}
		else
		{
			_hkParams = _hkParams + [_x, _paraStartPosVariable];
		};

		["SAEF_SpawnerQueue", _hkParams, "SAEF_AS_fnc_HunterKiller", _queueValidation] call RS_MQ_fnc_MessageEnqueue;
	};
	
	private
	[
		"_vehicleSpawnCode"
	];

	_vehicleSpawnCode = {
		params
		[
			"_spawnPositions",
			"_vehiclesToSpawn",
			"_side",
			"_groupCode",
			"_paraVehicles",
			"_groupScripts",
			"_queueValidation"
		];

		if (!(_spawnPositions isEqualTo [])) then
		{
			private
			[
				"_hkParams",
				"_spawnPosition"
			];

			_spawnPosition = (selectRandom _spawnPositions);
			_spawnPositions = _spawnPositions - [_spawnPosition];

			// Ensure we correctly spawn vehicles for counter attack
			_hkParams = [];
			if (_paraVehicles != "") then
			{
				_hkParams = [
					[0,0,0]
					,_vehiclesToSpawn
					,_side
					,1
					,4000
					,_groupCode
					,""
					,_paraVehicles
					,120
					,_groupScripts
					,_queueValidation
					,""
					,_spawnPosition
					,_paraStartPosVariable
				];
			}
			else
			{
				_hkParams = [
					_spawnPosition
					,_vehiclesToSpawn
					,_side
					,1
					,4000
					,_groupCode
					,""
					,_paraVehicles
					,120
					,_groupScripts
					,_queueValidation
				];
			};
			
			["SAEF_SpawnerQueue", _hkParams, "SAEF_AS_fnc_HunterKiller", _queueValidation] call RS_MQ_fnc_MessageEnqueue;
		}
		else
		{
			[_scriptTag, 2, "Unable to find safe spawn position for vehicle, no spawn will occur!"] call RS_fnc_LoggingHelper;
		};

		// Return the spawn positions
		_spawnPositions
	};

	// Spawn counter attack light vehicles
	for "_i" from 1 to _lightVehicleNumber do
	{
		_spawnPositions = [_spawnPositions, _lightVehicles, _side, _groupCode, _paraVehicles, _groupScripts, _queueValidation] call _vehicleSpawnCode;
	};

	// Spawn counter attack heavy vehicles
	for "_i" from 1 to _heavyVehicleNumber do
	{
		_spawnPositions = [_spawnPositions, _heavyVehicles, _side, _groupCode, _paraVehicles, _groupScripts, _queueValidation] call _vehicleSpawnCode;
	};
};

// Log warning if type is not recognised
[_scriptTag, 2, (format ["Unrecognised type [%1], nothing is being executed!", _type])] call RS_fnc_LoggingHelper;