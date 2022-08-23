/*
	fn_AntiAir.sqf

	Description:
		Handles anti-air methods and functionality for the ambient combat toolset
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

_scriptTag = "SAEF Ambient Combat - Anti-Air";

/*
	------------
	-- CREATE --
	------------

	Creates the unit and runs the anti-air function

	["Create", ["default_rus_spawn_sml", "rus_area", opfor_AAGun_1, "saef_ac_run_antiair_1"]] call SAEF_AC_fnc_AntiAir;
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

	_groupCodeBlock = (call compile (format ["{ ['Handle', [_x, %1, '%2']] spawn SAEF_AC_fnc_AntiAir; }", _vehicle, _runVariable]));

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

	Handles the running of the anti-air process
*/
if (toUpper(_type) == "HANDLE") exitWith
{
	if (!canSuspend) exitWith
	{
		_this spawn SAEF_AC_fnc_AntiAir;
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

	// Handle the process
	missionNamespace setVariable [_runVariable, true, true];

	while { ((vehicle _unit) != _unit) && (alive _unit) && (missionNamespace getVariable [_runVariable, false]) } do
	{
		_target = [
			((((getPosASL _unit) select 0) + 50) - random(100)),	// x - (X position 50m right to 50m left)
			((((getPosASL _unit) select 1) + 50) - random(100)),	// y - (Y position 50m front to 50m behind)
			(((getPosASL _unit) select 2) + 300)					// z - (Height 300m above)
		];
			
		(vehicle _unit) setVehicleAmmo 1;
		(vehicle _unit) doSuppressiveFire _target;
		
		sleep 5;
	};

	missionNamespace setVariable [_runVariable, nil, true];
};

// Log warning if type is not recognised
[_scriptTag, 2, (format ["Unrecognised type [%1], nothing is being executed!", _type])] call RS_fnc_LoggingHelper;