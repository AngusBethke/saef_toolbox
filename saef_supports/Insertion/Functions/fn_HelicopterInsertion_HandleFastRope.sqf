/*
	fn_HelicopterInsertion_HandleFastRope.sqf

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

// Wait until the helicopter is below 20m
waitUntil {
	sleep 0.1;
	(((_vehicle distance _landingPad) <= 5) || !(alive _vehicle))
};

if (!(alive _vehicle)) exitWith {};

// Stop the ai from reacting
doStop (driver _vehicle);
(driver _vehicle) disableAI "ALL";

["SAEF Helicopter Insertion", 4, (format ["Vehicle [%1] driver [%2] movement disabled...", _vehicle, (driver _vehicle)])] call RS_fnc_LoggingHelper;

// Wait until fries can be prepared
waitUntil {
	sleep 0.1;
	(([_vehicle] call ace_fastroping_fnc_canPrepareFRIES) || !(alive _vehicle))
};

if (!(alive _vehicle)) exitWith {};

// Prepare fries
[_vehicle] call ace_fastroping_fnc_prepareFRIES;

["SAEF Helicopter Insertion", 4, (format ["Vehicle [%1] preparing fries...", _vehicle])] call RS_fnc_LoggingHelper;

// Deploy the ropes
[_vehicle, objNull, "ACE_rope36"] call ace_fastroping_fnc_deployRopes;

["SAEF Helicopter Insertion", 4, (format ["Vehicle [%1] maybe not driver [%2] deploying ropes...", _vehicle, objNull])] call RS_fnc_LoggingHelper;

sleep 5;

// Get deployable units from helicopter
private
[
	"_deployableUnits"
];
_deployableUnits = [];

{
	_x params ["_crewMember"];
	
	if ("cargo" in (assignedVehicleRole _crewMember)) then
	{
		_deployableUnits pushBack _crewMember;
	};
} forEach (crew _vehicle);

// Kick off the fast rope
{
	_x params ["_unit"];

	if (isPlayer _unit) then
	{
		// Distribute action to all players to allow them to fast rope
		[_vehicle, _forEachIndex] remoteExec ["SAEF_ASA_INS_fnc_HelicopterInsertion_PlayerFastRope", _unit, false];
	}
	else
	{
		[_vehicle, _forEachIndex, _unit] spawn SAEF_ASA_INS_fnc_HelicopterInsertion_PlayerFastRope;
	};
} forEach _deployableUnits;

["SAEF Helicopter Insertion", 4, (format ["Units %1 deployed from vehicle [%2]...", _deployableUnits, _vehicle])] call RS_fnc_LoggingHelper;

// Wait until all the units are out of the helicopter
waitUntil {
	sleep 0.1;
	(({(!(alive _x) || ((vehicle _x) != _vehicle))} count _deployableUnits) == (count _deployableUnits))
};

// Delay for last unit deployment
sleep 10;

// Allow it to leave
_vehicle land "NONE";
(driver _vehicle) enableAI "ALL";
(driver _vehicle) doMove (getPos _vehicle);

// Cut the ropes and set the variable
[_vehicle] call ace_fastroping_fnc_cutRopes;
_vehicle setVariable ["SAEF_ASA_INS_FastRopeComplete", true, true];

["SAEF Helicopter Insertion", 4, (format ["Ropes cut, deployment complete for vehicle [%1]...", _vehicle])] call RS_fnc_LoggingHelper;