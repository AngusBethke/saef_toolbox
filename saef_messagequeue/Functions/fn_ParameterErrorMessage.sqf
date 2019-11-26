/*
	fn_ParameterErrorMessage.sqf
	Description: 	Displays an error message if the parameter inputs/count is wrong
					Create to reduce repeated code in fn_MessageFetcher.sqf
	Author: Angus Bethke a.k.a. Rabid Squirrel
*/

_messageCount = _this select 0;
_logName = _this select 1;
_listener = _this select 2;
_player = _this select 3;

_par = "few";
if (_messageCount >= 3) then
{
	_par = "many";
};

diag_log format [
	"[%1] [ERROR] Message [%2] for %3 has too %4 Parameters [%5], please check the message and requeue it.", 
	_logName,
	_listener,
	_player,
	_par,
	_messageCount
];

/*
	END
*/