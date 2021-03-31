/* 	
	fn_Recursive.sqf

	Description: 
		Handles persistence for all spawner types. It uses recursion to call it's handed script if needed.

	How to Call: 
		[
			"_params"						// Array: Parameters for function execution
			,"_group"						// Group: Group to watch
			,"_script"						// String: Script/Function to be re-queued
			,"_variable"					// String: Variable to evaluate after checks complete to determine whether or not to re-queue the message
			,"_evalTime"					// (Optional) Integer: How long to wait until re-queueing the message
			,"_queueValidation"				// (Optional) Code Block: Condition passed to the Message Queue to evaluate message for processing
		] spawn RS_AS_fnc_Recursive;
*/

params
[
	"_params"
	,"_group"
	,"_script"
	,"_variable"
	,["_evalTime", 120]
	,["_queueValidation", {true}]
];

// Wait until the group is dead
_j = 1;
waitUntil {
	sleep 10;
	
	// Log every 3 minutes
	if (_j == 18) then
	{
		_j = 1;
		[_script, 3, (format ["Polling | Waiting for group [%1] to die", _group])] call RS_fnc_LoggingHelper;
	};
	_j = _j + 1;
	
	// If all the units in the group are dead
	(({alive _x} count units _group) == 0)
};

// How long we wait until validating whether or not the group needs to be re-spawned
sleep _evalTime;

// If our variable for running these spawns is still active, then we call the script again
if (missionNamespace getVariable [_variable, false]) then
{
	["SAEF_SpawnerQueue", _params, _script, _queueValidation] call RS_MQ_fnc_MessageEnqueue;
};

/*
	END
*/