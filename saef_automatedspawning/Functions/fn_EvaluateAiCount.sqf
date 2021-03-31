/*
	fn_EvaluateAiCount.sqf

	Description:
		Returns the number of local AI on a given target object
*/

if (!isServer) exitWith
{
	["SAEF_AS_fnc_EvaluateAiCount", 1, "This must be called from the server!"] call RS_fnc_LoggingHelper;
};

params
[
	"_target"
];

private
[
	"_count"
];

// Count the AI
_count = _target getVariable ["SAEF_AI_StagedAICount", 0];
{
	if ((owner _x) == (owner _target)) then
	{
		_count = _count + 1;
	};
} forEach allUnits;

// Return the AI count
_count