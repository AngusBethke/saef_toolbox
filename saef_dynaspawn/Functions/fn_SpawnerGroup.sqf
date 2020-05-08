/*	
	fn_SpawnerGroup.sqf
	Author: Angus Bethke
	Description: 
		Handles the spawning of AI and waypoint creation for Dyna Spawn using the variables passed to it.
*/

params
[
	"_spawnPos",
	"_facSide",
	"_faction",
	"_type",
	"_unitType",
	"_area",
	"_secondPos",
	"_remWeapAttach",
	"_azi",
	"_usePara",
	"_paraSpawn",
	"_group"
];

private
[
	"_cAWP",
	"_newGroup",
	"_veh",
	"_vehicle",
	"_vehCrew",
	"_garSuccess",
	"_script"
];

["DynaSpawn", 3, (format ["[SpawnerGroup] <IN> | Parameters: %1", _this])] call RS_fnc_LoggingHelper;

/* Run the Spawners */
if (_unitType == "INF") then
{
	if ((_usePara) && !((_type == "CA") OR (_type == "HK"))) then
	{
		["DynaSpawn", 2, (format ["[SpawnerGroup] Parachute Insertion may not be used with waypoint type %1!", _type])] call RS_fnc_LoggingHelper;
		_usePara = false;
	};
	
	/*
		// Spawn the Group
		_newGroup = [_spawnPos, _facSide, _faction,[],[],[],[],[],0] call BIS_fnc_spawnGroup;
		_newGroup deleteGroupWhenEmpty true;
		
		// Join all the units to our given group
		(units _newGroup) joinSilent _group;
	*/
	
	// Spawn the Group
	{
		_unit = _group createUnit [_x, _spawnPos, [], 0, "NONE"];
		
		waitUntil {
			sleep 0.1;
			!(isNull _unit)
		};
	} forEach _faction;

	// Will remove all weapon attachments from the spawned group
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
	// Vehicle Spawn
	_script = [_spawnPos, _azi, _faction, _group] spawn bis_fnc_spawnvehicle;
	
	waitUntil {
		sleep 1;
		((scriptDone _script) || (isNull _script))
	};
	
	_vehicle = vehicle (leader _group);
	
	// Remove Thermal for Spawned Vehicles to Make them 'not-so terminator-ish'
	_vehicle disableTIEquipment true;
	_vehicle disableNVGEquipment true;
	
	if (_usePara) then
	{
		["DynaSpawn", 2, (format ["[SpawnerGroup] Parachute Insertion may not be used with unit type [%1]!", _unitType])] call RS_fnc_LoggingHelper;
		_usePara = false;
	};
};

// Checks the task type and assigns them accordingly
if (_type == "PAT") then
{
	// Creates Waypoint for Patrolling a Position
	[_group, _spawnPos, _area, 8] spawn CBA_fnc_taskPatrol;
	_group setSpeedMode "LIMITED";
	_group setBehaviour "SAFE";
	_group setFormation ([] call RS_DS_fnc_GetRandomFormation);
};

if (_type == "DEF") then
{
	// Creates Waypoint for Defense of a Position
	[_group, _spawnPos, _area, 4, false] spawn CBA_fnc_taskDefend;
	_group setSpeedMode "LIMITED";
	_group setBehaviour "SAFE";
};

if (_type == "CA") then
{
	// Creates Waypoint for Counter Attack Type
	_cAWP = _group addWaypoint [_secondPos, 0];
	_cAWP setWaypointSpeed "FULL";
	_cAWP setWaypointType "SAD";
	_cAWP setWaypointBehaviour "AWARE";
	_group setFormation ([] call RS_DS_fnc_GetRandomFormation);
};

if (_type == "HK") then
{
	// Creates Waypoints for AI to Hunt down the Player Closest to them (Within Pre-defined Meters). The Equivalent of a Tracking Team.
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
		// Garrisons the group at the supplied secondPos
		_garSuccess = [_secondPos, _group, _area] call RS_DS_fnc_Garrison;
		
		// Garrison Failure will result in unit cleanup
		if (!_garSuccess) then
		{
			{
				deleteVehicle _x;
			} forEach units _grp;
		};
	}
	else
	{
		["DynaSpawn", 2, (format ["[SpawnerGroup] Vehicle cannot be Garrisoned!"])] call RS_fnc_LoggingHelper;
	};
};

// Paratrooper Spawn Section
if (_usePara) then
{
	_paraSpawn = _paraSpawn + [_secondPos, _group, _facSide];
	_paraSpawn spawn RS_DS_fnc_ParaInsertion;
};

// If type is NON the unit will be given no waypoints, allowing the user to have full control over them for custom scripts, waypoints etc.
["DynaSpawn", 3, (format ["[SpawnerGroup] <OUT> | Group: %1, Parameters: %2", _group, _this])] call RS_fnc_LoggingHelper;

/*
	END
*/