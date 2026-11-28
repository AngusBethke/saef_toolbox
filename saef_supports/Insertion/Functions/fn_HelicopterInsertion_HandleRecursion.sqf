/*
	fn_HelicopterInsertion_HandleRecursion.sqf

	Description:
		Handles the recursion for the insertion
*/

params
[
	"_vehicle",
	"_waypointObjectString",
	"_deploymentLocationName",
	["_repeatInsertion", false],
	["_allowDamage", true],
	["_flightHeight", 30]
];

private
[
	"_startPosition",
	"_landingPadName",
	"_landingPad"
];

_startPosition = position _vehicle;

// Create a landing pad if one doesn't exist already
_landingPadName = format ["%1_Start_LandingPad", (vehicleVarName _vehicle)];
_landingPad = objNull;

if (isNil _landingPadName) then
{
	_landingPad = createVehicle ["Land_HelipadEmpty_F", _startPosition, [], 0, "CAN_COLLIDE"];
	[_landingPad, _landingPadName] call SAEF_VEH_fnc_RnR_GlobalRename;
}
else
{
	_landingPad = (call compile _landingPadName);
	_landingPad setPos _startPosition;
};

// Wait until the vehicle has deployed
waitUntil {
	sleep 5;
	((_vehicle getVariable ["SAEF_ASA_INS_InsertionComplete", false]) && ((_vehicle distance2D _startPosition) <= 150))
};

// Get the helicopter to land
_vehicle land "LAND";
_vehicle landAt _landingPad;

// Wait until the vehicle has deployed
waitUntil {
	sleep 1;
	((_vehicle getVariable ["SAEF_ASA_INS_InsertionComplete", false]) && ((_vehicle distance _startPosition) <= 5))
};

// Turn off the engine
_vehicle engineOn false;
_vehicle land "NONE";

// Reset vehicle variables
_vehicle setVariable ["SAEF_ASA_INS_StartInsertion", nil, true];
_vehicle setVariable ["SAEF_ASA_INS_InsertionComplete", nil, true];
_vehicle setVariable ["SAEF_ASA_INS_FastRopeComplete", nil, true];
_vehicle setVariable ["SAEF_ASA_INS_HelicopterOnApproach", nil, true];

// Start up insertion again
_this call SAEF_ASA_INS_fnc_HelicopterInsertion;