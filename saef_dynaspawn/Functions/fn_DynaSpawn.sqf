/*	
	fn_DynaSpawn.sqf
	Author: Angus Bethke
	Required Mod(s): CBA
	Description: 
		This is a function built for making AI spawns as simple as possible, also handles basic waypoint creation with some added functionality.								
*/

// Input parameters
params
[
	["_spawnPos", "", ["", []], [2, 3]],			// Passed Spawn Position, can be a Marker or a Position Array
	["_type", "", [""]],                			// Type should be, Format: "PAT", "DEF", "CA", "HK", "NON" or "GAR"
	["_faction", "", ["", []]],             		// Faction should be a Custom Unit Array or Group Name, or Vehicle
	["_facSide", EAST, [EAST]],             		// Side of the Units you are spawning, Format: WEST, EAST, or INDEPENDENT
	["_areaOfOperation", 50, [0]],     				// Define the Area in which the AI Defend or Garrison. Integer (Max) 4000, (Min) 5
	["_secondPos", "", ["", []], [2, 3]],           // Passed Secondary Position (Used by Counter Attack or Garrison), can be a Marker or a Position Array
	["_remWeapAttach", false, [false]],       		// Boolean Value Removes WeaponAttachments from spawned unit's weapons, Format: true or false
	["_paraSpawn", [], [[]]],           			// Array used for para spawns	
	["_group", grpNull, [grpNull]],                	// (Optional) You can pass the group in for better function performance
	["_giveHandle", false, [false]]					// (Optional) Request that the spawner script handle be passed back - will not have any effect in a "scheduled" environment
];

// Log incoming
["DynaSpawn", 4, (format ["<IN> | Parameters: %1", _this])] call RS_fnc_LoggingHelper;

// Private Variables
private 
[	
	"_usePara",
	"_validationOutcome",
	"_valid",
	"_vArray",
	"_azi",
	"_unitType",
	"_script"
];

// Paradrop Boolean
_usePara = false;
if (!(_paraSpawn isEqualTo [])) then
{
	_usePara = true;
};

// Run validation
_validationOutcome = [_spawnPos, _type, _faction, _facSide, _areaOfOperation] call RS_DS_fnc_DynaSpawnValidation;
_valid = (_validationOutcome select 0);
_vArray = (_validationOutcome select 1);

// If validation fails, exit out
if (!_valid) exitWith
{
	["DynaSpawn", 4, (format ["<OUT> | Parameters: %2", _this])] call RS_fnc_LoggingHelper;
	
	// Return null group for failure
	grpNull
};

// If validation succeeds, load the variables
_spawnPos = _vArray select 0;
_azi = _vArray select 1; 
_type = _vArray select 2; 
_secondPos = _vArray select 3; 
_faction = _vArray select 4; 
_unitType = _vArray select 5; 
_facSide = _vArray select 6; 
_areaOfOperation = _vArray select 7;

// Create our group
if (isNull _group) then 
{
	_group = createGroup [_facSide, true];
};

// Conduct the spawns
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

["DynaSpawn", 4, (format ["<OUT> | Group: %1, Parameters: %2", _group, _this])] call RS_fnc_LoggingHelper;

if (!canSuspend && _giveHandle) exitWith 
{
	// Returns the group and script handle
	[_group, _script]
};

// Returns only the group
_group

/*
	END
*/