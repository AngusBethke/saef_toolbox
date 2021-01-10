/*
	fn_MessageExecuter.sqf
	Description: Executes all given messages
	Author: Angus Bethke a.k.a. Rabid Squirrel
*/

params
[
	"_messageId"
	,"_params"
	,"_script"
	,"_queueName"
];

private
[
	"_logName"
	,"_handle"
];

// We are starting the processing
_logName = "RS Message Executer";
[_logName, 3, (format ["Message Handler processing queue [%1] for message [%2: %3] starting...", _queueName, _messageId, _script])] call RS_fnc_LoggingHelper;

// Remove the message from the queue (this is so that we don't process the same message twice)
_this call RS_MQ_fnc_MessageDequeue;

// Run the message
_handle = _params execVM _script;

// Wait for message completion
waitUntil {
	sleep 0.1;
	((scriptDone _handle) || (isNull _handle))
};

[_logName, 3, (format ["Message Handler processing queue [%1] for message [%2: %3] complete...", _queueName, _messageId, _script])] call RS_fnc_LoggingHelper;

/*
	END
*/