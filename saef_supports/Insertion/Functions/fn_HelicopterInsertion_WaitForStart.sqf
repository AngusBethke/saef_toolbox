/*
	fn_HelicopterInsertion_WaitForStart.sqf

	Description:
		Waits for the insertion to start
*/

params
[
	"_vehicle",
	"_waypointObjectString",
	"_maybeNotPilot",
	"_canDeployFastRope"
];

waitUntil {
	sleep 1;
	(_vehicle getVariable ["SAEF_ASA_INS_StartInsertion", false])
};

// Create the waypoints
[_vehicle, _maybeNotPilot, _waypointObjectString, _canDeployFastRope] call SAEF_ASA_INS_fnc_HelicopterInsertion_Waypoints;

// Tune up vehicle fuel
_vehicle setFuel 1;

// Enable path for all crew members
{
	_x params ["_crewMember"];

	_crewMember enableAI "PATH";
} forEach (crew _vehicle);