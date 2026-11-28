/*
	fn_HandleParadrop_Player.sqf

	Description:
		Handles the process of the paradrop for a player
*/

params
[
	"_vehicle",
	"_type",
	"_additionalParams"
];

_additionalParams params
[
	["_parachute", "ACE_NonSteerableParachute"]
];

// Blackout for smooth Plane transition
cutText ["", "BLACK OUT", 2];

sleep 2;

cutText ["", "BLACK FADED", 999];

// Give the player a parachute
if (!(isNil "zade_boc_fnc_actionOnChest")) then
{
	[player] call zade_boc_fnc_actionOnChest;
};

player addBackpack _parachute;

sleep 1;

// Move player into the vehicle
private
[
	"_control"
];

_control = 0;
waitUntil {
	sleep 0.1;
	_control = _control + 1;
	(((_vehicle emptyPositions "CARGO") > 0) || (_control >= 100))
};

if ((_vehicle emptyPositions "CARGO") <= 0) exitWith
{
	hint "Vehicle is full, please try again later.";

	// Fade back in
	sleep 1;
	cutText ["", "BLACK IN", 2];
};

player assignAsCargo _vehicle;
player moveInCargo _vehicle;

// Fade back in
sleep 1;

cutText ["", "BLACK IN", 2];

sleep 5;

if ((vehicle player) != _vehicle) exitWith
{
	hint "Unable to move into the vehicle, please try again.";
};

// Ensure player is not damage-able until they have exited the vehicle
player allowDamage false;

private
[
	"_paraVar",
	"_ejectTime"
];

_paraVar = format ["SAEF_ASA_INS_%1_StartDeployment", toUpper(_type)];

waitUntil {
	sleep 0.1;
	(missionNamespace getVariable [_paraVar, false])
};

// Determine eject time
_ejectTime = (_vehicle getCargoIndex player);

if (_ejectTime < 1) then
{
	_ejectTime = 1;
}; 

// Eject player from the vehicle
sleep _ejectTime;

unassignVehicle player;
player action ["EJECT", _vehicle];

waitUntil {
	sleep 0.1;
	((vehicle player) != _vehicle)
};

sleep 2;

player action ["OpenParachute", player];
player allowDamage true;