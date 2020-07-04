/* 
	fn_Server_AAGuns.sqf 
	
	Description:
		Takes a list of given AA guns and sets them up to provide ambient fire
		
	How to Call:
		[
			_gunArray,
			_gunFireVariable
		] call RS_INV_fnc_Server_AAGuns;
*/

params
[
	"_gunArray",
	"_gunFireVariable"
];

{
	_gunPosition = _x select 0;
	_gunClassName = _x select 1;
	
	// Spawn the gun, and figure out some information about it
	_gun = [_gunPosition, _direction, _gunClassName, (missionNamespace getVariable ["RS_INV_EnemySide", WEST])] call bis_fnc_spawnvehicle;
	_gunVehicle = _gun select 0;
	_gunCrew = crew _gunVehicle;
	_group = group (_gunCrew select 0);

	{
		_x setSkill 1;
		_x setVariable ["acex_headless_blacklist", true];
	} forEach units _group;

	_gunVehicle setVariable ["acex_headless_blacklist", true];
	[(_gunCrew select 0), _gunFireVariable] spawn RS_INV_fnc_Server_AAFire;
	
} forEach _gunArray;

/*
	END
*/