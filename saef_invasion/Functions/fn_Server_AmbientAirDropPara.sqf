/* 
	fn_Server_AmbientAirDropPara.sqf 
	
	Description:
		Spawns the parachutes for the Ambient Air Drop Process
		
	How to Call:
		[
			_plane,
			_position
		] spawn RS_INV_fnc_Server_AmbientAirDropPara;
		
	Called by:
		fn_Server_AmbientAirDrop.sqf
*/

params
[
	"_plane",
	"_position"
];

private
[
	"_ranDis",
	"_planePos",
	"_parachute"
];

_ranDis = (random 100) + 300;

// Waits until the plane makes it to the drop zone
waitUntil {
	sleep 3; 
	(((_plane distance2D _position) <= _ranDis) || (_plane == objNull))
};

if (_plane != objNull) then
{
	["RS_INV_fnc_Server_AmbientAirDropPara", 3, (format ["Ambient Para Drop Started for [%1] at Position %2", _plane, _position])] call RS_fnc_LoggingHelper;

	// Execute Dummy Parachute Spawn
	for "_i" from 0 to 11 do
	{
		_planePos = getPosATL _plane;
		_parachute = createVehicle ["LIB_US_Parachute", [(_planePos select 0), (_planePos select 1), (_planePos select 2) - 10], [], 0, "NONE"];
		sleep 2;
		[_parachute] spawn RS_INV_fnc_Server_ParaDelete;
	};
}
else
{
	["RS_INV_fnc_Server_AmbientAirDropPara", 2, "Ambient Para Drop Cancelled! Plane is NULL..."] call RS_fnc_LoggingHelper;
};

/* 
	END
*/