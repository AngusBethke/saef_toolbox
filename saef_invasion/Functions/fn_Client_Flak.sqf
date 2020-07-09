/* 
	fn_Client_Flak.sqf
	
	Description: 
		Handles the creation of clientside flak for the Jump
		
	How to Call:
		[
			_unit
		] spawn RS_INV_fnc_Client_Flak;
		
	Called by:
		fn_Client_MoveIn.sqf
*/

params
[
	"_unit"
];

// Wait before starting the flak
waitUntil {
	sleep 5;
	(((getPosATL _unit) select 2) > 100)
};

// Run the creation of flak while the unit is higher than 100 meters
while { (((getPosATL _unit) select 2) > 100) } do
{
	_posX = selectRandom [((((getPosATL _unit) select 0) + 15) + random (35)), ((((getPosATL _unit) select 0) - 15) - random (35))];
	_posY = selectRandom [((((getPosATL _unit) select 1) + 15) + random (35)), ((((getPosATL _unit) select 1) - 15) - random (35))];
	_posZ = ((((getPosATL _unit) select 2) + 15) - random (30));

	//_flak = createVehicle ["SmallSecondary", [_posX, _posY, _posZ], [], 0, "CAN_COLLIDE"];
	_flak = "SmallSecondary" createVehicleLocal [_posX, _posY, _posZ];

	sleep (0.5 + (random (5)));
};

/*
	END
*/