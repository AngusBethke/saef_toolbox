/*
	Function: fn_PositionValidation.sqf
	Author: Angus Bethke
	Description: Determines whether the variable passed is a Valid Marker or position
	Last Modified: 04-11-2019
*/

//Private Variables	
private
[
	"_var",
	"_valid",
	"_pos",
	"_azi"
];

_var = _this select 0;
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
	if ((typeName _var) isEqualTo "ARRAY") then
	{
		if ((count _var) != 3) then
		{
			_valid = false;
		}
		else
		{
			{
				if (!((typeName _x) isEqualTo "SCALAR")) then
				{
					_valid = false;
				};
			} forEach _var;
			
			if (_valid) then
			{
				_pos = _var;
			};
		};
	}
	else
	{
		_valid = false;
	};
};

/* Returns: Boolean and Position */
[_valid, _pos, _azi]