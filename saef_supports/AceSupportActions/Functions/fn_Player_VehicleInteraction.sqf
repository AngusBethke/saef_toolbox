/*
	fn_Player_VehicleInteraction.sqf

	Description:	
		Handles player interaction with the given vehicle

	How to Call:	
		[
			"_vehicle",
			"_variableTag",
			["_pilotLoadout", ""]
		] spawn SAEF_ASA_fnc_Player_VehicleInteraction;
*/

params
[
	"_vehicle",
	"_variableTag",
	"_callsign",
	["_pilotLoadout", ""]
];

private
[
	"_vehicleType",
	"_initialPlayerGroup"
];

_vehicleType = (typeOf _vehicle);
_initialPlayerGroup = [(group player), (groupId (group player))];

// Blackout for smooth Plane transition
cutText ["", "BLACK OUT", 2];

sleep 2;

cutText ["","BLACK FADED",999];

// Create player group and assign them the custom callsign
private
[
	"_group"
];

_group = createGroup (side player);
_group deleteGroupWhenEmpty true;
[player] joinSilent _group;

_group setGroupIdGlobal [_callsign];

// Allow no damage to the player
player allowDamage false;

// Get player loadout and position
private
[
	"_loadout",
	"_face",
	"_playerPos"
];

_loadout = getUnitLoadout player;
_face = face player;
_playerPos = getPosASL player;

// Pilot loadout
if (_pilotLoadout != "") then
{
	[player] execVM _pilotLoadout;
};

// Put the player in the vehicle
player moveinDriver _vehicle;

// Mark player variable so that they can exit the vehicle with the ace action
player setVariable [(format ["%1_CurrentlyInSupportVehicle", _variableTag]), true, true];

// Black in the screen
sleep 2;

cutText ["","BLACK IN",2];

private
[
	"_time"
];

// Handler for if the vehicle is destroyed, time runs out or the support is ended
_time = (missionNamespace getVariable [(format ["%1_Timer", _variableTag]), 0]);

// If time is 0, that means this should last infinitely... 10 hours should do the trick
if (_time == 0) then
{
	_time = 36000;
};

waitUntil {
	sleep 1;

	_time = _time - 1;
	
	// Exit if vehicle dies or player ends the support
	(!(alive _vehicle) || (player getVariable [(format ["%1_EndSupport", _variableTag]), false]) || (_time < 0))
};

// Reset "end support" variable
player setVariable [(format ["%1_EndSupport", _variableTag]), false, true];
player setVariable [(format ["%1_CurrentlyInSupportVehicle", _variableTag]), false, true];

// Add a time penalty for losing the plane
if !(alive _vehicle) then
{
	[(format ["%1 Shot Down", _callsign])] remoteExecCall ["hint", 0, false];
}
else
{
	[(format ["%1 RTB", _callsign])] remoteExecCall ["hint", 0, false];
};

// Black out the screen
cutText ["","BLACK OUT",1];

sleep 1;

cutText ["","BLACK FADED",999];

// Remove player from vehicle
while { ((typeOf (vehicle player)) == _vehicleType) } do
{
	moveOut player;
	sleep 0.5;
};

// Reset their velocity
player setVelocity [0, 0, 0];

// Re-join player to group
_initialPlayerGroup params
[
	"_oldGroup",
	"_oldCallsign"
];

// If the vehicle is moving or it's not alive then we need to send them back to their initial boarding position
if (((speed _vehicle) > 1) || !(alive _vehicle)) then
{
	player setPosASL _playerPos;
};

// If the "old group" still exists re-join the player
if (!(isNull _oldGroup)) then
{
	[player] joinSilent _oldGroup;
}
else
{
	// Else re-create the old group
	_oldGroup = createGroup (side player);
	_oldGroup deleteGroupWhenEmpty true;
	[player] joinSilent _oldGroup;

	_oldGroup setGroupIdGlobal [_oldCallsign];
};

// Set support to finished, as player is now done
missionNamespace setVariable [(format ["%1_Finished", _variableTag]), true, true];

// Sort out player loadout
player setUnitLoadout _loadout;
[player, _face, "ace_novoice"] remoteExecCall ["BIS_fnc_setIdentity", 0, true];

// Black in the screen
sleep 2;

cutText ["","BLACK IN",2];

// Re-enable player damage
sleep 5;
player allowDamage true;