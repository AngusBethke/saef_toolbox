/* 
	fn_Persistence.sqf

	Description: 
		Handles distance based persistence for all spawner types. It uses recursion to call it's handed script if needed.

	How to Call: 
		[
			"_params"						// Array: Parameters for function execution
			,"_groups"						// Array: Groups for cleanup
			,"_script"						// String: Script/Function to be re-queued
			,"_variable"					// String: Variable to evaluate after checks complete to determine whether or not to re-queue the message
			,"_range"						// Integer: How far the players need to be from the area in order for persistence to activate
			,"_position"					// Array: Position array to evaluate for distance from the area
			,"_playerValidation"			// (Optional) Code Block: Condition passed to GetClosestPlayer to evaluate players for inclusion
			,"_queueValidation"				// (Optional) Code Block: Condition passed to the Message Queue to evaluate message for processing
		] spawn RS_AS_fnc_Persistence;
*/

params
[
	"_params"
	,"_groups"
	,"_script"
	,"_variable"
	,"_range"
	,"_position"
	,["_playerValidation", {true}]
	,["_queueValidation", {true}]
];

// Wait until the group is dead
_j = 1;
waitUntil {
	// Suspend
	sleep 10;
	
	// Log every 3 minutes
	if (_j == 36) then
	{
		_j = 1;
		[_script, 3, "Polling | Handling Group Persistence"] call RS_fnc_LoggingHelper;
	};
	_j = _j + 1;
	
	// Test if player is close by
	_closePlayer = [_position, _range, _playerValidation] call RS_PLYR_fnc_GetClosestPlayer;
	
	// If there is no player close by, then we exit out
	(_closePlayer isEqualTo [0,0,0])
};

// Once the player is out of range we need to clean up the group
{
	_group = _x;
	
	// We don't need to do this if the group is null, or they are actively hunting
	if ((_group != grpNull) && !(_group getVariable ["RS_DS_HunterKiller_Active", false])) then
	{
		{
			if ((vehicle _x) != _x) then
			{
				if ((vehicle _x) getVariable ["SAEF_Persistence_Cleanup_Whitelist", false]) then
				{
					deleteVehicle (vehicle _x);
				};
				
				deleteVehicle _x;
			}
			else
			{
				deleteVehicle _x;
			};
		} forEach (units _group);
	};
} forEach _groups;

// If our variable for running these spawns is still active, then we call the script again
if (missionNamespace getVariable [_variable, false]) then
{
	["SAEF_SpawnerQueue", _params, _script, _queueValidation] call RS_MQ_fnc_MessageEnqueue;
};

/*
	END
*/