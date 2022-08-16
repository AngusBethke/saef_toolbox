/* 
	fn_CounterAttack.sqf

	Description: 
		Creates a counter attack for an area

	How to Call: 
		[
			"_marker"						// String: Marker where the area is created
		] spawn SAEF_AS_fnc_CounterAttack;
*/

params
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
	["_aiDirectorParams", []]
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

if (!(_activeAreas isEqualTo [])) exitWith
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

	// Get current difficulty
	(["GetCount"] call SAEF_AID_fnc_Difficulty) params
	[
		"_difficulty",
		"_difficultyCount"
	];

	// Based on current difficulty create the reinforcements
	{
		private
		[
			"_timeDelay"
		];

		_timeDelay = ceil (((markerPos _x) distance (markerPos _marker)) / 10);

		// Ensure we don't utilise all of the areas
		if (_forEachIndex < _difficultyCount) then
		{
			private
			[
				"_areaSize"
			];

			// Determine parameters for setting up the spawns
			_areaSize = ["DetermineAreaSize", [_x]] call SAEF_AID_fnc_Difficulty;

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

			// Ensure paradrop only occurs if allowed
			private
			[
				"_vehicleSpawnCode"
			];
			
			// Get safe spawn positions
			if (!_areaAllowedParadrop) then
			{
				_spawnPositions = ["GetSafeSpawnPositions", [(markerPos _x), 250, (markerPos _marker)]] call SAEF_AS_fnc_Vehicle;
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

					_hkParams = _hkParams + [_spawnPosition];
				}
				else
				{
					_hkParams = _hkParams + [_x];
				};

				// Ensure counter attack only occurs after specified time delay
				[_timeDelay, _hkParams, _queueValidation] spawn {
					params
					[
						"_timeDelay",
						"_hkParams",
						"_queueValidation"
					];

					sleep _timeDelay;

					["SAEF_SpawnerQueue", _hkParams, "SAEF_AS_fnc_HunterKiller", _queueValidation] call RS_MQ_fnc_MessageEnqueue;
				};
			};

			_vehicleSpawnCode = {
				params
				[
					"_spawnPositions",
					"_vehiclesToSpawn",
					"_side",
					"_groupCode",
					"_paraVehicles",
					"_groupScripts",
					"_queueValidation",
					"_timeDelay"
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
					
					// Ensure counter attack only occurs after specified time delay
					[_timeDelay, _hkParams, _queueValidation] spawn {
						params
						[
							"_timeDelay",
							"_hkParams",
							"_queueValidation"
						];

						sleep _timeDelay;

						["SAEF_SpawnerQueue", _hkParams, "SAEF_AS_fnc_HunterKiller", _queueValidation] call RS_MQ_fnc_MessageEnqueue;
					};
				}
				else
				{
					["SAEF_AS_fnc_CounterAttack", 2, "Unable to find safe spawn position for vehicle, no spawn will occur!"] call RS_fnc_LoggingHelper;
				};

				// Return the spawn positions
				_spawnPositions
			};

			// Spawn counter attack light vehicles
			for "_i" from 1 to _lightVehicleNumber do
			{
				_spawnPositions = [_spawnPositions, _lightVehicles, _side, _groupCode, _paraVehicles, _groupScripts, _queueValidation, _timeDelay] call _vehicleSpawnCode;
			};

			// Spawn counter attack heavy vehicles
			for "_i" from 1 to _heavyVehicleNumber do
			{
				_spawnPositions = [_spawnPositions, _heavyVehicles, _side, _groupCode, _paraVehicles, _groupScripts, _queueValidation, _timeDelay] call _vehicleSpawnCode;
			};
		};
	} forEach _activeAreas;
};

// If we found no active areas, then no counter attack can be staged
["SAEF_AS_fnc_CounterAttack", 0, (format["No active areas remaining for tag [%1], no counter attack can be staged.", _areaTag])] call RS_fnc_LoggingHelper;