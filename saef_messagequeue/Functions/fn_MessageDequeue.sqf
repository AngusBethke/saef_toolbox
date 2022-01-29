/**
	@namespace RS_MQ
	@class MessageQueue
	@method RS_MQ_fnc_MessageDequeue
	@file fn_MessageDequeue.sqf
	@summary Removes a message from the given queue

	@param string _messageId
	@param array _params
	@param string _script
	@param string _queueName
	@param any _validation

	@todo _params not used
	@todo _validation not used

**/

/*
	fn_MessageDequeue.sqf
	Description: Removes a message from the given queue
	Author: Angus Bethke a.k.a. Rabid Squirrel
*/

params
[
	"_messageId"
	,"_params"
	,"_script"
	,"_queueName"
	,"_validation"
];

private
[
	"_messages"
	,"_logName"
];

_messages = missionNamespace getVariable [_queueName, []];
_logName = "RS Message Dequeue";

// Remove the given message from the queue
_messages = _messages - [_this];

missionNamespace setVariable [_queueName, _messages, true];

[_logName, 4, (format ["Message [%2: %3] removed from queue [%1]", _queueName, _messageId, _script])] call RS_fnc_LoggingHelper;

/*
	END
*/