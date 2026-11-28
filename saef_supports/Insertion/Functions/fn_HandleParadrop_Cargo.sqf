/*
	fn_HandleParadrop_Cargo.sqf

	Description:
		Handles the process of the paradrop for a cargo item
*/

params
[
	"_vehicle",
	"_type",
	"_additionalParams"
];

_additionalParams params
[
	["_cargoItemClassName", ""],
	["_additionalScripts", []]
];

if (_cargoItemClassName == "") exitWith
{
	// TODO: Log some error
};

private
[
	"_cargoItem"
];

// Create cargo item
_cargoItem = createVehicle [_cargoItemClassName, [0,0,10], [], 0, ""];

// Attach cargo the vehicle
_cargoItem attachTo [_vehicle, [0,0,-10]];

// Run additional scripts against item
{
	_x params
	[
		"_scriptParams",
		"_script"
	];

	([_cargoItem] + _scriptParams) execVM _script;

} forEach _additionalScripts;

private
[
	"_paraVar"
];

_paraVar = format ["SAEF_ASA_INS_%1_StartDeployment", toUpper(_type)];

waitUntil {
	sleep 0.1;
	(missionNamespace getVariable [_paraVar, false])
};

// Drop item from plane
detach _cargoItem;

sleep 3;

// Deploy parachute and attach item
_para = createVehicle ["B_Parachute_02_F", (getPos _cargoItem), [], 0, ""];
_cargoItem attachTo [_para, [0,0,0]];

private
[
	"_control"
];

_control = 0;
waitUntil {
	sleep 0.1;
	((((position _cargoItem) select 2) < 0.6) || (isNil "_para") || (_control >= 2400))
};

detach _cargoItem;