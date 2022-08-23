/**
	@namespace RS_MQ
	@class MessageQueue
	@method RS_MQ_fnc_MessageExecuter
	@file fn_MessageExecuter.sqf
	@summary Executes all given messages

	@param string _messageId
	@param array _params
	@param string _script
	@param string _queueName
	@param bool _validation

**/

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
	,"_validation"
	,["_validationRequeueDelay", 60]
];

private
[
	"_logName"
	,"_condition"
	,"_handle"
	,"_code"
];

// We are starting the processing
_logName = "RS Message Executer";
[_logName, 4, (format ["Message Handler processing queue [%1] for message [%2: %3] starting...", _queueName, _messageId, _script])] call RS_fnc_LoggingHelper;

// Evaluate our custom validation condition
_condition = _params call _validation;

// Remove the message from the queue (this is so that we don't process the same message twice)
_this call RS_MQ_fnc_MessageDequeue;

// If we pass validation, execute the script
if (_condition) then
{
	// Run the message
	if ([".SQF", toUpper(_script)] call BIS_fnc_InString) then
	{
		_handle = _params execVM _script;

		// Wait for message completion
		waitUntil {
			sleep 0.1;
			((scriptDone _handle) || (isNull _handle))
		};
	}
	else
	{
		if (!isNil _script) then
		{
			_code = (call compile _script);
			_handle = _params spawn _code;

			// Wait for message completion
			waitUntil {
				sleep 0.1;
				((scriptDone _handle) || (isNull _handle))
			};
		}
		else
		{
			[_logName, 1, (format ["Function not Found! Queue [%1] message [%2: %3] will not be processed...", _queueName, _messageId, _script])] call RS_fnc_LoggingHelper;
		};
	};

	[_logName, 4, (format ["Message Handler processing queue [%1] for message [%2: %3] complete...", _queueName, _messageId, _script])] call RS_fnc_LoggingHelper;
}
else
{
	// If validation fails, requeue the message after 60 seconds
	[_logName, 2, (format ["Message Handler processing queue [%1] for message [%2: %3] failed validation, will be added back into the queue in 60 seconds...", _queueName, _messageId, _script])] call RS_fnc_LoggingHelper;
	
	[_queueName, _params, _script, _validation] spawn {
		params
		[
			"_queueName"
			,"_params"
			,"_script"
			,"_validation"
		];

		sleep 60;
		
		[_queueName, _params, _script, _validation] call RS_MQ_fnc_MessageEnqueue;
	};
};

/*
	END
*/