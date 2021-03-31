/*
	fn_PositionValidation.sqf
	Author: Angus Bethke
	Description: 
		Determines whether the variable passed is a Valid Marker or position
*/

params
[
	"_var"
];

private
[
	"_valid",
	"_pos",
	"_azi"
];

_valid = true;
_pos = [];
_azi = 0;

if ((typeName _var) isEqualTo "STRING") then
{
	if ((markerPos _var) isEqualTo [0,0,0]) then
	{
		_valid = false;
	}
	else
	{
		_pos = markerPos _var;
		_azi = markerDir _var;
	};
}
else
{
	// Return a position and direction if we have one
	if ((count _var) == 4) then
	{
		_pos = [(_var select 0), (_var select 1), (_var select 2)];
		_azi = (_var select 3);
	}
	else
	{
		_pos = _var;
	};
};

// Returns: Boolean, Position and Direction
[_valid, _pos, _azi]