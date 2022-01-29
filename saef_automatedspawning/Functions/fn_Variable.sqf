/**
	@namespace SAEF_AS
	@class AutomatedSpawning
	@method SAEF_AS_fnc_Variable
	@file fn_Variable.sqf
	@summary Holds spawn of certain units until a variable is set.

	@param array _params Parameters for function execution
	@param string _script Script/Function to be re-queued
	@param string _variable Variable to evaluate for when to re-queue the message
	@param ?code _queueValidation Condition passed to the Message Queue to evaluate message for processing
**/
/*
	fn_Variable.sqf
	
	Description: 
		Holds spawn of certain units until a variable is set.

	How to Call: 
		[
			"_params"					// Array: Parameters for function execution
			,"_script"					// String: Script/Function to be re-queued
			,"_variable"				// String: Variable to evaluate for when to re-queue the message
			,"_queueValidation"			// (Optional) Code Block: Condition passed to the Message Queue to evaluate message for processing
		] spawn RS_AS_fnc_Variable;
*/

params 
[
	"_params"
	,"_script"
	,"_variable"
	,["_queueValidation", {true}]
];

[_script, 3, (format ["Starting wait for Variable [%1]", _variable])] call RS_fnc_LoggingHelper;

_j = 1;
waitUntil {
	// Suspend
	sleep 5;
	
	// Log every 3 minutes
	if (_j == 36) then
	{
		_j = 1;
		[_script, 3, (format ["Polling | Waiting for Variable [%1]", _variable])] call RS_fnc_LoggingHelper;
	};
	_j = _j + 1;
	
	// Test if variable is set
	(missionNamespace getVariable [_variable, false])
};

[_script, 3, (format ["Wait for Variable [%1] Finished", _variable])] call RS_fnc_LoggingHelper;

// Add this back into the spawn queue - this time without variable spawn set
["SAEF_SpawnerQueue", _params, _script, _queueValidation] call RS_MQ_fnc_MessageEnqueue;

/*
	END
*/