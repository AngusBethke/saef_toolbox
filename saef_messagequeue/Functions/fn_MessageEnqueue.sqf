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
];

private
[
	"_messages"
	,"_messageCount"
	,"_logName"
];

_messages = missionNamespace getVariable [_queueName, []];
_messageCount = missionNamespace getVariable [(format ["%_MessageCount", _queueName]), 0];
_logName = "RS Message Enqueue";

// Add a new message to the queue
_messageCount = _messageCount + 1;
_messages pushback
[
	_messageCount			// Unique message id
	,_params				// Params for the script
	,_script				// The script to execute
	,_queueName				// The name of the queue that this message is being added to
];

missionNamespace setVariable [_queueName, _messages, true];
missionNamespace setVariable [(format ["%_MessageCount", _queueName]), _messageCount, true];

[_logName, 3, (format ["Message [%2: %3] added to queue [%1]", _queueName, _messageCount, _script])] call RS_fnc_LoggingHelper;

/*
	END
*/