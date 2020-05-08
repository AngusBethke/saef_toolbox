/*	
	Function: fn_DynaSpawn.sqf
	Author: Angus Bethke
	Version: Beta 0.95
	Required Mod(s): CBA
	Description: This is a function built for making AI spawns as simple as possible, also handles basic waypoint creation with some added functionality.
	Last Modified: 01-11-2019								
*/

//Private Variables
private 
[	
	"_spawnPos",
	"_type",
	"_faction",
	"_facSide",
	"_areaOfOperation",
	"_secondPos",
	"_remWeapAttach",
	"_debug",
	"_posValid",
	"_spValid",
	"_azi",
	"_grpValid",
	"_grValid",
	"_unitType",
	"_group",
	"_script"
];

/* Grab Variables from the Declaration */
_spawnPos = _this select 0;      		// Passed Spawn Position, can be a Marker or a Position Array
_type = _this select 1;					// Type should be, Format: "PAT", "DEF", "CA", "HK", "NON" or "GAR"
_faction = _this select 2;				// Faction should be a Custom Unit Array or Group Name, or Vehicle
_facSide = _this select 3;				// Side of the Units you are spawning, Format: WEST, EAST, or INDEPENDENT
_areaOfOperation = _this select 4;		// Define the Area in which the AI Defend or Garrison. Integer (Max) 4000, (Min) 5
_secondPos = _this select 5;			// Passed Secondary Position (Used by Counter Attack or Garrison), can be a Marker or a Position Array
_remWeapAttach = _this select 6;        // Boolean Value Removes WeaponAttachments from spawned unit's weapons, Format: true or false
_paraSpawn = _this select 7;			// Array used for para spawns	
_group = _this select 8;				// (Optional) You can pass the group in for better function performance

/* Variables for later use */
_usePara = false;

if (!isNil "_paraSpawn") then
{
	if (!(_paraSpawn isEqualTo [])) then
	{
		_usePara = true;
	};
};

/* Set to true for Debug */
_debug = missionNamespace getVariable "RS_DS_Debug";

/* Check if the SpawnPos is Valid */
_posValid = [_spawnPos] call RS_DS_fnc_PositionValidation;
_spValid = (_posValid select 0);
_spawnPos = (_posValid select 1);
_azi = (_posValid select 2);

if (!_spValid) exitWith
{
	diag_log format ["%1 [ERROR] Spawn Position for DynaSpawn is not Valid", (_debug select 1)];
};

/* Check to see if Type is Valid */
_type = toUpper(_type);

if (_type != "PAT" AND _type != "DEF" AND _type != "CA" AND _type != "HK" AND _type != "GAR" AND _type != "NON") then
{
	_type = "NON";
	diag_log format ["%1 [WARNING] Type passed to DynaSpawn is not Valid, Defaulting to %2", (_debug select 1), _type];
};

/* If Type is Valid then use the Type to Check the SecondPos */
if (_type == "CA" OR _type == "GAR" OR (_type == "HK" AND _usePara)) then
{
	_posValid = [_secondPos] call RS_DS_fnc_PositionValidation;
	_spValid = (_posValid select 0);
	_secondPos = (_posValid select 1);

	if (!_spValid) exitWith
	{
		diag_log format ["%1 [ERROR] Second Position for DynaSpawn is not Valid", (_debug select 1)];
	};
};

/* Check if the Unit/Group/Vehicle Passed is Valid */
_grpValid = [_faction] call RS_DS_fnc_UnitValidation;
_grValid = (_grpValid select 0);
_unitType = (_grpValid select 1);

if (!_grValid) exitWith
{
	diag_log format ["%1 [ERROR] Units passed to DynaSpawn are not Valid", (_debug select 1)];
};

/*	Faction Side Validation */
if (_facSide != WEST AND _facSide != EAST AND _facSide != INDEPENDENT AND _facSide != CIVILIAN) then
{
	_facSide = EAST;
	diag_log format ["%1 [WARNING] Side passed to DynaSpawn is not Valid, Defaulting to %2", (_debug select 1), _facSide];
};

/* Area of Operation Validation */
if (_areaOfOperation < 1 OR _areaOfOperation > 4000) then
{
	_areaOfOperation = 50;
	diag_log format ["%1 [WARNING] AO Size passed to DynaSpawn is not Valid, Defaulting to %2", (_debug select 1), _areaOfOperation];
};

/* Returns Declared Variables if Debug is Enabled */
if (_debug select 0) then
{
	diag_log format ["%1 [INFO] Variables Passed to DynaSpawn: Spawn Pos: %2, Type: %3, Faction Side: %4, AO Size: %5, Second Pos: %6, Remove Weapon Attachements: %7", 
						(_debug select 1),
						_spawnPos, 
						_type, 
						_facSide, 
						_areaOfOperation, 
						_secondPos, 
						_remWeapAttach
	];
};

if (isNil "_group") then 
{
	_group = createGroup [_facSide, true];
	_useSuspension = false;
};

/* Run the spawner */
_script = [
	_spawnPos,
	_facSide, 
	_faction, 
	_type,
	_unitType,
	_areaOfOperation, 
	_secondPos, 
	_remWeapAttach,
	_azi,
	_usePara,
	_paraSpawn,
	_group
] spawn RS_DS_fnc_SpawnerGroup;

if (canSuspend) then 
{
	waitUntil {
		sleep 1;
		((scriptDone _script) || (isNull _script))
	};
};

/* Returns: Group that was spawned, if you'd like to use it for some script */
if (_debug select 0) then
{
	diag_log format ["%1 [INFO] Spawner Completed, Group: %2 passed back", (_debug select 1), _group];
};

_group