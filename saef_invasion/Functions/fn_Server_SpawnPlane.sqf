/* 
	fn_Server_SpawnPlane.sqf
	
	Description:
		Spawns the plane we need to conduct the air drops
		
	How to call:
		[
			_strPos,
			_endPos,
			_drpPos,
			_newPlane
		] call RS_INV_fnc_Server_SpawnPlane;
		
	Called by:
		fn_Server_AmbientAirDrop.sqf
		fn_Client_MountPlayers.sqf
		fn_Server_Invasion.sqf
*/

params
[
	"_strPos",
	"_endPos",
	"_drpPos",
	"_direction",
	"_newPlane"
];

private
[
	"_height",
	"_planeClassName",
	"_veh",
	"_vehicle",
	"_vehCrew",
	"_groupInf",
	"_cWP"
];

// Derive some information about our starting position
_height = 250 + (random 50);

_planeClassName = missionNamespace getVariable ["RS_INV_JumpPlaneClassname", "LIB_C47_Skytrain"];

// Spawn the Vehicle, and figure out some information about it
_veh = [[(_strPos select 0), (_strPos select 1), _height], _direction, _planeClassName, (missionNamespace getVariable ["RS_INV_FriendlySide", INDEPENDENT])] call bis_fnc_spawnvehicle;
_vehicle = _veh select 0;

// Debug hot vehicle start
_vehicle setPosATL [(_strPos select 0), (_strPos select 1), _height];
_vehicle setVelocityModelSpace [0, 30, 0];
_vehicle engineOn true;

_vehCrew = crew _vehicle;
_groupInf = group (_vehCrew select 0);

{
	_x allowDamage false; 
	_x flyInHeight _height; 
	_x allowFleeing 0;
	_x setVariable ["acex_headless_blacklist", true];
} forEach units _groupInf;

_vehicle setVariable ["acex_headless_blacklist", true];
_vehicle flyInHeight _height;
_vehicle allowDamage false;
_vehicle animate ["Hide_Door",1];

// Creates Waypoint for Vehicle Movement
_cWP = _groupInf addWaypoint [_endPos, 0];
_cWP setWaypointSpeed "FULL";
_cWP setWaypointType "MOVE";
_cWP setWaypointBehaviour "CARELESS";

if (_newPlane) then
{
	["RS_INV_fnc_Server_SpawnPlane", 3, (format ["Plane (%1) is a Player Specific Plane", _vehicle]), true] call RS_fnc_LoggingHelper;
	
	missionNamespace setVariable ["RS_INV_ActivePlane", [true, _vehicle], true];
	
	// Execute some stuff for the plane
	[[_vehicle], "RS_INV_fnc_Server_SpawnExtraAI", "call"] call RS_fnc_ExecScriptHandler;
	//[_vehicle] call RS_INV_fnc_Server_SpawnExtraAI;
	[_vehicle] spawn RS_INV_fnc_Server_WatchCargoNumber;
	[_vehicle, _drpPos] spawn RS_INV_fnc_Server_PlayerAirDrop;
	[_vehicle, _endPos] spawn RS_INV_fnc_Server_PlaneCleanup;
};

["RS_INV_fnc_Server_SpawnPlane", 3, (format ["Plane (%1) Created and Returned, Flying at Height %2", _vehicle, _height]), true] call RS_fnc_LoggingHelper;

// Return the Vehicle
_vehicle

/*
	END
*/