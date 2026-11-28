/*
	fn_HelicopterInsertion_NoPlayersInVehicle.sqf

	Description:
		Evaluates whether any players are left in given vehicle

	[_vehicle] call SAEF_ASA_INS_fnc_HelicopterInsertion_NoPlayersInVehicle;
*/

params
[
	"_vehicle"
];

// Get deployable units from helicopter
private
[
	"_deployableUnits"
];
_deployableUnits = [];

{
	_x params ["_crewMember"];
	
	if ("cargo" in (assignedVehicleRole _crewMember) && (isPlayer _crewMember)) then
	{
		_deployableUnits pushBack _crewMember;
	};
} forEach (crew _vehicle);

// Return deployable units
if (_deployableUnits isEqualTo []) exitWith
{
	true
};

false