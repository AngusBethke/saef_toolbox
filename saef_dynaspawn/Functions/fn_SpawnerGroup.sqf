/**
	@namespace RS_DS
	@class DynaSpawn
	@method RS_DS_fnc_SpawnerGroup
	@file fn_SpawnerGroup.sqf
	@summary Handles the spawning of AI and waypoint creation for Dyna Spawn using the variables passed to it.
	
	@param position _spawnPos
	@param side _facSide
	@param any _faction
	@param string _type
	@param string _unitType
	@param int _area
	@param position _secondPos
	@param any _remWeapAttach
	@param number _azi
	@param bool _usePara
	@param any _paraSpawn
	@param group _group

**/

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

if (missionNamespace getVariable ["SAEF_DynaSpawn_ExtendedLogging", false]) then
{
	["DynaSpawn", 4, (format ["[SpawnerGroup] <IN> | Parameters: %1", _this])] call RS_fnc_LoggingHelper;
};

/* Run the Spawners */
if (_unitType == "INF") then
{
	if ((_usePara) && !((_type == "CA") OR (_type == "HK"))) then
	{
		["DynaSpawn", 2, (format ["[SpawnerGroup] Parachute Insertion may not be used with waypoint type %1!", _type])] call RS_fnc_LoggingHelper;
		_usePara = false;
	};

	private
	[
		"_posArr"
	];
	_posArr = [_secondPos, _area, (count _faction)] call RS_DS_fnc_GetGarrisonPositions;
	
	// Spawn the Group
	{
		private
		[
			"_tempSpawnPos",
			"_unit"
		];

		_tempSpawnPos = _spawnPos;

		// If we have garrison positions available we're just gonna spawn them right there, less overhead
		if (!(_posArr isEqualTo [])) then
		{
			_tempSpawnPos = (_posArr select _forEachIndex);
		};

		_unit = _group createUnit [_x, _tempSpawnPos, [], 0, "NONE"];
		
		waitUntil {
			sleep 0.1;
			!(isNull _unit)
		};

		_unit setSkill (selectRandom [0.25, 0.3, 0.35, 0.4, 0.45, 0.5, 0.55, 0.6, 0.65, 0.7, 0.75]);

		// Ensure the AI aren't killed as they load in
		[_unit] spawn RS_DS_fnc_SpawnProtection;

		if (_type == "GAR") then
		{
			_unit setUnitPos (selectRandom ["UP", "MIDDLE"]);
			_unit disableAI "PATH";
			_unit setDir (random(360));
		}
		else
		{
			// Force the units to move a bit so they don't stand in a clump
			if ((_type in ["PAT", "CA", "HK"]) && !_usePara) then
			{
				_unit doMove (_unit getRelPos [5, (random(360))]);
			};
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
	[_group, _spawnPos, _area] call RS_DS_fnc_TaskPatrol;
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
		[_secondPos, _area, _group] call RS_DS_fnc_Garrison;
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

// Add units to Zeus
if (missionNamespace getVariable ["SAEF_DynaSpawn_AddToZeus", false]) then
{
	[_group] remoteExec ["RS_DS_fnc_AddGroupToZeus", 2, false];
};

// Let us know group has been spawned
["DynaSpawn", 3, (format ["[SpawnerGroup] Spawn Complete for Group: %1", _group])] call RS_fnc_LoggingHelper;

/*
	END
*/