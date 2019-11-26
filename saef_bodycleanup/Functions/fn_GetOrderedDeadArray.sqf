/*
	fn_GetOrderedDeadArray.sqf
	Description: Returns an array of allDeadMen ordered by their distance from the player
*/

private
[
	"_playerArray",
	"_closestPlayerPos"
];

_closestDistance = _this select 0;
_deadArray = [];
_frontArray = [];
_backArray = [];

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
				_backArray = _backArray + [_x];
			}
			else
			{
				_frontArray = [_x] + _frontArray;
			};
		};
	};
} forEach allDeadMen;

_deadArray = [_frontArray, _backArray];

// Return: The Dead Array
_deadArray