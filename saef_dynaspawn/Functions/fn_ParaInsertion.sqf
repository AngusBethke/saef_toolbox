/**
	@namespace RS_DS
	@class DynaSpawn
	@method RS_DS_fnc_ParaInsertion
	@file fn_ParaInsertion.sqf
	@summary This is a function built for deploying AI via Parachute Insertion
	
	@param vehicle _vehicle
	@param position _spawnPos
	@param number _azi
	@param position _insertionPos
	@param group _group
	@param side _facSide
**/

/*	
	fn_ParaInsertion.sqf
	Author: Angus Bethke
	Required Mod(s): ACE
	Description: 
		This is a function built for deploying AI via Parachute Insertion
*/

params
[
	"_vehicle",
	"_spawnPos",
	"_azi",
	"_insertionPos",
	"_group",
	"_facSide",
	"_originalSpawnPos"
];

if (missionNamespace getVariable ["SAEF_DynaSpawn_ExtendedLogging", false]) then
{
	["DynaSpawn", 4, (format ["[ParaInsertion] <IN> | Parameters: %1", _this])] call RS_fnc_LoggingHelper;
};

if (!(_vehicle isKindOf "Air")) exitWith
{
	["DynaSpawn", 1, (format ["[ParaInsertion] Cancelled, Vehicle %1 is not an Aerial Vehicle!", _vehicle])] call RS_fnc_LoggingHelper;

	if (missionNamespace getVariable ["SAEF_DynaSpawn_ExtendedLogging", false]) then
	{
		["DynaSpawn", 4, (format ["[ParaInsertion] <OUT> | Parameters: %1", _this])] call RS_fnc_LoggingHelper;
	};
};

// Generate our spawn position
if (_spawnPos isEqualTo []) then
{
	private
	[
		"_spawnPosArr"
	];

	_spawnPosArr = 
	[
		// 4000 meters north
		[
			_insertionPos select 0,
			(_insertionPos select 1) + 4000,
			(_insertionPos select 2) + 300,
			180
		],
		
		
		// 4000 meters south
		[
			_insertionPos select 0,
			(_insertionPos select 1) - 4000,
			(_insertionPos select 2) + 300,
			90
		],
		
		// 4000 meters east
		[
			(_insertionPos select 0) + 4000,
			_insertionPos select 1,
			(_insertionPos select 2) + 300,
			270
		],
		
		// 4000 meters west
		[
			(_insertionPos select 0) - 4000,
			_insertionPos select 1,
			(_insertionPos select 2) + 300,
			0
		]
	];
	
	// Derive the SpawnPos
	{
		private
		[
			"_pos"
		];

		_pos = [_x select 0, _x select 1, _x select 2];
		if (([_pos, 1000] call RS_PLYR_fnc_GetClosestPlayer) isEqualTo [0,0,0]) exitWith
		{
			_spawnPos = _pos;
			_azi = _x select 3;
		};
	} forEach _spawnPosArr;
	
	if (missionNamespace getVariable ["SAEF_DynaSpawn_ExtendedLogging", false]) then
	{
		["DynaSpawn", 4, (format ["[ParaInsertion] Position: %1, Direction: %2", _spawnPos, _azi])] call RS_fnc_LoggingHelper;
	};
}
else
{
	// Move the spawn pos around a tad if there is one specified
	_spawnPos = _spawnPos getPos [(random 360), (random 100)];
};

// On the slim chance it can't find a safe space to spawn the Helo, exit with an Error
if (_spawnPos isEqualTo []) exitWith
{
	["DynaSpawn", 1, (format ["[ParaInsertion] Cancelled, no safe spawn position found!"])] call RS_fnc_LoggingHelper;

	if (missionNamespace getVariable ["SAEF_DynaSpawn_ExtendedLogging", false]) then
	{
		["DynaSpawn", 4, (format ["[ParaInsertion] <OUT> | Parameters: %1", _this])] call RS_fnc_LoggingHelper;
	};
};

private
[
	"_vehArray",
	"_veh",
	"_vGroup"
];

// Create the Vehicle
_vehArray = [_spawnPos, _azi, _vehicle, _facSide] call bis_fnc_spawnvehicle;
_veh = (_vehArray select 0);
_vGroup = (_vehArray select 2);

// Helo Height Fix
_veh flyInHeight 300;
{
	["SpawnProtection", [_x]] spawn RS_DS_fnc_UnitHelper;
	_x flyInHeight 300;
} forEach units _vGroup;

// Add units to Zeus
if (missionNamespace getVariable ["SAEF_DynaSpawn_AddToZeus", false]) then
{
	[_vGroup] remoteExec ["RS_DS_fnc_AddGroupToZeus", 2, false];
};

private
[
	"_wp1",
	"_wp2"
];

// Create Waypoints
_wp1 = _vGroup addWaypoint [_insertionPos, 0];
_wp1 setWaypointSpeed "NORMAL";
_wp1 setWaypointType "MOVE";
_wp1 setWaypointBehaviour "AWARE";

_wp2 = _vGroup addWaypoint [_spawnPos, 1];
_wp2 setWaypointSpeed "NORMAL";
_wp2 setWaypointType "MOVE";
_wp2 setWaypointBehaviour "AWARE";

sleep 0.1;

private
[
	"_seats",
	"_units",
	"_vehicles"
];

// Validate Available Seats
_seats = count (fullCrew [_veh, "cargo", true]);
_units = count (units _group);
_vehicles = [];

