/**
	@namespace SAEF_AS
	@class AutomatedSpawning
	@method SAEF_AS_fnc_HunterKiller
	@file fn_HunterKiller.sqf
	@summary Will create a Hunter Killer squad at the position specified based on the input parameters.

	@param pos _position						Position array, the position to spawn the group
	@param string _unitVar						Variable pointer to stored unit array
	@param string _sideVar						Variable pointer to stored unit side
	@param int _count							Number of units to spawn
	@param int _area							Size of the area we are dealing with
	@param ?code _groupCode						Code to run against the group
	@param ?string _respawnVariable				Variable that handles whether or not this group should be continuosly respawned
	@param ?string _paraVariable				Variable pointer to stored air vehicle array
	@param ?int _respawnTime					How long it takes for the group to respawn
	@param ?array _customScripts				String scripts for execution against spawned groups
	@param ?code _queueValidation				Condition passed to the Message Queue to evaluate message for processing
	@param ?string _customPositionTag			Tag to help determine the custom spawn position for the Hunter Killer group
**/
/* 
	fn_HunterKiller.sqf

	Description: 
		Will create a Hunter Killer squad at the position specified based on the input parameters

	How to Call: 
		[
			"_position"						// Array: Position array, the position to spawn the group
			,"_unitVar"						// String: Variable pointer to stored unit array
			,"_sideVar"						// String: Variable pointer to stored unit side
			,"_count"						// Integer: Number of units to spawn
			,"_area"						// Integer: Size of the area we are dealing with
			,"_groupCode"					// (Optional) Code Block: Code to run against the group
			,"_respawnVariable"				// (Optional) String: Variable that handles whether or not this group should be continuosly respawned
			,"_paraVariable"				// (Optional) String: Variable pointer to stored air vehicle array
			,"_respawnTime"					// (Optional) Integer: How long it takes for the group to respawn
			,"_customScripts				// (Optional) Array: String scripts for execution against spawned groups
			,"_queueValidation"				// (Optional) Code Block: Condition passed to the Message Queue to evaluate message for processing
			,"_customPositionTag"			// (Optional) String: Tag to help determine the custom spawn position for the Hunter Killer group
		] spawn SAEF_AS_fnc_HunterKiller;
*/

params 
[
	"_position"
	,"_unitVar"
	,"_sideVar"
	,"_count"
	,"_area"
	,["_groupCode", {}]
	,["_respawnVariable", ""]
	,["_paraVariable", ""]
	,["_respawnTime", 120]
	,["_customScripts", []]
	,["_queueValidation", {true}]
	,["_customPositionTag", ""]
	,["_secondPos", []]
];

private
[
	"_scriptTag",
	"_units",
	"_unitArr",
	"_side"
];

_scriptTag = "SAEF_AS_fnc_HunterKiller";
[_scriptTag, 3, "<IN>"] call RS_fnc_LoggingHelper;

// Mission variables used to derive information for spawning
_units = [];
_unitArr = missionNamespace getVariable [_unitVar, []];
_side = missionNamespace getVariable [_sideVar, "EMPTY"];

// Error Handling - If variables are unset we can get this to retry itself, because those can be fixed at runtime
if (_unitArr isEqualTo []) exitWith
{
	[_scriptTag, 1, (format ["No value found in variable [%1] re-queueing in 60 seconds...", _unitVar])] call RS_fnc_LoggingHelper;

	// AI Re-balance
	[clientOwner, _count] remoteExecCall ["SAEF_AS_fnc_UpdateAiCount_Remote", 2, false];

	sleep 60;

	["SAEF_SpawnerQueue", _this, "SAEF_AS_fnc_HunterKiller", _queueValidation] call RS_MQ_fnc_MessageEnqueue;
};

if (toUpper(format ["%1", _side]) == "EMPTY") exitWith
{
	[_scriptTag, 1, (format ["No value found in variable [%1] re-queueing in 60 seconds...", _sideVar])] call RS_fnc_LoggingHelper;

	// AI Re-balance
	[clientOwner, _count] remoteExecCall ["SAEF_AS_fnc_UpdateAiCount_Remote", 2, false];

	sleep 60;

	["SAEF_SpawnerQueue", _this, "SAEF_AS_fnc_HunterKiller", _queueValidation] call RS_MQ_fnc_MessageEnqueue;
};

