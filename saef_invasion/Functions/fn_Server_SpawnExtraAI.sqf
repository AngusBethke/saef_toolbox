/* 
	fn_Server_SpawnExtraAI.sqf

	Description:
		Spawns some extra AI to populate the planes (makes them feel less empty)
		
	How to Call:
		[
			_plane
		] call RS_INV_fnc_Server_SpawnExtraAI;
		
	Called by:
		fn_Server_SpawnC47.sqf
*/

params
[
	"_plane"
];

private
[
	"_unitArr",
	"_units",
	"_friendlySpawn",
	"_group"
];

// Get the friendly ai units to spawn
_unitArr = missionNamespace getVariable ["RS_INV_DefaultFriendlyAI", []];
if (_unitArr isEqualTo []) exitWith
{
	["RS_INV_fnc_SpawnExtraAI", 1, "No group returned from variable 'RS_INV_DefaultFriendlyAI'!", true] call RS_fnc_LoggingHelper;
};

// Cull the extra AI to make space for the players in the aircraft
for "_i" from 0 to (12 - (missionNamespace getVariable ["RS_INV_PlaneSeatCount", 4])) do
{
	_units = _units + [_unitArr select _i];
};

// Get the spawn position for the friendly units
_friendlySpawn = missionNamespace getVariable ["RS_INV_DefaultFriendlyAI_Spawn", ""];
if (_friendlySpawn isEqualTo "") exitWith
{
	["RS_INV_fnc_SpawnExtraAI", 1, "No spawn position defined from variable 'RS_INV_DefaultFriendlyAI_Spawn'!", true] call RS_fnc_LoggingHelper;
};

// Spawn the group and move them into the plane
_group = [(markerPos _friendlySpawn), (missionNamespace getVariable ["RS_FriendlySide", INDEPENDENT]), _units, [], [], [], [], [], 0] call BIS_fnc_spawnGroup;

// Move all the units to the provided plane
{
	_x moveInCargo _plane;
} forEach (units _group);

/*
	END
*/