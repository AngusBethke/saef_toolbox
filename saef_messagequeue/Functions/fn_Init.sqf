/*
	fn_Init.sqf
	Description: Initialises variables needed by the function
	Author: Angus Bethke a.k.a. Rabid Squirrel
*/

private
[
	"_params"
];

/*
	RS_MessageHandler_LogLevel
	--------------------------
	
	Note: 	Each log level includes all the levels below it, eg: 
			log level ERROR will only display errors.
			log level WARNING will display errors and warnings.
			log level INFO will display errors, warnings and info messages.
			log level DEBUG will display errors, warnings, info and debug messages.
	
	Log Levels:
	DEBUG 		= 4
	INFO 		= 3
	WARNING		= 2
	ERROR		= 1
*/
missionNamespace setVariable ["RS_MessageHandler_LogLevel", 3, true];

/*
	RS_MessageHandler_MessageParams
	-------------------------------
	
	Description:
	Message params is a variable that can be used to define the parameters 
	that can be used in the message code blocks of each message
	
	Current supported params:
	"_listener"			- 	Variable name used by the message
	"_messageOrder"		- 	A (player, order) array used to specify an
							order in which things should be executed
							based on the messages collected by the message fetcher
*/
_params = 
[
	"_listener"
	,"_messageOrder"
	,"_params"
];
missionNamespace setVariable ["RS_MessageHandler_MessageParams", _params, true];

/*
	END
*/