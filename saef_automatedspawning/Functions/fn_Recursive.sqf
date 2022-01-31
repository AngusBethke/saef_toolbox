/**
	@namespace SAEF_AS
	@class AutomatedSpawning
	@method SAEF_AS_fnc_Recursive
	@file fn_Recursive.sqf
	@summary Handles persistence for all spawner types. It uses recursion to call it's handed script if needed.

	@param array _params					Parameters for function execution
	@param string _script					Script/Function to be re-queued
	@param int _range						How far the players need to be from the area in order for persistence to activate
	@param array _position					Position array to evaluate for distance from the area
	@param ?int _evalTime					How long to wait until re-queueing the message
	@param ?code _queueValidation			Condition passed to the Message Queue to evaluate message for processing

	@todo Description says `spawn RS_AS...` when namespace is `SAEF_AS`
**/
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