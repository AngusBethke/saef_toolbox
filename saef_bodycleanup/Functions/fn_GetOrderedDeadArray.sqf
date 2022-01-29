/**
	@namespace RS_BC
	@class BodyCleanup
	@method RS_BC_fnc_GetOrderedDeadArray
	@file fn_GetOrderedDeadArray.sqf
	@summary Returns an array of allDeadMen ordered by their distance from the player

	@param int _closestDistance

**/

/*
	fn_GetOrderedDeadArray.sqf
	Description: Returns an array of allDeadMen ordered by their distance from the player
*/

params
[
	"_closestDistance"
];

private
[
	"_deadArray",
	"_frontArray",
	"_backArray",
	"_retBackArray"
];

_deadArray = [];
_frontArray = [];
_backArray = [];
_retBackArray = [];

{
	// Make sure the unit is local to the deleter
	if (local _x) then
	{
		_exclude = _x getVariable ["RS_ExcludeBodyFromDeletion", false];
		
		if !(_exclude) then
		{
			_distToPlayer = _closestDistance;
			_closestPlayerPos = [position _x, _closestDistance] call RS_PLYR_fnc_GetClosestPlayer;
			
			if !(_closestPlayerPos isEqualTo [0,0,0]) then
			{
				_distToPlayer = (position _x) distance2D _closestPlayerPos;
			};
			
			if (_distToPlayer < _closestDistance) then
			{
				_backArray pushback [_distToPlayer, _x];
			}
			else
			{
				_frontArray = [_x] + _frontArray;
			};
		};
	};
} forEach allDeadMen;

// Sort the back array into distance order (longer distances first)
_backArray sort false;

{
	_retBackArray pushback (_x select 1);
} forEach _backArray;

_deadArray = [_frontArray, _retBackArray];

// Return: The Dead Array
_deadArray
