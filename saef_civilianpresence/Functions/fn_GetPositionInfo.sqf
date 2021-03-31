/*
	fn_GetPositionInfo.sqf
	Description: Gets position information about the location
*/

params
[
	"_pos"
	,"_locations"
	,"_supportedLocations"
];

private
[
	"_posArray"
	,"_distArray"
	,"_minDist"
	,"_sizeLoc"
	,"_size"
];

_posArray = [];
{
	if ((type _x) in _supportedLocations) then
	{
		_posArray = _posArray + [position _x];
	};
} forEach _locations;

_posArray = _posArray - [_pos];

_distArray = [];
{
	_dist = _pos distance2D _x;
	_distArray = _distArray + [_dist];
} forEach _posArray;

_minDist = (selectMin _distArray)/2;

// Cap Location size at 4000m
if (_minDist > 4000) then
{
	["RS Civilian Presence", 2, (format ["Capping size [%2] for location: %1 at 4000m", (text _location), _minDist])] call RS_fnc_LoggingHelper;
	_minDist = 4000;
};

_sizeLoc = [_minDist, _minDist, 0]; // size _location;
_size = ((_sizeLoc select 0) + (_sizeLoc select 1)) / 2; 

// Return all our info
[_posArray, _distArray, _minDist, _sizeLoc, _size]