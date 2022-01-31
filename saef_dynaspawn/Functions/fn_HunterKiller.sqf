/**
	@namespace RS_DS
	@class DynaSpawn
	@method RS_DS_fnc_HunterKiller
	@file fn_HunterKiller.sqf
	@summary Uses a passed group and area of operation to create waypoints for AI that continously hunt the nearest player to them.
	
	@param group _groupHunt
	@param any _areaOfOperation
	@param bool _usePara
	@param position _secondPos
**/

/*
	fn_HunterKiller.sqf
	Author: Angus Bethke
	Description: 
		Uses a passed group and area of operation to create waypoints for AI that continously hunt the nearest player to them.
*/

params
[
	"_groupHunt",
	"_areaOfOperation",
	"_usePara",
	"_secondPos"
];

if (missionNamespace getVariable ["SAEF_DynaSpawn_ExtendedLogging", false]) then
{
	["DynaSpawn", 4, (format ["[HunterKiller] <IN> | Parameters: %1", _this])] call RS_fnc_LoggingHelper;
};

// Declarations
private
[
	"_enemySide",
	"_vehicles"
];

_enemySide = side _groupHunt;
_vehicles = [];

{
	_x enableStamina false;
} forEach units _groupHunt;

// If we're using the parachute insertion, we should wait until that is finished
if (_usePara) then
{
	waitUntil {
		sleep 1;
		((((leader _groupHunt) distance2D _secondPos) < 300) OR (({alive _x} count units _groupHunt) == 0))
	};
}
else
{
	{
		_x params ["_unit"];

		if ((vehicle _unit) != _unit) then
		{
			_vehicles pushBackUnique (vehicle _unit);
		};
	} forEach (units _groupHunt);
};

// If the HunterKiller team died during insertion, exit the function
if (({alive _x} count units _groupHunt) == 0) exitWith
{
	["DynaSpawn", 1, (format ["[HunterKiller] Group [%1] dead on Insertion, Exiting...", _groupHunt])] call RS_fnc_LoggingHelper;

	if (missionNamespace getVariable ["SAEF_DynaSpawn_ExtendedLogging", false]) then
	{
		["DynaSpawn", 4, (format ["[HunterKiller] <OUT> | Parameters: %1", _this])] call RS_fnc_LoggingHelper;
	};
};

private
[
	"_count",
	"_limitReached",
	"_closestPlayerPos"
];

// Break-Out Variables
_count = 0;
_limitReached = false;

/* -- Long Range QRF Region -- */
private
[
	"_validCode",
	"_deleteCode"
];

_validCode = 
{
	params
	[
		"_player"
	];

	private
	[
		"_spotted",
		"_isUnitOrLandVehicle"
	];

	// Check if the enemy knows about this unit
	_spotted = ((_enemySide knowsAbout _player) >= 0.1);
	
	// If they don't know about the unit, check to see if that unit is blacklisted
	if !(_spotted) then
	{
		// If they aren't blacklisted set the spotted flag to true
		_spotted = !(_player getVariable ["DS_HunterKillerBlacklisted", false]);
	};

	// They are on foot or in a land vehicle
	_isUnitOrLandVehicle = ((typeOf (vehicle _player)) isKindOf ["LandVehicle", configFile >> "CfgVehicles"])
		|| ((typeOf (vehicle _player)) isKindOf ["Man", configFile >> "CfgVehicles"]);

	// Return whether or not they've been spotted and whether or not they're in the right vehicle type
	(_spotted && _isUnitOrLandVehicle)
};

_deleteCode =
{
	_x params ["_unit"];

	if ((vehicle _unit) != _unit) then
	{
		deleteVehicle (vehicle _unit);
	};

	deleteVehicle _unit;
};

// Get the nearestPlayer within 4000m (our max search distance)
_closestPlayerPos = [(getPos (leader _groupHunt)), 4000, _validCode] call RS_PLYR_fnc_GetClosestPlayer;

// If there are no players within the given AO, delete the hunter killers
if (_closestPlayerPos isEqualTo [0,0,0]) exitWith
{
	["DynaSpawn", 1, (format ["[HunterKiller] Found no Close Player, deleting group %1", _groupHunt])] call RS_fnc_LoggingHelper;
	
	_deleteCode forEach (units _groupHunt);

	if (missionNamespace getVariable ["SAEF_DynaSpawn_ExtendedLogging", false]) then
	{
		["DynaSpawn", 4, (format ["[HunterKiller] <OUT> | Parameters: %1", _this])] call RS_fnc_LoggingHelper;
	};
};

// This is the threshold for allowing the player to escape the Hunter Killers
if (_areaOfOperation <= 1000) then
{
	// Wait until the AI has reached the first found player position
	waitUntil {
		sleep 5;
		(((leader _groupHunt) distance2D _closestPlayerPos) < (_areaOfOperation - 50))
	};
};
/* -- End of Long Range QRF Region -- */

/*	While "Hunter" Group is alive, Move to the Closest Player	*/
while {({alive _x} count units _groupHunt) > 0} do
{
	_groupHunt setVariable ["RS_DS_HunterKiller_Active", true, true];
	_closestPlayerPos = [(getPos (leader _groupHunt)), _areaOfOperation, _validCode] call RS_PLYR_fnc_GetClosestPlayer;
	
	if (missionNamespace getVariable ["SAEF_DynaSpawn_ExtendedLogging", false]) then
	{
		["DynaSpawn", 4, (format ["[HunterKiller] Closest Player: %2", _closestPlayerPos])] call RS_fnc_LoggingHelper;
	};

	// If no player position was found, increment the count
	if (_closestPlayerPos isEqualTo [0,0,0]) then
	{
		_count = _count + 1;
	}
	else
	{
		// Modify the position slightly if the player is in a building and the hunters are infantry
		if ((typeOf (vehicle (leader _groupHunt))) isKindOf ["Man", configFile >> "CfgVehicles"]) then
		{
			_closestPlayerPos = [_closestPlayerPos] call RS_DS_fnc_GetClosePositionInBuilding;
		};

		// Tell the group to move
		_groupHunt move _closestPlayerPos;

		// Reset the count
		_count = 0;
	};

	// Reset
	sleep 30;
	
	if (_count >= 10) exitWith
	{
		_limitReached = true;
	};
};

// If none of the units are alive
if (({alive _x} count units _groupHunt) == 0) then
{
	// If this group had vehicles then we need to drop the fuel of those vehicles to 1%
	{
		_x params ["_vehicle"];

		if (alive _vehicle) then
		{
			_vehicle setFuel 0.01;
			_vehicle setVehicleAmmo 0.1;
		};
	} forEach _vehicles;
}
else
{
	// Clean-Up
	if (_limitReached) then
	{
		_count = 0;
		
		// Wait Until there are no players around so we can delete the Hunter Killers
		waitUntil {
			sleep 10;
			_count = _count + 1;
			(([0,0,0] isEqualTo ([getPos (leader _groupHunt), 1000] call RS_PLYR_fnc_GetClosestPlayer)) || (_count == 10))
		};
		
		// Delete the group
		["DynaSpawn", 2, (format ["[HunterKiller] Found no Close Player within timed limit, deleting group %1", _groupHunt])] call RS_fnc_LoggingHelper;
		
		_deleteCode forEach units _groupHunt;
	};
};

if (missionNamespace getVariable ["SAEF_DynaSpawn_ExtendedLogging", false]) then
{
	["DynaSpawn", 4, (format ["[HunterKiller] <OUT> | Parameters: %1", _this])] call RS_fnc_LoggingHelper;
};

/*
	END
*/