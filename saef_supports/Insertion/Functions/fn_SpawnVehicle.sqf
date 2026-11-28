/*
	fn_SpawnVehicle.sqf

	Description:
		Handles the creation and life of the vehicle for paradrop
*/

params
[
	"_location",
	"_type",
	["_vehicleStart", [0,0,0]],
	["_delegated", false]
];

// If this hasn't been delegated yet it's going to cause an error in the queue system
if (!_delegated) exitWith
{
	[_location, _type, _vehicleStart, true] spawn SAEF_ASA_INS_fnc_SpawnVehicle;
};

// Set up the public variables for access
private
[
	"_activeVar"
];

_activeVar = format ["SAEF_ASA_INS_%1_CurrentlyActive", toUpper(_type)];

// Cannot have two vehicles of the same type active at the same time
if (missionNamespace getVariable [_activeVar, false]) exitWith
{
	["SAEF Insertion Spawn Vehicle", 1, format ["Script already running! Params: %1", _this]] call RS_fnc_LoggingHelper;

	// Exit with null object
	objNull
};

missionNamespace setVariable [_activeVar, true, true];

private
[
	"_activeVar_Vehicle",
	"_paraVar",
	"_vehicleVar_Location"
];

_activeVar_Vehicle = format ["SAEF_ASA_INS_%1_CurrentlyActive_Plane", toUpper(_type)];
_paraVar = format ["SAEF_ASA_INS_%1_StartDeployment", toUpper(_type)];
_vehicleVar_Location = "SAEF_ASA_INS_Vehicle_Location";

// Fetch our vehicle from the variable
private
[
	"_vehicles",
	"_vehicleVariable"
];

switch toUpper(_type) do
{
	case "CARGO": 
	{
		_vehicleVariable = "SAEF_ASA_INS_HeavyParadropVehicles";
	};

	default 
	{
		_vehicleVariable = "SAEF_ASA_INS_ParadropVehicles";
	};
};

_vehicles = missionNamespace getVariable [_vehicleVariable, []];

if (_vehicles isEqualTo []) exitWith
{
	["SAEF_ASA_INS_fnc_SpawnVehicle", 1, format ["No vehicles found for variable: %1", _vehicleVariable]] call RS_fnc_LoggingHelper;
	
	// Exit with null object
	objNull
};

// Figure out where our vehicle is going
private
[
	"_positionArray"
];

if (_vehicleStart isEqualTo [0,0,0]) then
{
	_vehicleStart = (_location getRelPos [3000, 180])
};

_vehicleStart = [(_vehicleStart select 0), (_vehicleStart select 1), 350];

_positionArray = 
[
	(getPos _location),
	(_location getRelPos [1000, 0]),
	_vehicleStart
];

// Create the Vehicle
private
[
	"_vehicleClassname",
	"_vehicleSide"
];

_vehicleClassname = selectRandom _vehicles;
_vehicleSide = missionNamespace getVariable ["SAEF_ASA_INS_ParadropVehicle_Side", CIVILIAN];

([_vehicleStart, (getDir _location), _vehicleClassname, _vehicleSide] call BIS_fnc_SpawnVehicle) params
[
	"_vehicle", 
	"_crew", 
	"_group"
];

if (_vehicleClassname == "RHS_C130J") then
{
	private
	[
		"_unit"
	];

	_unit = _group createUnit ["rhsusf_airforce_pilot", [0,0,0], [], 0, "CARGO"];
};

_vehicle flyInHeight 350;
_vehicle allowDamage false;
_vehicle setVehicleLock "LOCKED";

// Remove Inventory from Vehicle
clearWeaponCargoGlobal _vehicle;
clearBackpackCargoGlobal _vehicle;
clearMagazineCargoGlobal _vehicle;
clearItemCargoGlobal _vehicle;

{
	_x flyInHeight 350;
	_x allowFleeing 0;
	_x allowDamage false;
} forEach (units _group);

// Set our active vehicle
missionNamespace setVariable [_activeVar_Vehicle, _vehicle, true];
_vehicle setVariable [_vehicleVar_Location, _location, true];

// Create waypoints for vehicle
{
	private
	[
		"_waypoint"
	];

	_waypoint = _group addWaypoint [_x, _forEachIndex];
	_waypoint setWaypointSpeed "LIMITED";
	_waypoint setWaypointType "MOVE";
	_waypoint setWaypointBehaviour "CARELESS";

} forEach _positionArray;

// Wait until vehicle is near the drop zone
waitUntil {
	sleep 1;
	((_vehicle distance2D _location) <= 200)
};

// Clear active vehicle to avoid weird ordering issues
missionNamespace setVariable [_activeVar_Vehicle, nil, true];

sleep 1;

// Mark that it is time to deploy the shutes
_vehicle setVehicleLock "UNLOCKED";
missionNamespace setVariable [_paraVar, true, true];

sleep 10;

// Clear active variables
missionNamespace setVariable [_paraVar, nil, true];
missionNamespace setVariable [_activeVar, nil, true];
_vehicle setVariable [_vehicleVar_Location, nil, true];

// Wait until vehicle is near the start position
waitUntil {
	sleep 1;
	((_vehicle distance2D _vehicleStart) <= 200)
};

// Cleanup the vehicle
{
	deleteVehicle _x;
} forEach crew _vehicle;

deleteVehicle _vehicle;