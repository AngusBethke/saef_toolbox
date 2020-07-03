/* 
	fn_Server_AAFire.sqf 
	
	Description:
		Forces AA guns to fire into the Sky
		
	How to Call:
		[
			_unit,
			_phaseVar
		] spawn RS_INV_fnc_Server_AAFire;
*/

params
[
	"_unit",
	"_phaseVar"
];

while { (alive _unit) && ((missionNamespace getVariable [_phaseVar, 1]) == 1) } do
{
	(vehicle _unit) setVehicleAmmo 1;
	
	_target = [
		(((getPosASL _unit) + 50) - random(100)),	// x - (X position 50m right to 50m left)
		(((getPosASL _unit) + 50) - random(100)),	// y - (Y position 50m front to 50m behind)
		((getPosASL _unit) + 300)					// z - (Height 300m above)
	];
	
	_unit doSuppressiveFire _target;
	
	sleep 10;
};