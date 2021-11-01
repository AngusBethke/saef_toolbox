/*
	fn_Area.sqf

	Description: This is the basic layout for area spawns, and handling information around those areas.
	
	How to Call:
		[
			"_marker"							// String: Marker where the area is created
			,"_initVariable"					// String: Variable for area initialisation
			,"_variable"						// String: Variable for marking area completion
			,"_blockPatrol"						// Boolean: Whether or not to block patrols
			,"_blockGarrison"					// Boolean: Whether or not to block garrisons
			,"_spawnUnits"						// String: Variable pointer to stored unit array
			,"_spawnSide"						// String: Variable pointer to stored unit side
			,"_lightVehicle"					// String: Variable pointer to stored light vehicle array
			,"_heavyVehicle"					// String: Variable pointer to stored heavy vehicle array
			,"_paraVehicle"						// String: Variable pointer to stored para vehicle array
			,"_playerValidationCodeBlock"		// (Optional) Code Block: Condition passed to GetClosestPlayer to evaluate players for inclusion
			,"_customScripts"					// (Optional) Array: Of string scripts for execution against spawned groups
			,"_queueValidation"					// (Optional) Code Block: Condition passed to the Message Queue to evaluate message for processing
			,"_includeDetector"					// (Optional) Boolean: Whether or not to include a trigger to disable this area
		] call SAEF_AS_fnc_Area;
*/

params
[
	"_marker"
	,"_initVariable"
	,"_variable"
	,["_blockPatrol", false]
	,["_blockGarrison", false]
	,["_spawnUnits", ""]
	,["_spawnSide", ""]
	,["_lightVehicle", ""]
	,["_heavyVehicle", ""]
	,["_paraVehicle", ""]
	,["_playerValidationCodeBlock", {true}]
	,["_customScripts", []]
	,["_queueValidation", {true}]
	,["_includeDetector", true]
];

private
[
	"_scriptTag",
	"_switch",
	"_maxActivationRange",
	"_baseAICount",
	"_baseAreaSize",
	"_baseActivationRange"
];

_scriptTag = "SAEF_AS_fnc_Area";
[_scriptTag, 3, (format["<IN> [%1]", _marker])] call RS_fnc_LoggingHelper;

_switch = false;
_maxActivationRange = missionNamespace getVariable ["SAEF_AreaSpawner_MaxActivationRange", 800];

// Determine our base area configuration
if (["LRG", _marker] call BIS_fnc_InString) then
{
	(missionNamespace getVariable ["SAEF_AreaSpawner_Large_Params", []]) params
	[
		["_tBaseAICount", 12],
		["_tBaseAreaSize", 60],
		["_tBaseActivationRange", 500]
	];

	_baseAICount = _tBaseAICount;
	_baseAreaSize = _tBaseAreaSize;
	_baseActivationRange = 	_tBaseActivationRange;

	if (!_blockPatrol) then
	{
		_blockPatrol = missionNamespace getVariable ["SAEF_AreaSpawner_Large_BlockPatrol", _blockPatrol];
	};

	if (!_blockGarrison) then
	{
		_blockGarrison = missionNamespace getVariable ["SAEF_AreaSpawner_Large_BlockGarrison", _blockGarrison];
	};
	
	_switch = true;
};

if (["MED", _marker] call BIS_fnc_InString) then
{
	(missionNamespace getVariable ["SAEF_AreaSpawner_Medium_Params", []]) params
	[
		["_tBaseAICount", 6],
		["_tBaseAreaSize", 50],
		["_tBaseActivationRange", 500]
	];

	_baseAICount = _tBaseAICount;
	_baseAreaSize = _tBaseAreaSize;
	_baseActivationRange = 	_tBaseActivationRange;

	if (!_blockPatrol) then
	{
		_blockPatrol = missionNamespace getVariable ["SAEF_AreaSpawner_Medium_BlockPatrol", _blockPatrol];
	};

	if (!_blockGarrison) then
	{
		_blockGarrison = missionNamespace getVariable ["SAEF_AreaSpawner_Medium_BlockGarrison", _blockGarrison];
	};
	
	_switch = true;
};

if (["SML", _marker] call BIS_fnc_InString) then
{
	(missionNamespace getVariable ["SAEF_AreaSpawner_Small_Params", []]) params
	[
		["_tBaseAICount", 4],
		["_tBaseAreaSize", 40],
		["_tBaseActivationRange", 500]
	];

	_baseAICount = _tBaseAICount;
	_baseAreaSize = _tBaseAreaSize;
	_baseActivationRange = 	_tBaseActivationRange;

	if (!_blockPatrol) then
	{
		_blockPatrol = missionNamespace getVariable ["SAEF_AreaSpawner_Small_BlockPatrol", _blockPatrol];
	};

	if (!_blockGarrison) then
	{
		_blockGarrison = missionNamespace getVariable ["SAEF_AreaSpawner_Small_BlockGarrison", _blockGarrison];
	};
	
	_switch = true;
};

