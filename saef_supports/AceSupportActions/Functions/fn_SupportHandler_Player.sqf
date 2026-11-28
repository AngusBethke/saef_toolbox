/*
	fn_SupportHandler_Player.sqf

	Description:
		Support handler as executed by the player locally

	How to Call:
		[
			"_variableTag",
			"_vehicleClassname",
			"_scripts",
			"_loadout"
		] call SAEF_ASA_fnc_SupportHandler_Player;
*/

params
[
	"_variableTag",
	"_vehicleClassname",
	"_scripts",
	"_loadout",
	"_customCallsign"
];

private
[
	"_vehicle"
];

// Get spawn position for the air support
(missionNamespace getVariable ["SAEF_ASA_AirSupport_SpawnPos", [[0,0,0], 0]]) params
[
	"_pos",
	"_dir"
];

// Create the vehicle
_vehicle = createVehicle [_vehicleClassname, _pos, [], 0, "FLY"];

// Adjust vehicle direction, position and height
private
[
	"_height"
];

_height = (_pos select 2);

if ((_vehicle isKindOf "Plane") && (_height < 600)) then
{
	_height = 600;
};

_vehicle setDir _dir;
_vehicle setPosATL (_vehicle modelToWorld[0, 0, _height]);

// Adjust vehicle velocity
_vehicle setVelocityModelSpace [0, 80, 0];

// Apply additional scripts to vehicle
{
	_x params
	[
		"_params",
		"_script"
	];

	_params = [_vehicle] + _params;

	_params execVM _script;
} forEach _scripts;

// Get the callsign
private
[
	"_callsign"
];

_callsign = selectRandom ([_customCallsign] call SAEF_ASA_fnc_CustomCallsigns);

// Handle Supports Progress (executes on server)
[_vehicle, _variableTag, player, _pos, _callsign, _loadout] remoteExec ["SAEF_ASA_fnc_SupportHandler_Server", 2, false];

// Move the player into the vehicle
[_vehicle, _variableTag, _callsign, _loadout] spawn SAEF_ASA_fnc_Player_VehicleInteraction;