{
	_vehicles pushBackUnique (vehicle _x);
} forEach (units _group);

if ((_seats < _units) && ((count _vehicles) > 1)) exitWith
{
	// Cleanup the Vehicle
	{
		deleteVehicle _x;
	} forEach crew _veh;

	deleteVehicle _veh;

	["DynaSpawn", 1, (format ["[ParaInsertion] Cancelled. Number of Available Seats [%1] is less than the group Size [%2]!", _seats, _units])] call RS_fnc_LoggingHelper;
	
	if (missionNamespace getVariable ["SAEF_DynaSpawn_ExtendedLogging", false]) then
	{
		["DynaSpawn", 4, (format ["[ParaInsertion] <OUT> | Parameters: %1", _this])] call RS_fnc_LoggingHelper;
	};
};

// If there is only one vehicle
if ((count _vehicles) == 1) then
{
	private
	[
		"_cargoItem"
	];

	_cargoItem = (_vehicles select 0);
	_cargoItem attachTo [_veh, [0,0,-10]];
}	
else
{
	// Move the Group into the Helo
	{
		_x assignAsCargo _veh;
		_x moveInCargo _veh;
	} forEach units _group;
};

// Wait Until the Vehicle is by the spawn pos
waitUntil {
	sleep 2;
	(((_veh distance2D _insertionPos) <= 200) || (({alive _x} count units _vGroup) == 0) || !(canMove _veh))
};

// If the vehicle is destroyed, exit out of the function
if (({alive _x} count units _vGroup) == 0) exitWith 
{
	["DynaSpawn", 2, (format ["[ParaInsertion] Cancelled, Vehicle Destroyed!"])] call RS_fnc_LoggingHelper;

	if (missionNamespace getVariable ["SAEF_DynaSpawn_ExtendedLogging", false]) then
	{
		["DynaSpawn", 4, (format ["[ParaInsertion] <OUT> | Parameters: %1", _this])] call RS_fnc_LoggingHelper;
	};
};

// If there is only one vehicle
if ((count _vehicles) == 1) then
{
	private
	[
		"_cargoItem"
	];

	_cargoItem = (_vehicles select 0);

	// Drop item from plane
	detach _cargoItem;

	sleep 3;

	// Deploy parachute and attach item
	_para = createVehicle ["B_Parachute_02_F", (getPos _cargoItem), [], 0, ""];
	_cargoItem attachTo [_para, [0,0,0]];

	// Detach vehicle when parachute is near the ground or it's been longer than 4 minutes
	[_cargoItem, _para] spawn {
		params
		[
			"_cargoItem",
			"_para"
		];

		private
		[
			"_control"
		];

		_control = 0;
		waitUntil {
			sleep 0.1;
			_control = _control + 1;
			((((position _cargoItem) select 2) < 0.6) || (isNil "_para") || (_control >= 2400))
		};

		detach _cargoItem;
	};
}	
else
{
	// Deploy the Paratroopers
	{
		// Store the units backpack
		private
		[
			"_backpack"
		];

		_backpack = backpack _x;  

		// Give paratrooper parachute
		removeBackpack _x;
		_x addBackpack "ACE_NonSteerableParachute";
		
		// Exit from vehicle
		unassignVehicle _x;  
		moveOut _x;

		// Ensure the unit gets their backpack back once they are on the ground
		if (_backpack != "") then
		{
			[_x, _backpack] spawn
			{
				params
				[
					"_unit",
					"_backpack"
				];

				sleep 10;

				waitUntil {
					sleep 1;
					(((vehicle _unit) == _unit) || (!alive _unit))
				};

				if (alive _unit) then
				{
					_unit addBackpack _backpack;
				};
			};
		};
		
		// Wait for next unit
		sleep 0.5;
	} forEach units _group;
};

// Wait Until the Vehicle is back by it's start position (or it's longer than 3 minutes)
_count = 0;
waitUntil {
	sleep 2;
	_count = _count + 1;
	(((_veh distance2D _spawnPos) <= 200) || (({alive _x} count units _vGroup) == 0) || (_count == 90) || !(canMove _veh))
};

// If the vehicle is destroyed, exit out of the function
if (({alive _x} count units _vGroup) == 0) exitWith 
{
	["DynaSpawn", 2, (format ["[ParaInsertion] Cancelled, Vehicle Destroyed!"])] call RS_fnc_LoggingHelper;

	if (missionNamespace getVariable ["SAEF_DynaSpawn_ExtendedLogging", false]) then
	{
		["DynaSpawn", 4, (format ["[ParaInsertion] <OUT> | Parameters: %1", _this])] call RS_fnc_LoggingHelper;
	};
};

// Cleanup the Vehicle (if it's still alive)
if ((alive _veh) && (canMove _veh)) then
{
	{
		deleteVehicle _x;
	} forEach crew _veh;

	deleteVehicle _veh;
}
else
{
	// If we've reach this point it means that the helicopter is dead, but the group is still alive. So we will turn them into hunter killers.
	[_vGroup, 4000, false, []] spawn RS_DS_fnc_HunterKiller;
};

if (missionNamespace getVariable ["SAEF_DynaSpawn_ExtendedLogging", false]) then
{
	["DynaSpawn", 4, (format ["[ParaInsertion] <OUT> | Parameters: %1", _this])] call RS_fnc_LoggingHelper;
};

/*
	END
*/