// If we don't have a size tag, we need to exit
if (!_switch) exitWith
{
	[_scriptTag, 2, (format["<OUT> No size identity tag attached to marker! [%1]", _marker])] call RS_fnc_LoggingHelper;
};

// We shouldn't block both patrols and garrisons
if (_blockPatrol && _blockGarrison) exitWith
{
	[_scriptTag, 2, (format["<OUT> This is set to block both patrols and garrisons! [%1]", _marker])] call RS_fnc_LoggingHelper;
};

// If we are a vehicle spawner we need to exit
if ((["LVEH", _marker] call BIS_fnc_InString) || (["HVEH", _marker] call BIS_fnc_InString)) exitWith
{
	[_scriptTag, 3, (format["<OUT> This is a vehicle spawner! [%1]", _marker])] call RS_fnc_LoggingHelper;
};

// Error handling for provided variables
if (_spawnUnits == "") exitWith
{
	[_scriptTag, 1, (format["<OUT> No spawn unit variable provided! [%1]", _marker])] call RS_fnc_LoggingHelper;
};

if (_spawnSide == "") exitWith
{
	[_scriptTag, 1, (format["<OUT> No spawn side variable provided! [%1]", _marker])] call RS_fnc_LoggingHelper;
};

if (_lightVehicle == "") exitWith
{
	[_scriptTag, 1, (format["<OUT> No light vehicle variable provided! [%1]", _marker])] call RS_fnc_LoggingHelper;
};

if (_heavyVehicle == "") exitWith
{
	[_scriptTag, 1, (format["<OUT> No heavy vehicle variable provided! [%1]", _marker])] call RS_fnc_LoggingHelper;
};

