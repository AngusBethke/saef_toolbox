/* 
	fn_Server_AAFire.sqf 
	
	Description:
		Forces AA guns to fire/look into the Sky
		
	How to Call:
		[
			_unit,
			_phaseVar,
			_doFire
		] spawn RS_INV_fnc_Server_AAFire;
*/

params
[
	"_unit",
	"_phaseVar",
	"_doFire"
];

private 
[
	"_logicGroup",
	"_logic"
];

// This is a potential fix for the .rpt spam in a multiplayer environment caused by making the target a position input
if (_doFire) then
{
	_logicGroup = createGroup sideLogic;
	_logic = _logicGroup createUnit ["Logic", [(((getPosASL _unit) select 0) + 50), (((getPosASL _unit) select 1) + 50), (((getPosASL _unit) select 2) + 300)], [], 0, "NONE"];
	_logic = _logicGroup createUnit ["Logic", [(((getPosASL _unit) select 0) + 50), (((getPosASL _unit) select 1) - 50), (((getPosASL _unit) select 2) + 300)], [], 0, "NONE"];
	_logic = _logicGroup createUnit ["Logic", [(((getPosASL _unit) select 0) - 50), (((getPosASL _unit) select 1) + 50), (((getPosASL _unit) select 2) + 300)], [], 0, "NONE"];
	_logic = _logicGroup createUnit ["Logic", [(((getPosASL _unit) select 0) - 50), (((getPosASL _unit) select 1) - 50), (((getPosASL _unit) select 2) + 300)], [], 0, "NONE"];
};

while { (alive _unit) && ((missionNamespace getVariable [_phaseVar, 1]) == 1) } do
{
	if (_doFire) then
	{
		(vehicle _unit) setVehicleAmmo 1;
		
		_unit doSuppressiveFire (selectRandom (units _logicGroup));
	}
	else
	{
		_target = [
			((((getPosASL _unit) select 0) + 50) - random(100)),	// x - (X position 50m right to 50m left)
			((((getPosASL _unit) select 1) + 50) - random(100)),	// y - (Y position 50m front to 50m behind)
			(((getPosASL _unit) select 2) + 300)					// z - (Height 300m above)
		];
		
		_unit doWatch _target;
	};
	
	sleep 5;
};