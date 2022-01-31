/**
	@namespace RS_Radiation
	@class Radiation
	@method RS_Radiation_fnc_GetClosestMarker
	@file fn_GetClosestMarker.sqf
	@summary Returns the closest marker

	@param array _markerList
	@param int _size

	@todo _size to in usage?

	@usage ```[_markerList] call RS_Radiation_fnc_GetClosestMarker;```

**/

/*
	fn_GetClosestMarker.sqf
	Description: Returns the closest marker
	[_markerList] call RS_Radiation_fnc_GetClosestMarker;
*/

params
[
	"_markerList",
	"_size"
];

private
[
	"_marker"
];

_marker = "";

{
	_distance = 99999;
	_newSize = _size;
	if (_marker != "") then
	{
		_distance = (_unit distance (markerPos _marker));
	};
	
	_mArr = _x splitString "_";
	if ((count _mArr) == 4) then
	{
		_newSize = parseNumber (_mArr select 2);
	};

	if (((_unit distance (markerPos _x)) < _distance) && ((_unit distance (markerPos _x)) <= _newSize)) then
	{
		_marker = _x;
		_size = _newSize;
	};
} forEach _markerList;

// Returns the marker
[_marker, _size]

/*
	END
*/