if ((missionNamespace getVariable [_variable, true])) then
{
	// Set our initialised variable
	missionNamespace setVariable [_initVariable, true, true];

	// Set our active variable
	missionNamespace setVariable [_variable, true, true];

	private
	[
		"_paramsList",
		"_lightVehicleList",
		"_heavyVehicleList"
	];

	_paramsList = [];
	_lightVehicleList = [];
	_heavyVehicleList = [];

	/* ----- Garrison Section ----- */
	if (!_blockGarrison) then
	{
		private
		[
			"_garrisonGroupCodeBlock",
			"_gParams"
		];

		_garrisonGroupCodeBlock = 
		{
			_x enableFatigue false;
		};

		if (_baseActivationRange < 150) then
		{
			_baseActivationRange = 150;
		};

		_gParams = 
		[
			_marker, 
			"GAR", 
			_spawnUnits, 
			_spawnSide, 
			_baseAICount, 
			_marker, 
			_baseAreaSize, 
			_baseActivationRange, 
			_garrisonGroupCodeBlock, 
			true, 
			_variable,
			_playerValidationCodeBlock,
			_customScripts,
			_queueValidation
		];

		// Add our garrison to the parameter list
		_paramsList pushBack _gParams;
	};
	/* ----- End of Garrison Section ----- */

	/* ----- Patrol Section ----- */
	if (!_blockPatrol) then
	{
		private
		[
			"_patrolGroupCodeBlock",
			"_newAICount",
			"_newAreaSize",
			"_i"
		];

		_patrolGroupCodeBlock = 
		{
			_x doMove ([((getPos _x) select 0) + 5, (getPos _x) select 1, (getPos _x) select 2]);
			_x enableFatigue false;
		};

		// Add our patrols to the parmeter list
		_newAICount = _baseAICount;
		_newAreaSize = _baseAreaSize;

		_i = 1;
		while {(_newAICount >= 4) && (_i <= 4)} do
		{
			private
			[
				"_activationRange"
			];

			_newAICount = floor((_newAICount / 2) + 1);
			_newAreaSize = (_newAreaSize * 2);
			
			_activationRange = (_baseActivationRange + _newAreaSize);
			if (_activationRange > _maxActivationRange) then
			{
				_activationRange = _maxActivationRange;
			};
			
			_pParams = 
			[
				_marker, 
				"PAT", 
				_spawnUnits, 
				_spawnSide, 
				_newAICount, 
				_marker, 
				_newAreaSize, 
				_activationRange, 
				_patrolGroupCodeBlock, 
				true, 
				_variable,
				_playerValidationCodeBlock,
				_customScripts,
				_queueValidation
			];
			
			_paramsList pushBack _pParams;
			_i = _i + 1;
		};
	};
	/* ----- End of Patrol Section ----- */

	/* ----- Vehicle Section ----- */
	private
	[
		"_vehicleGroupCodeBlock",
		"_lightVehicleTag",
		"_heavyVehicleTag"
	];

	_vehicleGroupCodeBlock =
	{
		_x disableAI "PATH";
		(vehicle _x) engineOn true;
	};

	_lightVehicleTag = format["%1_LVEH", _marker, false];
	_heavyVehicleTag = format["%1_HVEH", _marker, false];

	{
		if ([_lightVehicleTag, _x] call BIS_fnc_InString) then
		{
			_lightVehicleList pushBack _x;
		};
		
		if ([_heavyVehicleTag, _x] call BIS_fnc_InString) then
		{
			_heavyVehicleList pushBack _x;
		};
	} forEach allMapMarkers;

	{
		private
		[
			"_vParams"
		];

		_vParams = 
		[
			_x, 
			"NON", 
			_lightVehicle, 
			_spawnSide, 
			1, 
			_x, 
			_baseAreaSize, 
			_baseActivationRange, 
			_vehicleGroupCodeBlock, 
			true, 
			_variable,
			_playerValidationCodeBlock,
			_customScripts,
			_queueValidation
		];
		
		_paramsList pushBack _vParams;
	} forEach _lightVehicleList;

	{
		private
		[
			"_vParams"
		];

		_vParams = 
		[
			_x, 
			"NON", 
			_heavyVehicle, 
			_spawnSide, 
			1, 
			_x, 
			_baseAreaSize, 
			_baseActivationRange, 
			_vehicleGroupCodeBlock, 
			true, 
			_variable,
			_playerValidationCodeBlock,
			_customScripts,
			_queueValidation
		];
		
		_paramsList pushBack _vParams;
	} forEach _heavyVehicleList;
	/* ----- End of Vehicle Section ----- */

	/* ----- Trigger Section ----- */
	if (_includeDetector) then
	{
		private 
		[
			"_strSpawnSide",
			"_trigger",
			"_condition",
			"_onActStatement"
		];

		_strSpawnSide = (toUpper(format ["%1", (missionNamespace getVariable [_spawnSide, EAST])]));

		_trigger = createTrigger ["EmptyDetector", (markerPos _marker)];
		_trigger setTriggerArea [_baseAreaSize, _baseAreaSize, 0, false];
		_trigger setTriggerActivation [_strSpawnSide, "NOT PRESENT", true];
		_trigger setTriggerInterval 5;

		// Build the trigger condition
		_condition = "private ['_condition']; ";
		_condition = _condition + "_condition = this; ";
		_condition = _condition + "if (_condition) then ";
		_condition = _condition + "{ ";
		_condition = _condition 	+ "private ['_closePlayer', '_valid', '_position', '_size']; ";
		_condition = _condition 	+ "_valid = false; ";
		_condition = _condition 	+ "_position = (position thisTrigger); ";
		_condition = _condition 	+ "_size = ((((triggerArea thisTrigger) select 0) + ((triggerArea thisTrigger) select 1)) / 2); ";
		_condition = _condition 	+ "_closePlayer = [_position, _size] call RS_PLYR_fnc_GetClosestPlayer; ";
		_condition = _condition 	+ "if (!(_closePlayer isEqualTo [0,0,0])) then ";
		_condition = _condition 	+ "{ ";
		_condition = _condition 		+ "_valid = ((_closePlayer distance _position) < _size); ";
		_condition = _condition 	+ "}; ";
		_condition = _condition 	+ "_condition = (this && _valid); ";
		_condition = _condition + "}; ";
		_condition = _condition + "_condition";

		// Build the onActivation statement
		_onActStatement = (format ["missionNamespace setVariable ['%1', false, true];", _variable]);

		// Set up the trigger
		_trigger setTriggerStatements [_condition, _onActStatement, ""];

		[_scriptTag, 3, (format["Created trigger at marker [%1] using spawn side [%2]...", _marker, _strSpawnSide])] call RS_fnc_LoggingHelper;
	};
	/* ----- End of Trigger Section ----- */

	[_scriptTag, 0, (format["Area created at marker [%2], this area can be disabled with the variable [%1]", _variable, _marker])] call RS_fnc_LoggingHelper;

	// Execute all our spawn handlers
	{
		private
		[
			"_params"
		];

		_params = _x;

		// Add our spawn script to the spawner queue
		["SAEF_SpawnerQueue", _params, "SAEF_AS_fnc_Spawner", _queueValidation] call RS_MQ_fnc_MessageEnqueue;
	} forEach _paramsList;
}
else
{
	[_scriptTag, 2, (format["Variable [%1] is marked as false, spawning will not proceed! [%2]", _variable, _marker])] call RS_fnc_LoggingHelper;
};

[_scriptTag, 3, (format["<OUT> [%1]", _marker])] call RS_fnc_LoggingHelper;

/*
	END
*/