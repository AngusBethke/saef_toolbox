/*
	fn_MessageHandler.sqf
	Description: Handles message execution
	Author: Angus Bethke a.k.a. Rabid Squirrel
*/

private
[
	"_logLevel"
	,"_logName"
	,"_count"
	,"_messageListeners"
	,"_messages"
];

_logLevel = missionNamespace getVariable ["RS_MessageHandler_LogLevel", 2];
_logName = "RS Message Handler";

if (!isServer) exitWith
{
	if (_logLevel >= 3) then 
	{
		diag_log format ["[%1] [INFO] Message Handler may only run on the server", _logName];
	};
};

while {missionNamespace getVariable ["RS_MessageHandler_Run", true]} do
{
	// Poll for next messages
	_count = 0;
	while {!(missionNamespace getVariable ["RS_MessageHandler_Execute", false])} do 
	{
		sleep 5;
		_count = _count + 1;
		if ((_count == 6) && (_logLevel >= 3)) then 
		{
			diag_log format ["[%1] [INFO] Message Handler Polling for Message", _logName];
			_count = 0;
		};
	};
	
	// Reset the message
	missionNamespace setVariable ["RS_MessageHandler_Execute", nil, true];
	
	if (_logLevel >= 3) then 
	{
		diag_log format ["[%1] [INFO] Message Handler execution requested starting message processing", _logName];
	};
	
	// Fetch our Message Listeners
	_messageListeners = missionNamespace getVariable ["RS_MessageListeners", []];
	
	// Get our messages from the listener
	_messages = [];
	if (!(_messageListeners isEqualTo [])) then
	{
		{
			_listener = _x;
			_messages = _messages + ([_listener] call RS_MQ_fnc_MessageFetcher);
		} forEach _messageListeners;
	};
	
	// Process our messages
	{
		// Get message info
		_listener = _x select 0;
		_message = (_x select 1) select 0;
		_params = (_x select 1) select 1;
		_environment = (_x select 1) select 2;
		
		// Run the message
		_handle = [_listener, _message, _params, _environment] spawn RS_MQ_fnc_MessageExecuter;
		
		// Check for message completion
		_control = 0;
		waitUntil {
			sleep 0.1;
			_control = _control + 1;
			((scriptDone _handle) || (_control == 10));
		};
		
		// If message takes longer than a second log a warning
		if ((_control == 10) && (_logLevel >= 2)) then
		{
			diag_log format ["[%1] [WARNING] Message Handler processing for Message [%2] took longer than 1 second, check later logs for message completion.", _logName, _listener];
		};
	} forEach _messages;
};

/*
	END
*/