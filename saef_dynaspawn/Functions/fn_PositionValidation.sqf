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
	_pos = _var;
};

// Returns: Boolean, Position and Direction
[_valid, _pos, _azi]