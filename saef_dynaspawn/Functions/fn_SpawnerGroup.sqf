/*	
	Function: fn_SpawnerGroup.sqf
	Author: Angus Bethke
	Required Function: fn_DynaSpawn
	Description: Handles the spawning of AI and waypoint creation for Dyna Spawn using the variables passed to it.
	Last Modified: 15-11-2019		
*/

//Private Variables	
private
[
	"_spawnPos",
	"_facSide",
	"_faction",
	"_type",
	"_unitType",
	"_area",
	"_secondPos",
	"_remWeapAttach",
	"_debug",
	"_cAWP",
	"_group",
	"_newGroup",
	"_veh",
	"_vehicle",
	"_vehCrew",
	"_azi",
	"_paraSpawn"
];
	
_spawnPos = _this select 0;
_facSide = _this select 1;
_faction = _this select 2;
_type = _this select 3;
_unitType = _this select 4;
_area = _this select 5;
_secondPos = _this select 6;
_remWeapAttach = _this select 7;
_azi = _this select 8;
_usePara = _this select 9;
_paraSpawn = _this select 10;
_group = _this select 11;
_debug = missionNamespace getVariable "RS_DS_Debug";

/* Run the Spawners */
if (_unitType == "INF") then
{
	if ((_usePara) && !((_type == "CA") OR (_type == "HK"))) then
	{
		diag_log format ["%1 [WARNING] Parachute Insertion may not be used with waypoint type %2!", (_debug select 1), _type];
		_usePara = false;
	};

	/* Spawn the Group */
	_newGroup = [_spawnPos, _facSide, _faction,[],[],[],[],[],0] call BIS_fnc_spawnGroup;
	(units _newGroup) joinSilent _group;
	
	/* // This seems to hold server processing when run
	{
		_group createUnit [_x, _spawnPos, [], 0, "NONE"];
		sleep 0.1;
	} forEach _faction;
	*/

	/* Will remove all weapon attachments from the spawned group */
	if (_remWeapAttach) then
	{
		{
			removeAllPrimaryWeaponItems _x; 
			removeAllHandgunItems _x;
		} foreach units _group;
	};
};

if (_unitType == "VEH") then
{
	/* Vehicle Spawn */
	_script = [_spawnPos, _azi, _faction, _group] spawn bis_fnc_spawnvehicle;
	
	waitUntil {
		sleep 1;
		(scriptDone _script)
	};
	
	_vehicle = vehicle (leader _group);
	
	/* Remove Thermal for Spawned Vehicles to Make them 'not-so terminator-ish' */
	_vehicle disableTIEquipment true;
	_vehicle disableNVGEquipment true;
	
	if (_usePara) then
	{
		diag_log format ["%1 [WARNING] Parachute Insertion may not be used with unit type %2!", (_debug select 1), _unitType];
		_usePara = false;
	};
};

/* Checks the task type and assigns them accordingly */
if (_type == "PAT") then
{
	/* Creates Waypoint for Patrolling a Position */
	[_group, _spawnPos, _area, 8] spawn CBA_fnc_taskPatrol;
	_group setSpeedMode "LIMITED";
	_group setBehaviour "SAFE";
	_group setFormation ([] call RS_DS_fnc_GetRandomFormation);
};

if (_type == "DEF") then
{
	/* Creates Waypoint for Defense of a Position */
	[_group, _spawnPos, _area, 4, false] spawn CBA_fnc_taskDefend;
	_group setSpeedMode "LIMITED";
	_group setBehaviour "SAFE";
};

if (_type == "CA") then
{
	/* Creates Waypoint for Counter Attack Type */
	_cAWP = _group addWaypoint [_secondPos, 0];
	_cAWP setWaypointSpeed "FULL";
	_cAWP setWaypointType "SAD";
	_cAWP setWaypointBehaviour "AWARE";
	_group setFormation ([] call RS_DS_fnc_GetRandomFormation);
};

if (_type == "HK") then
{
	/* Creates Waypoints for AI to Hunt down the Player Closest to them (Within Pre-defined Meters). The Equivalent of a Tracking Team. */
	_group setCombatMode "RED";
	_group setSpeedMode "FULL";
	_group setBehaviour "AWARE";
	_group setFormation ([] call RS_DS_fnc_GetRandomFormation);
	[_group, _area, _usePara, _secondPos] spawn RS_DS_fnc_HunterKiller;
};

if (_type == "GAR") then
{
	if (_unitType != "VEH") then
	{
		/* Garrisons the group at the supplied secondPos */
		[_secondPos, _group, _area] spawn RS_DS_fnc_Garrison;
	}
	else
	{
		diag_log format ["%1 [ERROR] Vehicle cannot be Garrisoned", (_debug select 1)];
	};
};

/* Paratrooper Spawn Section */
if (_usePara) then
{
	_paraSpawn = _paraSpawn + [_secondPos, _group, _facSide];
	_paraSpawn spawn RS_DS_fnc_ParaInsertion;
};

/* If type is NON the unit will be given no waypoints, allowing the user to have full control over them for custom scripts, waypoints etc. */
if (_debug select 0) then
{
	diag_log format ["%2 [INFO] fn_SpawnerGroup Created Group: %1", (_debug select 1), _group];
};

/*
	END
*/