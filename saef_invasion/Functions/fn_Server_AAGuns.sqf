/**
	@namespace RS_INV
	@class Invasion
	@method RS_INV_fnc_Server_AAGuns
	@file fn_Server_AAGuns.sqf
	@summary Takes a list of given AA guns and sets them up to provide ambient fire
	
	@param array _gunArray
	@param string _gunFireVariable

	@usage ```[_gunArray, _gunFireVariable] spawn RS_INV_fnc_Server_AAGuns;```
	
**/

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
	_gunDirection = _x select 1;
	_gunClassName = _x select 2;
	_gunDoFire = _x select 3;
	
	if (isNil "_gunDoFire") then
	{
		_gunDoFire = true;
	};
	
	// Spawn the gun, and figure out some information about it
	_gun = [_gunPosition, _gunDirection, _gunClassName, (missionNamespace getVariable ["RS_INV_EnemySide", WEST])] call bis_fnc_spawnvehicle;
	_gunVehicle = _gun select 0;
	_gunCrew = crew _gunVehicle;
	_group = group (_gunCrew select 0);

	{
		_x setSkill 1;
		_x setVariable ["acex_headless_blacklist", true];
	} forEach units _group;

	_gunVehicle setVariable ["acex_headless_blacklist", true];
	[(_gunCrew select 0), _gunFireVariable, _gunDoFire] spawn RS_INV_fnc_Server_AAFire;
	
} forEach _gunArray;

/*
	END
*/