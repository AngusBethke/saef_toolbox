/*
	fn_UpdateAiCount.sqf

	Description:
		Updates the staged AI count so that we don't accidentally offload all AI to one headless

	How to Call:
		[
			_target,			// Target to update
			_updateCount,		// Number of units to update
			_addition			// (Optional) Whether to add or subtract the count
		] call SAEF_AS_fnc_UpdateAiCount;
*/

params
[
	"_target",
	"_updateCount",
	["_addition", true]
];

private
[
	"_count"
];

// Update the AI count
_count = _target getVariable ["SAEF_AI_StagedAICount", 0];

if (_addition) then
{
	_count = _count + _updateCount;
}
else
{
	_count = _count - _updateCount;
};

if (_count < 0) then
{
	_count = 0;
};

_target setVariable ["SAEF_AI_StagedAICount", _count, true];

// Return the AI count
_count