/* 
	fn_Server_PlaneCleanup.sqf 
	
	Description:
		Cleans up the plane when it gets to the end position
		
	How to Call:
		[
			_plane,
			_position
		] spawn RS_INV_fnc_Server_PlaneCleanup;
		
	Called by:
		fn_Server_AmbientAirDrop.sqf
		fn_Server_SpawnPlane.sqf
*/

params
[
	"_plane",
	"_position"
];

["RS_INV_fnc_Server_PlaneCleanup", 3, (format ["Cleanup started for Vehicle %1", _plane]), true] call RS_fnc_LoggingHelper;

// Waits until plane is near its destination
waitUntil {
	sleep 3; 
	(_plane distance2D _position) <= 300
};

["RS_INV_fnc_Server_PlaneCleanup", 3, (format ["Deleting Crew and Vehicle for %1", _plane]), true] call RS_fnc_LoggingHelper;

/* 
	Double Check that there are no players in the plane. 
	If there are, then eject them, else deletes all the crew in the Plane	
*/
{
	if (isPlayer _x) then
	{
		_x action ["Eject", _plane];
	}
	else
	{
		if (local _x) then
		{
			deleteVehicle _x;
		}
		else
		{
			[_x] remoteExec ["deleteVehicle", (owner _x), false];
		};
	};
} forEach crew _plane;

// Deletes the Plane
deleteVehicle _plane;

/*
	END
*/