// Custom position configuration
private
[
	"_customPositionError"
];

_customPositionError = false;
if (_customPositionTag != "") then
{
	private
	[
		"_marker"
	];

	_marker = [_customPositionTag, 2000] call RS_PLYR_fnc_GetMarkerNearPlayer;

	// If we've found a marker then we need to adjust the position to use the custom position instead
	if (_marker != "") then
	{
		_position = (markerPos _marker);
		_position pushBack (markerDir _marker);
	}
	else
	{
		_customPositionError = true;
	};
};

if (_customPositionError) exitWith
{
	[_scriptTag, 1, (format ["Custom position requested, but no marker found for tag [%1] re-queueing in 60 seconds...", _customPositionTag])] call RS_fnc_LoggingHelper;

	// AI Re-balance
	[clientOwner, _count] remoteExecCall ["SAEF_AS_fnc_UpdateAiCount_Remote", 2, false];

	sleep 60;

	["SAEF_SpawnerQueue", _this, "SAEF_AS_fnc_HunterKiller", _queueValidation] call RS_MQ_fnc_MessageEnqueue;
};

private
[
	"_paraSpawn",
	"_paraError"
];

// Setup the para spawn parameters if any
_paraSpawn = [];
_paraError = false;
if (_paraVariable != "") then
{
	private
	[
		"_paraArray"
	];

	_paraArray = missionNamespace getVariable [_paraVariable, []];

	if (!(_paraArray isEqualTo [])) then
	{
		_paraSpawn = [(selectRandom _paraArray), [], 0];
	}
	else
	{
		_paraError = true;
	};
};

// Error Handling - If variables are unset we can get this to retry itself, because those can be fixed at runtime
if (_paraError) exitWith
{
	[_scriptTag, 1, (format ["No value found in variable [%1] re-queueing in 60 seconds...", _paraVariable])] call RS_fnc_LoggingHelper;

	// AI Re-balance
	[clientOwner, _count] remoteExecCall ["SAEF_AS_fnc_UpdateAiCount_Remote", 2, false];

	sleep 60;

	["SAEF_SpawnerQueue", _this, "SAEF_AS_fnc_HunterKiller", _queueValidation] call RS_MQ_fnc_MessageEnqueue;
};

// Units that will be spawned using DynaSpawn
for "_i" from 0 to (_count - 1) do
{
	_units = _units + [selectRandom _unitArr];
};

// If there is only one unit we need to yank this out of the array
if ((count _units) == 1) then
{
	_units = (_units select 0);
};

private
[
	"_group",
	"_script",
	"_params"
];

_group = createGroup [_side, true];
_params = [_position, "HK", _units, _side, _area, _position, false, _paraSpawn, _group];

if (!(_secondPos isEqualTo [])) then
{
	_params = [_position, "HK", _units, _side, _area, _secondPos, false, _paraSpawn, _group];
};

// Spawns the Group
_script = _params spawn RS_DS_fnc_DynaSpawn;
	
waitUntil {
	sleep 0.1;
	
	// Check if the script is finished or if it is null
	((scriptDone _script) || (isNull _script))
};

// AI Re-balance
[clientOwner, _count] remoteExecCall ["SAEF_AS_fnc_UpdateAiCount_Remote", 2, false];

// Group Specific Settings
_groupCode forEach units _group;

// Run custom scripts against the group
{
	[_group] execVM _x;
} forEach _customScripts;

// Respawn the group if the variable is still set
if (_respawnVariable != "") exitWith
{
	// Set up our Variable
	missionNamespace setVariable [_respawnVariable, true, true];

	[_scriptTag, 0, (format["Persisting Hunter Killer squad with variable [%1], toggle to false to end persistence.", _respawnVariable])] call RS_fnc_LoggingHelper;
	
	[_this, _group, "SAEF_AS_fnc_HunterKiller", _respawnVariable, _respawnTime, _queueValidation] spawn SAEF_AS_fnc_Recursive;

	[_scriptTag, 3, "<OUT> | Recursing..."] call RS_fnc_LoggingHelper;
};

[_scriptTag, 3, "<OUT>"] call RS_fnc_LoggingHelper;

/*
	END
*/