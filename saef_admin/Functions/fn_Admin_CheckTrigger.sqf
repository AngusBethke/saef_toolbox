/**
	@namespace RS
	@class Admin
	@method RS_fnc_Admin_CheckTrigger
	@file fn_Admin_CheckTrigger.sqf
	@summary Evaluates triggers for mistakes
	@param any _triggers
**/

/*
	fn_Admin_CheckTrigger.sqf
	Description: Evaluates triggers for mistakes
	How to Call: [_triggers] call RS_fnc_Admin_CheckTrigger;
*/

params
[
	"_triggers"
];

private
[
	"_errorStr"
];

if (_triggers isEqualTo []) then
{
	["SAEF Toolbox Trigger Check", 3, "No Triggers Found..."] call RS_fnc_LoggingHelper;
};

_errorStr = "";
{
	_executeInOnActivation = ["onActivation", true, ["execVM", "spawn", "call"]] call RS_fnc_Admin_CheckTrigger_SearchString;
	_executeInOnDeactivation = ["onDeactivation", true, ["execVM", "spawn", "call"]] call RS_fnc_Admin_CheckTrigger_SearchString;
	_ignoreCheck = ["text", false, ["IgnoreTriggerCheck"]] call RS_fnc_Admin_CheckTrigger_SearchString;
	_notServerOnly = !((_x get3DENAttribute "IsServerOnly") select 0);
	
	if ((_executeInOnActivation || _executeInOnDeactivation) && _notServerOnly && !_ignoreCheck) then
	{
		_text = format [
			"Trigger [%1] %2 is executing a script, but it is not server only! If you would like to ignore this trigger, add 'IgnoreTriggerCheck' to the trigger text.", 
			((_x get3DENAttribute "name") select 0),
			((_x get3DENAttribute "position") select 0)];
			
		["SAEF Toolbox Trigger Check", 2, _text] call RS_fnc_LoggingHelper;
		_errorStr = _errorStr + "<br/>[SAEF Toolbox Trigger Check] " + _text;
	};
	
} forEach _triggers;

_errorStr

/*
	END
*/