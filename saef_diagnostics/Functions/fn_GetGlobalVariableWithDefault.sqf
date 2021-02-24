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