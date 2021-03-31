/*
	fn_MessageHandler.sqf

	Description: 
		Handles message execution

	Author: 
		Angus Bethke a.k.a. Rabid Squirrel

	How to Call:
		[
			_queueName,
			_timeout (optional)
		] spawn RS_MQ_fnc_MessageHandler;
*/

params
[
	"_queueName",
	["_timeout", 5]
];

private
[
	"_logName"
	,"_queueProcessVariable"
	,"_pollTime"
	,"_messages"
];

_logName = "RS Message Handler";
_queueProcessVariable = format ["%1_MessageHandler_Run", _queueName];

if (missionNamespace getVariable [_queueProcessVariable, false]) exitWith
{
	[_logName, 1, (format ["Message Handler already running for queue [%1], to stop processing toggle variable [%2] to false.", _queueName, _queueProcessVariable])] call RS_fnc_LoggingHelper;
};

missionNamespace setVariable [_queueProcessVariable, true, true];
[_logName, 0, (format ["Starting Message Handler for queue [%1], to stop processing toggle variable [%2] to false.", _queueName, _queueProcessVariable])] call RS_fnc_LoggingHelper;

_pollTime = 1;
while {missionNamespace getVariable [_queueProcessVariable, false]} do
{
	// Fetch our Messages from the queue
	_messages = missionNamespace getVariable [_queueName, []];
	
	if (!(_messages isEqualTo [])) then
	{
		// Process our messages
		{
			_x params 
			[
				"_messageId"
				,"_params"
				,"_script"
				,"_queueName"
				,"_validation"
			];

			private
			[
				"_handle"
			];
			
			_handle = _x spawn RS_MQ_fnc_MessageExecuter;

			// Check for message completion
			if (_timeout > 0) then
			{
				private
				[
					"_control"
				];

				_control = 0;
				waitUntil {
					sleep 0.1;
					_control = _control + 1;
					((scriptDone _handle) || (isNull _handle) || (_control == (_timeout * 10)));
				};

				// If message takes longer than the specified timeout log a warning
				if (_control == (_timeout * 10)) then
				{
					[_logName, 2, (format ["Message Handler processing queue [%1] for message [%2] took longer than [%3] seconds, check later logs for message completion.", _queueName, _messageId, _timeout])] call RS_fnc_LoggingHelper;
				};
			}
			else
			{
				sleep 0.1;
			};
		} forEach _messages;
	}
	else
	{
		if (_pollTime >= 30) then
		{
			_pollTime = 0;
			[_logName, 3, (format ["Message Handler for queue [%1] polling for messages...", _queueName])] call RS_fnc_LoggingHelper;
		};
	};

	_pollTime = _pollTime + 1;
	sleep 1;
};

[_logName, 3, (format ["Ending Message Handler for queue [%1]", _queueName])] call RS_fnc_LoggingHelper;

/*
	END
*/