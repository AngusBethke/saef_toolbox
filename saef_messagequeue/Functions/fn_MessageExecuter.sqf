/*
	fn_MessageExecuter.sqf
	Description: Executes all given messages
	Author: Angus Bethke a.k.a. Rabid Squirrel
*/

private
[
	"_logLevel"
	,"_logName"
	,"_listener"
	,"_message"
	,"_environment"
	,"_messageOrder"
];

_logLevel = missionNamespace getVariable ["RS_MessageHandler_LogLevel", 2];
_logName = "RS Message Executer";

_listener = _this select 0;
_message = _this select 1;
_params = _this select 2;
_environment = _this select 3;

if (_logLevel >= 4) then 
{
	diag_log format [
		"[%1] [DEBUG] Message for [%2] is: %3", 
		_logName,
		_listener,
		_this
	];
};

switch toUpper(_environment) do
{
	case "HEADLESS":
	{
		// Exec all this cool stuff on the headless
		[[_listener, _message, ""], RS_MQ_fnc_MessageExecuter] remoteExec ["spawn", HC1, false]; 
	};
	default
	{
		// Fetch message order from the players and headless client (if any)
		_messageOrder = [];
		{
			_player = _x;
			_variable = (format ["%1_Order", _listener]);
			_playerOrder = _x getVariable [_variable, -1];

			if (_playerOrder != -1) then
			{
				_messageOrder = _messageOrder + [[_player, _playerOrder]];
				
				// Dequeue the message
				_x setVariable [_variable, nil, true];
			};
		} forEach allPlayers;
		
		[_listener, _messageOrder, _params] spawn _message;
	};
};

/*
	END
*/