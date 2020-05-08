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
	"_facSide"
];

["DynaSpawn", 3, (format ["[ParaInsertion] <IN> | Parameters: %1", _this])] call RS_fnc_LoggingHelper;

if (!(_vehicle isKindOf "Air")) exitWith
{
	["DynaSpawn", 1, (format ["[ParaInsertion] Cancelled, Vehicle %1 is not an Aerial Vehicle!", _vehicle])] call RS_fnc_LoggingHelper;
	["DynaSpawn", 3, (format ["[ParaInsertion] <OUT> | Parameters: %1", _this])] call RS_fnc_LoggingHelper;
};

// Generate our spawn position
if (_spawnPos isEqualTo []) then
{
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
		_pos = [_x select 0, _x select 1, _x select 2];
		if (([_pos, 1000] call RS_PLYR_fnc_GetClosestPlayer) isEqualTo [0,0,0]) exitWith
		{
			_spawnPos = _pos;
			_azi = _x select 3;
		};
	} forEach _spawnPosArr;
	
	["DynaSpawn", 4, (format ["[ParaInsertion] Position: %1, Direction: %2", _spawnPos, _azi])] call RS_fnc_LoggingHelper;
};

// On the slim chance it can't find a safe space to spawn the Helo, exit with an Error
if (_spawnPos isEqualTo []) exitWith
{
	["DynaSpawn", 1, (format ["[ParaInsertion] Cancelled, no safe spawn position found!"])] call RS_fnc_LoggingHelper;
	["DynaSpawn", 3, (format ["[ParaInsertion] <OUT> | Parameters: %1", _this])] call RS_fnc_LoggingHelper;
};

// Create the Vehicle
_vehArray = [_spawnPos, _azi, _vehicle, _facSide] call bis_fnc_spawnvehicle;
_veh = (_vehArray select 0);
_vGroup = (_vehArray select 2);

// Helo Height Fix
_veh flyInHeight 300;
{
	_x flyInHeight 300;
} forEach units _vGroup;

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

// Validate Available Seats
_seats = count (fullCrew [_veh, "cargo", true]);
_units = count (units _group);

if (_seats < _units) exitWith
{
	["DynaSpawn", 1, (format ["[ParaInsertion] Cancelled. Number of Available Seats [%1] is less than the group Size [%2]!", _seats, _units])] call RS_fnc_LoggingHelper;
	["DynaSpawn", 3, (format ["[ParaInsertion] <OUT> | Parameters: %1", _this])] call RS_fnc_LoggingHelper;
};

// Move the Group into the Helo
{
	_x assignAsCargo _veh;
	_x moveInCargo _veh;
} forEach units _group;

// Wait Until the Vehicle is by the spawn pos
waitUntil {
	sleep 2;
	(((_veh distance2D _insertionPos) <= 200) OR (({alive _x} count units _vGroup) == 0))
};

// If the vehicle is destroyed, exit out of the function
if (({alive _x} count units _vGroup) == 0) exitWith 
{
	["DynaSpawn", 2, (format ["[ParaInsertion] Cancelled, Vehicle Destroyed!"])] call RS_fnc_LoggingHelper;
	["DynaSpawn", 3, (format ["[ParaInsertion] <OUT> | Parameters: %1", _this])] call RS_fnc_LoggingHelper;
};

// Deploy the Paratroopers
{
	// Give Paratrooper Parachute
	removeBackpack _x;
	_x addBackpack "ACE_NonSteerableParachute";
	
	// Exit from Vehicle
	unassignVehicle _x; 
	_x action ["Eject", vehicle _x];
	
	// Wait for Next
	sleep 0.5;
} forEach units _group;

// Wait Until the Vehicle is back by it's start position (or it's longer than 3 minutes)
_count = 0;
waitUntil {
	sleep 2;
	_count = _count + 1;
	(((_veh distance2D _spawnPos) <= 200) OR (({alive _x} count units _vGroup) == 0) OR (_count == 90))
};

// If the vehicle is destroyed, exit out of the function
if (({alive _x} count units _vGroup) == 0) exitWith 
{
	["DynaSpawn", 2, (format ["[ParaInsertion] Cancelled, Vehicle Destroyed!"])] call RS_fnc_LoggingHelper;
	["DynaSpawn", 3, (format ["[ParaInsertion] <OUT> | Parameters: %1", _this])] call RS_fnc_LoggingHelper;
};

// Cleanup the Vehicle
{
	deleteVehicle _x;
} forEach crew _veh;

deleteVehicle _veh;

["DynaSpawn", 3, (format ["[ParaInsertion] <OUT> | Parameters: %1", _this])] call RS_fnc_LoggingHelper;

/*
	END
*/