/**
	@namespace RS
	@class Admin
	@method RS_fnc_Admin_CheckTrigger_SearchString
	@file fn_Admin_CheckTrigger_SearchString.sqf
	@summary Evaluates triggers for mistakes
	@param any _attribute
	@param any _trim
	@param any _strings
**/

/*
	fn_Admin_CheckTrigger_SearchString.sqf
	Description: Evaluates triggers for mistakes
	How to Call: [] call RS_fnc_Admin_CheckTrigger_SearchString;
*/

params
[
	"_attribute",
	"_trim",
	"_strings"
];

private
[
	"_code",
	"_condition"
];

_code = (_x get3DENAttribute _attribute) select 0;

// Trimming the first 4 characters
if (_trim) then 
{
	if (_code != "") then
	{
		_code = [_code, 4] call BIS_fnc_trimString;
	};
};

_condition = false;

{
	if ([_x, _code] call BIS_fnc_InString) then
	{
		_condition = true;
	};
} forEach _strings;

// Return the Condition
_condition

/*
	END
*/