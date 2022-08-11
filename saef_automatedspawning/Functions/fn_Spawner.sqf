/**
	@namespace SAEF_AS
	@class AutomatedSpawning
	@method SAEF_AS_fnc_Spawner
	@file fn_Spawner.sqf
	@summary Handles persistence for all spawner types. It uses recursion to call it's handed script if needed.

	@param string _marker"						Marker where the area is created
	@param string _type"						Type of spawn to complete
	@param string _unitVar"					Variable pointer to stored unit array
	@param string _sideVar"					Variable pointer to stored unit side
	@param int _count"							Number of units to spawn
	@param string _secondaryMarker"			Marker for secondary functions
	@param int _area"							Size of the area we are dealing with
	@param ?int _range"						Range for radius and persistence spawns
	@param ?code _groupCode"					Code to run against the group
	@param ?bool _radiusSpawn"					Whether or not to limit spawns by radius
	@param ?string _persistenceVariable		Variable for persistence handling
	@param ?code _playerValidation				Condition passed to GetClosestPlayer to evaluate players for inclusion
	@param ?arry _customScripts				String scripts for execution against spawned groups
	@param ?code _queueValidation				Condition passed to the Message Queue to evaluate message for processing

	@todo Description says `spawn RS_AS...` when namespace is `SAEF_AS`
**/
/* 
	fn_Spawner.sqf

	Description: 
		Spawns a Squad and makes them do certain things based on input.

	How to Call: 
		[
			"_marker"						// String: Marker where the area is created
			,"_type"						// String: Type of spawn to complete
			,"_unitVar"						// String: Variable pointer to stored unit array
			,"_sideVar"						// String: Variable pointer to stored unit side
			,"_count"						// Integer: Number of units to spawn
			,"_secondaryMarker"				// String: Marker for secondary functions
			,"_area"						// Integer: Size of the area we are dealing with
			,"_range"						// (Optional) Integer: Range for radius and persistence spawns
			,"_groupCode"					// (Optional) Code Block: Code to run against the group
			,"_radiusSpawn"					// (Optional) Boolean: Whether or not to limit spawns by radius
			,"_persistenceVariable			// (Optional) String: Variable for persistence handling
			,"_playerValidation				// (Optional) Code Block: Condition passed to GetClosestPlayer to evaluate players for inclusion
			,"_customScripts				// (Optional) Array: String scripts for execution against spawned groups
			,"_queueValidation				// (Optional) Code Block: Condition passed to the Message Queue to evaluate message for processing
		] spawn RS_AS_fnc_Spawner;
*/

params 
[
	"_marker"
	,"_type"
	,"_unitVar"
	,"_sideVar"
	,"_count"
	,"_secondaryMarker"
	,"_area"
	,["_range", 500]
	,["_groupCode", {}]
	,["_radiusSpawn", false]
	,["_persistenceVariable", ""]
	,["_playerValidation", {true}]
	,["_customScripts", []]
	,["_queueValidation", {true}]
	,["_useAiDirector", true]
];

private
[
	"_scriptTag"
];

_scriptTag = "SAEF_AS_fnc_Spawner";

[_scriptTag, 3, (format["<IN> [%1]", _marker])] call RS_fnc_LoggingHelper;

// Set the ai up to spawn if the players enter the area
if (_radiusSpawn) exitWith
{
	private
	[
		"_params"
	];

	// AI Re-balance
	[clientOwner, _count] remoteExecCall ["SAEF_AS_fnc_UpdateAiCount_Remote", 2, false];

	_params = _this;
	_params set [9, false];
	[_params, "SAEF_AS_fnc_Spawner", _range, (markerPos _secondaryMarker), _playerValidation, _queueValidation] spawn SAEF_AS_fnc_Radius;

	[_scriptTag, 3, (format["<OUT> [%1]", _marker])] call RS_fnc_LoggingHelper;
};

// If our variable for running these spawns is still active
if (missionNamespace getVariable [_persistenceVariable, true]) then
{
	private
	[
		"_units",
		"_unitArr",
		"_side",
		"_group",
		"_script",
		"_isVehicle"
	];

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

		["SAEF_SpawnerQueue", _this, "RS_AS_fnc_Spawner", _queueValidation] call RS_MQ_fnc_MessageEnqueue;
	};

	if (toUpper(format ["%1", _side]) == "EMPTY") exitWith
	{
		[_scriptTag, 1, (format ["No value found in variable [%1] re-queueing in 60 seconds...", _sideVar])] call RS_fnc_LoggingHelper;

		// AI Re-balance
		[clientOwner, _count] remoteExecCall ["SAEF_AS_fnc_UpdateAiCount_Remote", 2, false];

		sleep 60;

		["SAEF_SpawnerQueue", _this, "RS_AS_fnc_Spawner", _queueValidation] call RS_MQ_fnc_MessageEnqueue;
	};

	// If set, AI Director will take control of the number of AI to spawn
	if (_useAiDirector) then
	{
		_count = ["GetAiCountForArea", [_marker, _type, _count]] call SAEF_AID_fnc_Difficulty;
	};

	// Units that will be spawned using DynaSpawn
	for "_i" from 0 to (_count - 1) do
	{
		_units = _units + [selectRandom _unitArr];
	};
	
	// If there is only one unit we need to yank this out of the array
	_isVehicle = false;
	if ((count _units) == 1) then
	{
		_units = (_units select 0);
		_isVehicle = true;
	};

	// Spawns the Group
	_group = createGroup [_side, true];
	_script = [_marker, _type, _units, _side, _area, _secondaryMarker, false, [], _group] spawn RS_DS_fnc_DynaSpawn;
		
	waitUntil {
		sleep 0.1;
		
		// Check if the script is finished or if it is null
		((scriptDone _script) || (isNull _script))
	};

	// AI Re-balance
	[clientOwner, _count] remoteExecCall ["SAEF_AS_fnc_UpdateAiCount_Remote", 2, false];

	// Mark the vehicle for persistence deletion
	if (_isVehicle) then
	{
		private
		[
			"_vehicle"
		];

		_vehicle = (vehicle (leader _group));

		if (((typeOf _vehicle) == _units) && (_vehicle != (leader _group))) then
		{
			_vehicle setVariable ["SAEF_Persistence_Cleanup_Whitelist", true, true];
		};
	};

	// Group Specific Settings
	_groupCode forEach units _group;

	// Run custom scripts against the group
	{
		[_group] execVM _x;
	} forEach _customScripts;

	// Set the ai up to de-spawn if the players leave the area again
	if (_persistenceVariable != "") exitWith
	{
		private
		[
			"_params"
		];
		
		_params = _this;
		_params set [9, true];
		[_params, [_group], "SAEF_AS_fnc_Spawner", _persistenceVariable, _range, (markerPos _secondaryMarker), _playerValidation, _queueValidation] spawn SAEF_AS_fnc_Persistence;

		[_scriptTag, 3, (format["<OUT> [%1] | Persisting...", _marker])] call RS_fnc_LoggingHelper;
	};
}
else
{
	// AI Re-balance
	[clientOwner, _count] remoteExecCall ["SAEF_AS_fnc_UpdateAiCount_Remote", 2, false];
	
	[_scriptTag, 2, (format["Spawn will not occur as the area [%1] has been disabled [%2]", _persistenceVariable, _marker])] call RS_fnc_LoggingHelper;
};

[_scriptTag, 3, (format["<OUT> [%1]", _marker])] call RS_fnc_LoggingHelper;

/*
	END
*/