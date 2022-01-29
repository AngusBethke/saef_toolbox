/**
	@namespace RS_DIAG
	@class Diagnostics
	@method RS_DIAG_fnc_GetGlobalVariableWithDefault
	@file fn_GetGlobalVariableWithDefault.sqf
	@summary Takes a global variable and a default value and if the global variable is not set return the default

	@param any _variable
	@param any _default

**/
/*
	fn_GetGlobalVariableWithDefault.sqf

	Description:
		Takes a global variable and a default value and if the global variable is not set return the default
*/

params
[
	"_variable",
	"_default"
];

if (isNil _variable) exitWith
{
	_default
};

(call compile _variable)