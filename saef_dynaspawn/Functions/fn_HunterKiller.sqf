/*	
	Function: fn_HunterKiller.sqf
	Author: Angus Bethke
	Required Functions: fn_DynaSpawn, fn_GetClosestPlayer
	Description: Uses a passed group and area of operation to create waypoints for AI that continously hunt the nearest player to them.
	Last Modified: 05-03-2019 		
*/

private
[
	"_groupHunt",
	"_areaOfOperation",
	"_debug",
	"_count",
	"_limitReached",
	"_huntPlayerArray",
	"_closestPlayerPos"
];

/*	Declarations	*/
_groupHunt = _this select 0;
_areaOfOperation = _this select 1;
_usePara = _this select 2;
_secondPos = _this select 3;
_enemySide = side _groupHunt;
_debug = missionNamespace getVariable "RS_DS_Debug";

if ((_debug select 0)) then
{
	diag_log format ["%1 [HunterKiller] Parameters: %2", (_debug select 1), _this];
};

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
};

// If the HunterKiller team died during insertion, exit the function
if (({alive _x} count units _groupHunt) == 0) exitWith
{
	diag_log format ["%1 [INFO] Hunter Killer Group %2, Dead on Insertion, Exiting!", (_debug select 1), _groupHunt];
};

// Break-Out Variables
_count = 0;
_limitReached = false;

/* -- Long Range QRF Region -- */
// Get the nearestPlayer within 4000m (our max search distance)
_huntPlayerArray = (leader _groupHunt) nearEntities [["Man", "LandVehicle"], 4000];
_closestPlayerPos = getPos (leader _groupHunt);

for "_i" from 0 to ((count _huntPlayerArray) - 1) do
{
	// Check if the enemy knows about this unit
	_spotted = ((_enemySide knowsAbout (_huntPlayerArray select _i)) >= 0.1);
	
	// If they don't know about the unit, check to see if that unit is blacklisted
	if !(_spotted) then
	{
		// If they aren't blacklisted set the spotted flag to true
		_spotted = !((_huntPlayerArray select _i) getVariable ["DS_HunterKillerBlacklisted", false]);
	};
	
	// Make Sure that the AI don't target the headless client
	if ((isPlayer (_huntPlayerArray select _i)) 
		&& (name (_huntPlayerArray select _i) != "headlessclient")
		&& (_spotted)) exitWith
	{
		_closestPlayerPos = getPos (_huntPlayerArray select _i);
	};
};

// If there are no players within the given AO, delete the hunter killers
if (_closestPlayerPos isEqualTo (getPos (leader _groupHunt))) exitWith
{
	diag_log format ["%1 [WARNING] Hunter Killer Found no Close Player, deleting group %2", (_debug select 1), _groupHunt];
	{
		deleteVehicle _x;
	} forEach units _groupHunt;
};

// This is the threshold for allowing the player to escape the Hunter Killers
if (_areaOfOperation <= 1000) then
{
	// Wait until the AI has reach the first found player position
	waitUntil {
		sleep 5;
		(((leader _groupHunt) distance2D _closestPlayerPos) < (_areaOfOperation - 50))
	};
};
/* -- End of Long Range QRF Region -- */

/*	While "Hunter" Group is alive, Move to the Closest Player	*/
while {({alive _x} count units _groupHunt) > 0} do
{
	_huntPlayerArray = (leader _groupHunt) nearEntities [["Man", "LandVehicle"], _areaOfOperation];
	_closestPlayerPos = getPos (leader _groupHunt);
	
	for "_i" from 0 to ((count _huntPlayerArray) - 1) do
	{
		// Check if the enemy knows about this unit
		_spotted = ((_enemySide knowsAbout (_huntPlayerArray select _i)) >= 0.1);
		
		// If they don't know about the unit, check to see if that unit is blacklisted
		if !(_spotted) then
		{
			// If they aren't blacklisted set the spotted flag to true
			_spotted = !((_huntPlayerArray select _i) getVariable ["DS_HunterKillerBlacklisted", false]);
		};
	
		// Make Sure that the AI don't target the headless client
		if ((isPlayer (_huntPlayerArray select _i)) 
			&& (name (_huntPlayerArray select _i) != "headlessclient")
			&& (_spotted)) exitWith
		{
			_closestPlayerPos = getPos (_huntPlayerArray select _i);
		};
	};
	
	// If no player position was found, increment the count
	if (_closestPlayerPos isEqualTo (getPos (leader _groupHunt))) then
	{
		_count = _count + 1;
	};
	
	if ((_debug select 0)) then
	{
		diag_log format ["%1 Hunter Killer Closest Player: %2", (_debug select 1), _closestPlayerPos];
	};
	
	_groupHunt move _closestPlayerPos;
	
	// Reset
	sleep 30;
	
	if (_count >= 10) exitWith
	{
		_limitReached = true;
	};
};

// Clean-Up
if (_limitReached) then
{
	_count = 0;
	
	// Wait Until there are no players around so we can delete the Hunter Killers
	waitUntil {
		sleep 10;
		_count = _count + 1;
		(([0,0,0] isEqualTo ([getPos (leader _groupHunt), 1000] call RS_PLYR_fnc_GetClosestPlayer)) OR (_count == 10))
	};
	
	// Delete the group
	diag_log format ["%1 [INFO] Hunter Killer Found no Close Player within timed limit, deleting group %2", (_debug select 1), _groupHunt];
	{
		deleteVehicle _x;
	} forEach units _groupHunt;
};

//Returns: Nothing