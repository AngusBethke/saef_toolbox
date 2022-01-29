/**
	@namespace RS_Radiation
	@class Radiation
	@method RS_Radiation_fnc_GetGridInfo
	@file fn_GetGridInfo.sqf
	@summary Returns grids for mapping items

	@param int _size
	@param position _pos

	@returns array [<array>_posGrid, <int>_gridSize]

**/

/*
	fn_GetGridInfo.sqf
	Description: Returns grids for mapping items
	Parameters: <_size> int, <_pos> position
	Returns: <Array> Position Grid, <int> Grid Size
*/

params
[
	"_size",
	"_pos"
];

private
[
	"_posGrid",
	"_iMod",
	"_sizePrev",
	"_gridSize",
	"_topPos",
	"_vertHeight",
	"_horiWidth",
	"_gridX",
	"_gHasBuildings"
];

_posGrid = [];

// Set size of an area in increments of 100m
if (_size < 100) then
{
	_size = 100;
}
else
{
	for "_i" from 1 to 15 do
	{
		_iMod = (_i*100);
		_sizePrev = _iMod - 100;
		if ((_size <= _iMod)&&(_size > _sizePrev)) exitWith
		{
			_size = _iMod + 100;
		};
	};
};

//Get the amount of Blocks in the Grid
_gridSize = _size/100;

// Work out each of the positions for the grid blocks
_lftPos = (_pos select 0) + (100 * (_gridSize / 2));
_topPos = (_pos select 1) + (100 * (_gridSize / 2));
_vertHeight = (_topPos - 25);

for "_i" from 1 to _gridSize do
{
	_gridX = [];
	_horiWidth = (_lftPos - 25);
	
	for "_j" from 1 to _gridSize do
	{
		_tempPos = [_horiWidth, _vertHeight, 0];
		_gridX pushBack _tempPos;
		_horiWidth = _horiWidth - 100;
	};
	
	_posGrid pushBack _gridX;
	_vertHeight = _vertHeight - 100;
};

//Returns: Array of Grid Arrays
[_posGrid, _gridSize]