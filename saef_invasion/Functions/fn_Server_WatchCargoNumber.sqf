/**
	@namespace RS_INV
	@class Invasion
	@method RS_INV_fnc_Server_WatchCargoNumber
	@file fn_Server_WatchCargoNumber.sqf
	@summary Watches the Cargo Number of the planes, if it exceeds x players, the plane is no longer allowed to carry players
	
	@param object _plane

	@usage ```[_plane] spawn RS_INV_fnc_Server_WatchCargoNumber;```
	
**/

/*
	fn_Server_WatchCargoNumber.sqf
	
	Description: 
		Watches the Cargo Number of the planes, if it exceeds x players, the plane is no longer allowed to carry players
		
	How to call:
		[
			_plane
		] spawn RS_INV_fnc_Server_WatchCargoNumber;
		
	Called by:
		fn_Server_SpawnPlane.sqf
*/

params
[
	"_plane"
];

private
[
	"_activePlane",
	"_isActive",
	"_tPlane"
];

waitUntil {
	sleep 0.1;
	_count = 0;
	{
		if (isPlayer _x) then
		{
			_count = _count + 1;
		};
	} forEach crew _plane;
	(_count >= (missionNamespace getVariable ["RS_INV_PlaneSeatCount", 4]))
};

// Quick check for whether or not this plane is active for spawns, if it is, disable it
_activePlane = missionNamespace getVariable ["RS_INV_ActivePlane", [false, objNull]];
_isActive = _activePlane select 0;
_tPlane = _activePlane select 1;

if ((_isActive) && (_plane == _tPlane)) then
{
	missionNamespace setVariable ["RS_INV_ActivePlane", [false, objNull], true];
};

/*
	END
*/