/* 
	fn_Server_PlanePosDebug.sqf 
	
	Description:
		If the plane does something strange, reset its position
		
	How to Call:
		[
			_plane,
			_position,
			_direction
		] spawn RS_INV_fnc_Server_PlanePosDebug;
		
	Called by:
		fn_Server_AmbientAirDrop.sqf
		fn_Server_SpawnPlane.sqf
*/

params
[
	"_plane",
	"_position",
	"_direction",
	"_cleanupPosition"
];

private
[
	"_control"
];

["RS_INV_fnc_Server_PlaneCleanup", 3, (format ["Position Debug started for Vehicle %1", _plane])] call RS_fnc_LoggingHelper;

// While this plane is not null do this check
_control = 1;
while {_plane != objNull} do
{
	_height = 250 + (random 50);
	
	if (((getPosATL _plane) select 2) < 30) then
	{
		// Set the plane's position and direction
		_plane setPosATL [(_position select 0), (_position select 1), _height];
		_plane setDir _direction;
		
		// Give the plane some movement velocity
		_plane setVelocityModelSpace [0, 30, 0];
		_plane engineOn true;
		
		_control = _control + 1;
	};
	
	if (_control > 5) then
	{
		// Something's gone horribly wrong, we need to remove the players from this plane and send them back to base
		[_plane] remoteExecCall ["RS_INV_fnc_Client_Reset", 0, false];
		
		sleep 5;
		
		// Send the plane to the cleanup position 
		_plane setPosATL [(_cleanupPosition select 0), (_cleanupPosition select 1), _height];
	};
	
	sleep 1;
};

/*
	END
*/