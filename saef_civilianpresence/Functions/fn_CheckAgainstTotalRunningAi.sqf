/**
	@namespace RS_CP
	@class CivilianPresence
	@method RS_CP_fnc_CheckAgainstTotalRunningAi
	@file fn_CheckAgainstTotalRunningAi.sqf
	@summary Takes a side and number and returns whether more or that side than the number exists

	@param side _side
	@param int _count

	@return bool Returns true if our currently running ai count is less than the count control value we have been given

**/
/*
	fn_CheckAgainstTotalRunningAi.sqf
	Description: Takes a side and number and returns whether more or that side than the number exists
*/

params
[
	"_side",
	"_count"
];

private
[
	"_activeCount"
];

_activeCount = 0;
{
	if ((side _x) == _side) then
	{
		if (local _x) then
		{
			_activeCount = _activeCount + 1;
		};
	};
} forEach allUnits;

// Returns true if our currently running ai count is less than the count control value we have been given
(_activeCount < _count)