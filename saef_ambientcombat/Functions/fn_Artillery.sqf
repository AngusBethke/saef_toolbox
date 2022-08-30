/*
	fn_Artillery.sqf

	Description:
		Handles artillery methods and functionality for the ambient combat toolset
*/

params
[
	"_type",
	["_params", []]
];

private
[
	"_scriptTag",
	"_strikeDensities"
];

_scriptTag = "SAEF Ambient Combat - Artillery";
_strikeDensities = ["LIGHT", "MEDIUM", "HEAVY"];

/*
	------------
	-- CREATE --
	------------

	Creates the unit and runs the artillery function

	["Create", ["default_rus_spawn_sml", "rus_area", opfor_Mortar_1, "Run_Mortar_1"]] call SAEF_AC_fnc_Artillery;
*/
if (toUpper(_type) == "CREATE") exitWith
{
	_params params
	[
		"_marker",
		"_areaTag",
		"_vehicle",
		"_runVariable"
	];

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
		"_groupCodeBlock",
		"_spawnParams"
	];

	_groupCodeBlock = (call compile (format ["{ ['Handle', [_x, %1, '%2']] spawn SAEF_AC_fnc_Artillery; }", _vehicle, _runVariable]));

	_spawnParams = 
	[
		_marker, 
		"NON", 
		_units, 
		_side, 
		1, 
		_marker, 
		50, 
		50, 
		_groupCodeBlock
	];

	["SAEF_SpawnerQueue", _spawnParams, "SAEF_AS_fnc_Spawner"] call RS_MQ_fnc_MessageEnqueue;
};

/*
	------------
	-- HANDLE --
	------------

	Handles the running of the artillery process
*/
if (toUpper(_type) == "HANDLE") exitWith
{
	if (!canSuspend) exitWith
	{
		_this spawn SAEF_AC_fnc_Artillery;
	};

	_params params
	[
		"_unit",
		"_vehicle",
		"_runVariable"
	];

	// Move the unit into the gunner
	_unit moveInGunner _vehicle;
	_unit action ["getInGunner", _vehicle];

	private
	[
		"_control"
	];

	_control = 0;
	waitUntil {
		sleep 1;
		_control = _control + 1;
		(((vehicle _unit) == _vehicle) || (_control == 100))
	};

	["PersistentAmbientStrikes", [[_vehicle], _runVariable]] spawn SAEF_AC_fnc_Artillery;
};

/*
	------------------------------
	-- PERSISTENTAMBIENTSTRIKES --
	------------------------------

	Calls a persistent safe ambient strikes on players

	Example call:
		["PersistentAmbientStrikes", [[arty_1, arty_2], "Arty_Position_2"]] spawn SAEF_AC_fnc_Artillery;
*/
if (toUpper(_type) == "PERSISTENTAMBIENTSTRIKES") exitWith
{
	if (!canSuspend) exitWith
	{
		_this spawn SAEF_AC_fnc_Artillery;
	};
	
	_params params
	[
		"_guns",
		"_variable",
		["_density", "Medium"],
		["_delay", 120],
		["_shellType", "explosive"],
		["_spread", 0],
		["_rearm", true]
	];

	if (!(toUpper(_density) in _strikeDensities)) exitWith
	{
		[_scriptTag, 1, (format ["[%1] Density [%2] not in recognised densities!", _type, _density])] call RS_fnc_LoggingHelper;
	};

	// Set the variable format
	_variable = (format ["SAEF_AC_Run_PersistentAmbientStrikes_%1", _variable]);

	// Kick off the process
	missionNamespace setVariable [_variable, true, true];

	[_scriptTag, 3, (format ["[%1] Starting persistent ambient strike with variable [%2] ...", _type, _variable])] call RS_fnc_LoggingHelper;

	while {((missionNamespace getVariable [_variable, false]) && (["GunsCanFire", [_guns]] call SAEF_AC_fnc_Artillery))} do
	{
		["AmbientStrike", [_guns, _density, _shellType, _spread, _rearm]] call SAEF_AC_fnc_Artillery;
		sleep _delay;
	};

	missionNamespace setVariable [_variable, nil, true];

	[_scriptTag, 3, (format ["[%1] Ending persistent ambient strike with variable [%2] ...", _type, _variable])] call RS_fnc_LoggingHelper;
};

/*
	-------------------
	-- AMBIENTSTRIKE --
	-------------------

	Calls a safe ambient strike on the players
*/
if (toUpper(_type) == "AMBIENTSTRIKE") exitWith
{
	_params params
	[
		"_guns",
		["_density", "Medium"],
		["_shellType", "explosive"],
		["_spread", 0],
		["_rearm", true]
	];

	if (!(toUpper(_density) in _strikeDensities)) exitWith
	{
		[_scriptTag, 1, (format ["[%1] Density [%2] not in recognised densities!", _type, _density])] call RS_fnc_LoggingHelper;
	};

	private
	[
		"_positionCount",
		"_roundCount",
		"_safePositions",
		"_distance"
	];

	_distance = (100 + random(50));
	_safePositions = ["GetSafePlacesAroundPlayers", [_distance]] call SAEF_AC_fnc_Helpers;
	_positionCount = 0;
	_roundCount = 0;

	switch toUpper(_density) do
	{
		case "LIGHT": {
			_positionCount = ceil ((count _safePositions) / 4);
			_roundCount = 1;
		};

		case "MEDIUM": {
			_positionCount = ceil ((count _safePositions) / 2);
			_roundCount = 2;
		};

		case "HEAVY": {
			_positionCount = (count _safePositions);
			_roundCount = 4;
		};

		default {
			// Do nothing, switch list check is handled above
		};
	};

	private
	[
		"_positions"
	];

	_positions = [];

	if (_positionCount == (count _safePositions)) then
	{
		_positions = _safePositions;
	}
	else
	{
		for "_i" from 1 to _positionCount do
		{
			private
			[
				"_safePosition"
			];

			_safePosition = selectRandom _safePositions;
			_safePositions = _safePositions - [_safePosition];

			_positions pushBackUnique _safePosition;
		};
	};

	[_guns, _positions, _roundCount, _shellType, _spread, _rearm] spawn SAEF_AI_fnc_PhysicalArtillery;
};

/*
	-----------------
	-- GUNSCANFIRE --
	-----------------

	Checks if guns can fire
*/
if (toUpper(_type) == "GUNSCANFIRE") exitWith
{
	_params params
	[
		"_guns"
	];

	private
	[
		"_gunsCanFire"
	];

	_gunsCanFire = true;

	{
		private
		[
			"_vehicle"
		];

		_vehicle = (vehicle _x);

		if (!(alive _vehicle)) exitWith
		{
			_gunsCanFire = false;
		};

		if ((crew _vehicle) isEqualTo []) exitWith
		{
			_gunsCanFire = false;
		};
	} forEach _guns;

	// Return guns can fire
	_gunsCanFire
};

// Log warning if type is not recognised
[_scriptTag, 2, (format ["Unrecognised type [%1], nothing is being executed!", _type])] call RS_fnc_LoggingHelper;