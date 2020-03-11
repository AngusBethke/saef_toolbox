/*
	fn_MessageFetcher.sqf
	Description: Fecthes all messages based on queue type
	Author: Angus Bethke a.k.a. Rabid Squirrel
*/

private
[
	"_logLevel"
	,"_logName"
	,"_listener"
	,"_messages"
	,"_serverMessage"
];

_logLevel = missionNamespace getVariable ["RS_MessageHandler_LogLevel", 2];
_logName = "RS Message Fetcher";

_listener = _this select 0;
_messages = [];
_allPlayers = (allPlayers - entities "HeadlessClient_F");

// Fetch message for listener on the server
_serverMessage = missionNamespace getVariable [_listener, []];

if (!(_serverMessage isEqualTo [])) then
{
	if ((count _serverMessage) == 3) then
	{
		_messages = _messages + [[_listener, _serverMessage]];
		
		// If there is a server message and respective player messages, then we check to see if the messages are linked
		_order = 1;
		{
			_player = _x;
			_playerMessage = _x getVariable [_listener, []];

			if (!(_playerMessage isEqualTo [])) then
			{
				if ((count _playerMessage) == 4) then
				{
					// If the message is linked
					if (_playerMessage select 3) then
					{
						_x setVariable [(format ["%1_Order", _listener]), _order, true];
					}
					else
					{
						_messages = _messages + [[_listener, _playerMessage]];
					};
					_order = _order + 1;
				}
				else
				{
					if (_logLevel >= 1) then 
					{
						[(count _playerMessage), _logName, _listener, (format["Player [%1]", _player])] call RS_MQ_fnc_ParameterErrorMessage;
					};
				};
				
				// Dequeue the message
				_x setVariable [_listener, nil, true];
			};
		} forEach _allPlayers;
	}
	else
	{
		if (_logLevel >= 1) then 
		{
			[(count _serverMessage), _logName, _listener, "the Server"] call RS_MQ_fnc_ParameterErrorMessage;
		};
	};
		
	// Dequeue the message
	missionNamespace setVariable [_listener, nil, true];
}
else
{
	// Fetch all messages from the players and headless client
	{
		_player = _x;
		_playerMessage = _x getVariable [_listener, []];

		if (!(_playerMessage isEqualTo [])) then
		{
			if ((count _playerMessage) == 4) then
			{
				if !(_playerMessage select 3) then
				{
					_messages = _messages + [[_listener, _playerMessage]];
				
					// Dequeue the message
					_x setVariable [_listener, nil, true];
				}
				else
				{
					/* 	If the player message is linked to the server, but the server message hasn't been created yet, 
						then we need to wait for the server message to be created before we process this message */
					if (_logLevel >= 4) then 
					{
						diag_log format [
							"[%1] [DEBUG] Will not return Message [%2] for Player [%3] as it is linked to the server, and the server is not yet set to execute the message.", 
							_logName,
							_listener,
							_player
						];
					};
				};
			}
			else
			{
				if (_logLevel >= 1) then 
				{
					[(count _playerMessage), _logName, _listener, (format["Player [%1]", _player])] call RS_MQ_fnc_ParameterErrorMessage;
				};
				
				// Dequeue the message
				_x setVariable [_listener, nil, true];
			};
		};
	} forEach _allPlayers;
};

if (_logLevel >= 4) then 
{
	diag_log format [
		"[%1] [DEBUG] Messages for [%2] is: %3", 
		_logName,
		_listener,
		_messages
	];
};

// Return: Array of Messages
_messages

/*
	END
*/