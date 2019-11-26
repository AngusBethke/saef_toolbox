/*
	fn_ListenerEdit.sqf
	Description: Adds/Removes a listener for a specific message type to the listeners
	Author: Angus Bethke a.k.a. Rabid Squirrel
*/

private
[
	"_logLevel"
	,"_logName"
	,"_listener"
	,"_type"
	,"_messageListeners"
	,"_switch"
];

_logLevel = missionNamespace getVariable ["RS_MessageHandler_LogLevel", 2];
_logName = "RS Message Listener Add";

if (!isServer) exitWith 
{
	if (_logLevel >= 3) then 
	{
		diag_log format ["[%1] [INFO] Message Listener's may only be modified on the server", _logName];
	};
};

// Get the listener and type to add
_listener = _this select 0;
_type = _this select 1;

// Get our pre-existing listeners
_messageListeners = missionNamespace getVariable ["RS_MessageListeners", []];
_switch = false;

// Add a listener to our list of listeners
switch toUpper(_type) do
{
	case "ADD":
	{
		_messageListeners = _messageListeners + [_listener];
		_switch = true;
	};
	case "RMV":
	{
		_messageListeners = _messageListeners - [_listener];
		_switch = true;
	};
	default
	{
		if (_logLevel >= 1) then 
		{
			diag_log format ["[%1] [ERROR] Unknown Listener Edit Type %2", _logName, _type];
		};
	};
};

// Reset the variable
if (_switch) then
{
	missionNamespace setVariable ["RS_MessageListeners", _messageListeners, true];
	
	if (_logLevel >= 3) then 
	{
		diag_log format ["[%1] [INFO] New message listener registered [%2]", _logName, _listener];
	};
};

/*
	END
*/