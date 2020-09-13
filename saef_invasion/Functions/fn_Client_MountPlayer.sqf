/* 
	fn_Client_MountPlayer.sqf
	
	Description: 
		Handles the spawning of the plane, and assigning units to the plane.
		
	Note:
		This must be executed from inside of an action
		
	Called by:
		fn_Client_AddDropAction.sqf
*/

params
[
	"_functionLockVariable"
];

private
[
	"_activePlane",
	"_isActive",
	"_plane",
	"_positions"
];

// Function Lock Mechanism Section
missionNamespace setVariable [_functionLockVariable, true, true];

// Determine whether or not a drop plane already exists
_activePlane = missionNamespace getVariable ["RS_INV_ActivePlane", [false, objNull]];
_isActive = _activePlane select 0;
_plane = _activePlane select 1;

// Default Spawn Positions
_positions = missionNamespace getVariable ["RS_INV_PlaneSpawnPositionArray", []];

if (_positions isEqualTo []) exitWith
{
	["RS_INV_fnc_Client_MountPlayer", 1, "No spawn positions found for plane in variable 'RS_INV_PlaneSpawnPositionArray'!"] call RS_fnc_LoggingHelper;

	// Function Unlock Mechanism Section
	missionNamespace setVariable [_functionLockVariable, false, true];
};

// This will create a plane if one did not exist initially	
if !(_isActive) then
{
	// Spawn the plane if there are none
	_position = (selectRandom _positions);
	_position = _position + [true];
	_position remoteExecCall ["RS_INV_fnc_Server_SpawnPlane", 2, false];
	
	// Wait for the plane spawn process
	sleep 3;
	
	// Get our new active plane
	_activePlane = missionNamespace getVariable "RS_INV_ActivePlane"; 
	_isActive = _activePlane select 0;
	_plane = _activePlane select 1;
};	

if (isNull _plane) exitWith
{
	// This should never happen, but it's a safety check
	["RS_INV_fnc_Client_MountPlayer", 1, (format ["Player [%1] Plane NULL", player])] call RS_fnc_LoggingHelper;
	hint "[RS] [INVASION] [ERROR] Aircraft doesn't exist! Please attempt the drop again...";
	
	// Make the active plane null
	missionNamespace setVariable ["RS_INV_ActivePlane", [false, objNull], true];

	// Function Unlock Mechanism Section
	missionNamespace setVariable [_functionLockVariable, false, true];
};

diag_log format ["Invasion Function: %1 Assigned Plane %2", player, _plane];

if (_isActive) then
{
	// Gracefully cover up the movement
	[] spawn RS_INV_fnc_Client_Screen;
	sleep 2.5;
	
	// Assign the player to this plane then move them into it
	_freeCargoPositions = _plane emptyPositions "cargo";
	_index = (15 - _freeCargoPositions);
	player setVariable ["RS_INV_AssignedPlane", [_plane, _index], true];
	["plane", player] spawn RS_INV_fnc_Client_MoveIn;
}
else
{
	// Safety catch for if the returned plane is not active
	["RS_INV_fnc_Client_MountPlayer", 1, (format ["Player [%1] Unable to Execute Script", player])] call RS_fnc_LoggingHelper;
	hint "[RS] [INVASION] [ERROR] No aircraft is active! Please attempt the drop again...";
};

// Function Unlock Mechanism Section
missionNamespace setVariable [_functionLockVariable, false, true];

/*
	END
*/