/*
	fn_HelicopterInsertion_HandleLanding.sqf

	Description:
		Handles the deployment of fast ropes for the helicopter
*/

params
[
	"_vehicle",
	"_position",
	"_maybeNotPilot",
	"_landingPad"
];

// Wait until the helicopter is on approach
waitUntil {
	sleep 5;
	((_vehicle getVariable ['SAEF_ASA_INS_HelicopterOnApproach', false]) || !(alive _vehicle))
};

if (!(alive _vehicle)) exitWith {};

// Wait until the helicopter is in position
waitUntil {
	sleep 5;
	(((_vehicle distance2D _position) <= 150) || !(alive _vehicle))
};

if (!(alive _vehicle)) exitWith {};

// Get the helicopter to land
_vehicle land "GET OUT";
_vehicle landAt _landingPad;

["SAEF Helicopter Insertion", 4, (format ["Vehicle [%1] ordered to land...", _vehicle])] call RS_fnc_LoggingHelper;

// Wait until everyone is out
waitUntil {
	sleep 5;
	(([_vehicle] call SAEF_ASA_INS_fnc_HelicopterInsertion_NoPlayersInVehicle) || !(alive _vehicle))
};

if (!(alive _vehicle)) exitWith {};

_vehicle land "NONE";