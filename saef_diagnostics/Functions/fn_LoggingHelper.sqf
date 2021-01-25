/*
	fn_loggingHelper.sqf
	Description: Assists with logging
	
	Note: 	Each log level includes all the levels below it, eg: 
			log level VERBOSE will only display verbose messages.
			log level ERROR will display verbose and error messages.
			log level WARNING will display verbose, error, and warning messages.
			log level INFO will display verbose, error, warning and info messages.
			log level DEBUG will display verbose, error, warning, info and debug messages.
	
	Log Levels:
	DEBUG 		= 4
	INFO 		= 3
	WARNING		= 2
	ERROR		= 1
	VERBOSE		= 0
	
	How to call:
		[
			"_tag"			// The leading tag of the message
			,"_level"		// The level we are logging at
			,"_message"		// The message to log
			,"_onServer"	// (Optional) Do we want to log this on the server as well?
		] call RS_fnc_LoggingHelper;
*/

// Inbound Parameters
params
[
	 "_tag"
	,"_level"
	,"_message"
	,["_onServer", false]
];

// Local Variables
private
[
	"_levelTag"
];

// Check our level
switch _level do
{
	case 0:
	{
		_levelTag = "VERBOSE";
	};
	case 1:
	{
		_levelTag = "ERROR";
	};
	case 2:
	{
		_levelTag = "WARNING";
	};
	case 3:
	{
		_levelTag = "INFO";
	};
	case 4:
	{
		_levelTag = "DEBUG";
	};
	default 
	{
		// Recursive call to log the error
		["RS_fnc_LoggingHelper", 1, (format ["Level type [%1] not recognised!", _level])] call RS_fnc_LoggingHelper;
		
		// Set the level to max such that it cannot create a message
		_level = 999;
	};
};

if (_level <= (missionNamespace getVariable ["RS_Global_LogLevel", 2])) then
{
	// Create the message
	_logMessage = text (format ["[%1] [%2] %3", _tag, _levelTag, _message]);
	
	// Log the message
	diag_log _logMessage;
	
	// If we'd like to log this message to the server
	if (_onServer && !(isServer)) then
	{
		// We need to augment our message with additional information about who logged it
		_serverLogMessage = text (format ["[%1] [%2] [%3] %4", _tag, _levelTag, player, _message]);
		
		// Log the message on the server
		[_serverLogMessage] remoteExec ["diag_log", 2, false];
	};
};

/*
	END
*/