/**
	@namespace RS_INV
	@class Invasion
	@method RS_INV_fnc_Server_SpawnExtraAI
	@file fn_Server_SpawnExtraAI.sqf
	@summary Spawns some extra AI to populate the planes (makes them feel less empty)
	
	@param object _plane

	@usage ```[_plane] call RS_INV_fnc_Server_SpawnExtraAI;```
	
**/

/* 
	fn_Server_SpawnExtraAI.sqf

	Description:
		Spawns some extra AI to populate the planes (makes them feel less empty)
		
	How to Call:
		[
			_plane
		] call RS_INV_fnc_Server_SpawnExtraAI;
		
	Called by:
		fn_Server_SpawnPlane.sqf
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
	["RS_INV_fnc_SpawnExtraAI", 1, "No group returned from variable 'RS_INV_DefaultFriendlyAI'!"] call RS_fnc_LoggingHelper;
};

// Cull the extra AI to make space for the players in the aircraft
_units = [];
for "_i" from 0 to (12 - (missionNamespace getVariable ["RS_INV_PlaneSeatCount", 4])) do
{
	_units = _units + [(selectRandom _unitArr)];
};

["RS_INV_fnc_SpawnExtraAI", 4, (format ["Units [%1] that will be spawned for the extra AI", _units])] call RS_fnc_LoggingHelper;

// Get the spawn position for the friendly units
_friendlySpawn = missionNamespace getVariable ["RS_INV_DefaultFriendlyAI_Spawn", ""];
if (_friendlySpawn isEqualTo "") exitWith
{
	["RS_INV_fnc_SpawnExtraAI", 1, "No spawn position defined from variable 'RS_INV_DefaultFriendlyAI_Spawn'!"] call RS_fnc_LoggingHelper;
};

// Spawn the group and move them into the plane
_group = [(markerPos _friendlySpawn), (missionNamespace getVariable ["RS_FriendlySide", INDEPENDENT]), _units, [], [], [], [], [], 0] call BIS_fnc_spawnGroup;

["RS_INV_fnc_SpawnExtraAI", 3, (format ["Group [%1] created moving them to plane [%2]", _group, _plane])] call RS_fnc_LoggingHelper;

// Move all the units to the provided plane
{
	["RS_INV_fnc_SpawnExtraAI", 4, (format ["Moving unit [%1] to plane [%2]", _x, _plane])] call RS_fnc_LoggingHelper;
	_x assignAsCargo _plane;
	_x moveInCargo _plane;
} forEach (units _group);

/*
	END
*/