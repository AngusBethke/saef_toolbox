/* 
	fn_Server_PlayerAirDrop.sqf 
	
	Description:
		Handles the player air drop component of the para drop
		
	How to Call:
		[
			_plane,
			_position
		] spawn RS_fnc_Server_PlayerAirDrop; 
		
	Called by:
		fn_Server_SpawnPlane.sqf
*/

params
[
	"_plane",
	"_position"
];

private
[
	"_activePlane",
	"_isActive",
	"_tPlane",
	"_playerArray",
	"_countPArray"
];

_plane = _this select 0;
_position = _this select 1;
_playerArray = [];

// Waits until the plane makes it to the "No Spawn Zone"
waitUntil {
	sleep 1; 
	(((_plane distance2D _position) <= 900) || (_plane == objNull))
};

if (_plane == objNull) exitWith
{
	["RS_fnc_Server_PlayerAirDrop", 2, "Player Para Drop Cancelled! Plane is NULL..."] call RS_fnc_LoggingHelper;
};

// Quick check for whether or not this plane is active for spawns, if it is, disable it.
_activePlane = missionNamespace getVariable ["RS_INV_ActivePlane", [false, objNull]];
_isActive = _activePlane select 0;
_tPlane = _activePlane select 1;

if ((_isActive)&&(_plane == _tPlane)) then
{
	missionNamespace setVariable ["RS_INV_ActivePlane", [false, objNull], true];
};

// Waits Until the Plane makes it to the Red Light Zone
waitUntil {
	sleep 1; 
	(((_plane distance2D _position) <= 800) || (_plane == objNull))
};

if (_plane == objNull) exitWith
{
	["RS_fnc_Server_PlayerAirDrop", 2, "Player Para Drop Cancelled! Plane is NULL..."] call RS_fnc_LoggingHelper;
};

// Generate the Player Array for the Plane, and count it
{
	if (isPlayer _x) then
	{
		_playerArray = _playerArray + [_x];
	};
} forEach crew _plane;
_countPArray = (count _playerArray) - 1;

["RS_INV_fnc_Server_PlayerAirDrop", 4, (format ["Players in Array (%1), Array Size (%2)", _playerArray, (_countPArray + 1)])] call RS_fnc_LoggingHelper;

[_plane, "Red"] remoteExec ["RS_INV_fnc_Server_PlaneLights", 2, false];

if (_countPArray != -1) then
{
	[(_playerArray select 0), "toJStand"] remoteExec ["RS_INV_fnc_Client_RemoteParaPlane", (_playerArray select 0), false];
	
	["RS_INV_fnc_Server_PlayerAirDrop", 4, (format ["Players (%1), Executing toJStand", (_playerArray select 0)])] call RS_fnc_LoggingHelper;
};

for "_i" from 1 to _countPArray do
{
	[(_playerArray select _i), "toStand"] remoteExec ["RS_INV_fnc_Client_RemoteParaPlane", (_playerArray select _i), false];
	
	["RS_INV_fnc_Server_PlayerAirDrop", 4, (format ["Players (%1), Executing toStand", (_playerArray select _i)])] call RS_fnc_LoggingHelper;
};

// Waits until the plane makes it to the drop zone
waitUntil {
	sleep 1; 
	(((_plane distance2D _position) <= 400) || (_plane == objNull))
};

if (_plane == objNull) exitWith
{
	["RS_fnc_Server_PlayerAirDrop", 2, "Player Para Drop Cancelled! Plane is NULL..."] call RS_fnc_LoggingHelper;
};

[_plane, "Green"] remoteExec ["RS_INV_fnc_Server_PlaneLights", 2, false];

sleep 2;

// Execute Static Line Script
while { _countPArray >= 0 } do
{
	[(_playerArray select _countPArray), "toDoor"] remoteExec ["RS_INV_fnc_Client_RemoteParaPlane", (_playerArray select _countPArray), false];
	
	["RS_INV_fnc_Server_PlayerAirDrop", 4, (format ["Players (%1), Executing toDoor", (_playerArray select _countPArray)])] call RS_fnc_LoggingHelper;
	
	_countPArray = _countPArray - 1;
	
	sleep 5;
};

/*
	END
*/