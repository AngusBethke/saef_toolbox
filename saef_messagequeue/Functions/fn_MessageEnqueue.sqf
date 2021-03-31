/*
	fn_MessageEnqueue.sqf

	Description: 
		Adds a message to the given queue
	
	Author: 
		Angus Bethke a.k.a. Rabid Squirrel

	How to Call:
		[
			_queueName
			,_params
			,_script
		] call RS_MQ_fnc_MessageEnqueue;
*/

params
[
	"_queueName"
	,"_params"
	,"_script"
	,["_validation", {true}]
	,["_target", objNull]
	,["_evaluationParameterIndex", 0]
	,["_updateFunction", {}]
];

// Need to update via our update function to correctly distribute
if (_target != objNull) then
{
	[_target, (_params select _evaluationParameterIndex)] call _updateFunction;
};

private
[
	"_messages"
	,"_messageCount"
	,"_logName"
];

_messages = missionNamespace getVariable [_queueName, []];
_messageCount = missionNamespace getVariable [(format ["%1_MessageCount", _queueName]), 0];
_logName = "RS Message Enqueue";

// Add a new message to the queue
_messageCount = _messageCount + 1;
_messages pushback
[
	_messageCount			// Unique message id
	,_params				// Params for the script
	,_script				// The script to execute
	,_queueName				// The name of the queue that this message is being added to
	,_validation			// Optional: The custom validation code block that can be used to ignore processing until a condition is met
];

missionNamespace setVariable [_queueName, _messages, true];
missionNamespace setVariable [(format ["%1_MessageCount", _queueName]), _messageCount, true];

[_logName, 4, (format ["Message [%2: %3] added to queue [%1]", _queueName, _messageCount, _script])] call RS_fnc_LoggingHelper;

/*
	END
*/