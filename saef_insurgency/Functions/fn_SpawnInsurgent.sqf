/*
	fn_SpawnInsurgent.sqf
	Description: Spawns an Insurgent at given location
	How to call: 
		[
			<position: [0,0,0]>, 
			<position: [0,0,0]>, 
			<radius: 100>, 
			<class: "civi_1">, 
			<loadout: "Loadouts\Civilian\AfricanCivilian.sqf">
		] call RS_INS_fnc_SpawnInsurgent;
*/

params
[
	 "_loc"
	,"_pos"
	,"_rad"
	,"_class"
	,"_loadout"
];

private
[
	"_group"
];

// Spawns the Group
if (_loc isEqualTo []) then
{
	_group = [_pos, "PAT", [_class], CIVILIAN, _rad, _pos, false] call RS_DS_fnc_DynaSpawn;
}
else
{
	_group = [_loc, "PAT", [_class], CIVILIAN, _rad, _pos, false] call RS_DS_fnc_DynaSpawn;
};

// Group Specific Settings
{
	
	[_x, true] execVM _loadout;
	[_x] call RS_INS_fnc_AddWeapons;
	_x doMove ([((getPos _x) select 0) + 5, (getPos _x) select 1, (getPos _x) select 2]);
	_x enableFatigue false;
	_x setVariable ["RS_Insurgency_IsInsurgent", true, true];
} forEach units _group;