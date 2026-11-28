/*
	fn_HelicopterInsertion.sqf

	Description:
		Handles insertion of units by given vehicle

	How to Call:
		[
			_vehicle,
			_waypointObjectString,
			_deploymentLocationName,
			_repeatInsertion,
			_allowDamage,
			_flightHeight
		] call SAEF_ASA_INS_fnc_HelicopterInsertion;
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

// Is this a helicopter
private
[
	"_isHelicopter",
	"_canDeployFastRope"
];

_isHelicopter = (_vehicle isKindOf "Helicopter");
_canDeployFastRope = false;

if (_isHelicopter) then
{
	[_vehicle] call ace_fastroping_fnc_equipFRIES;

	if ([_vehicle] call ace_fastroping_fnc_canPrepareFRIES) then
	{
		_canDeployFastRope = true;
		["SAEF Helicopter Insertion", 0, (format ["Equipped vehicle [%1] with FRIES", _vehicle])] call RS_fnc_LoggingHelper;
	}
	else
	{
		["SAEF Helicopter Insertion", 2, (format ["Cannot equip vehicle [%1] with FRIES", _vehicle])] call RS_fnc_LoggingHelper;
	};
};

// Crew the vehicle
private
[
	"_crew"
];

_crew = (crew _vehicle);

if (_crew isEqualTo []) then
{
	createVehicleCrew _vehicle;
	_crew = (crew _vehicle);
};

// Mark vehicle for damage 
_vehicle allowDamage _allowDamage;

// Set crew behaviour
{
	_x params ["_crewMember"];

	_crewMember allowFleeing 0;
	_crewMember allowDamage _allowDamage;
	_crewMember disableAI "PATH";

	if (_isHelicopter) then
	{
		_crewMember flyInHeight _flightHeight;
	};
} forEach _crew;

["SAEF Helicopter Insertion", 4, (format ["Crew created for vehicle [%1]", _vehicle])] call RS_fnc_LoggingHelper;

// Get a non-pilot crew member
private
[
	"_maybeNotPilot"
];

_maybeNotPilot = _crew select 0;

if ((count _crew) > 1) then
{
	_maybeNotPilot = (_crew select 1);
};

// Add the handlers for starting the insertion
[_vehicle, _deploymentLocationName] remoteExecCall ["SAEF_ASA_INS_fnc_HelicopterInsertion_AddAction", 0, true];
[_vehicle, _waypointObjectString, _maybeNotPilot, _canDeployFastRope] spawn SAEF_ASA_INS_fnc_HelicopterInsertion_WaitForStart;
[_vehicle] spawn SAEF_ASA_INS_fnc_HelicopterInsertion_EnsureDoorsAreOpen;

// If this is a repeating script then we need to execute another handler
if (_repeatInsertion) then
{
	_this spawn SAEF_ASA_INS_fnc_HelicopterInsertion_HandleRecursion;
};