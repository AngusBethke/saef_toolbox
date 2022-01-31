/**
	@namespace SAEF_AS
	@class AutomatedSpawning
	@method SAEF_AS_fnc_EvaluationParameter
	@file fn_EvaluationParameter.sqf
	@summary Returns the index of the parameter we're interested in
	@param object _function
**/
/*
	fn_EvaluationParameter.sqf

	Description:
		Returns the index of the parameter we're interested in

	How to call:
		[
			_function		// Function name in string format
		] call SAEF_AS_fnc_EvaluationParameter;
*/

params
[
	"_function"
];

private
[
	"_index"
];

_index = 0;
switch toLower(_function) do
{
	case "saef_as_fnc_spawner": 
	{
		_index = 4;
	};
	case "saef_as_fnc_hunterkiller":
	{
		_index = 3;
	};
	default
	{
		_index = 0;
	};
};

// Return the index
_index