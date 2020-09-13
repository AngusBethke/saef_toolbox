/*
	fn_SpawnInsurgents.sqf
	Description: Spawns Insurgents within a given area
	How to call: 
		[
			<position: [0,0,0]>, 
			<radius: 100>, 
			<count: 10>, 
			<class: "civi_1">, 
			<loadout: "Loadouts\Civilian\AfricanCivilian.sqf">
		] call RS_INS_fnc_SpawnInsurgents;
*/

params
[
	 "_pos"
	,"_rad"
	,"_cnt"
	,"_cls"
	,"_ldt"
];

private
[
	"_spnArr"
];

_spnArr = [];

// Derive Spawn Points Based on Number of Buildings
_buildings = nearestObjects [_pos, ["building"], _rad];

{
	if ((_x buildingPos 0) isEqualTo [0,0,0]) then
	{
		_buildings = _buildings - [_x];
	};
} forEach _buildings;

if ((count _buildings) > _cnt) then
{
	for "_i" from 1 to  ((count _buildings) - _cnt) do
	{
		_building = SelectRandom _buildings;
		_buildings = _buildings - [_building];
	};
};

{
	// Set Spawn Point
	_spnArr = _spnArr + [position _x];
} forEach _buildings;

if (!(_spnArr isEqualTo [])) then
{
	_extraSpawns = 0;
	if !((count _spnArr) >= _cnt) then
	{
		_extraSpawns = _cnt - (count _spnArr);
	};
	
	// Spawn units in buildings
	{
		[_x, _pos, _rad, _cls, _ldt] call RS_INS_fnc_SpawnInsurgent;
	} forEach _spnArr;
	
	// Spawns extra units in the middle of the location
	for "_i" from 0 to (_extraSpawns - 1) do
	{
		[[], _pos, _rad, _cls, _ldt] call RS_INS_fnc_SpawnInsurgent;
	};
}
else
{
	// Just dump them in the middle of the area and hope for the best
	for "_i" from 0 to (_cnt - 1) do
	{
		[[], _pos, _rad, _cls, _ldt] call RS_INS_fnc_SpawnInsurgent;
	}
};

/*
	END
*/