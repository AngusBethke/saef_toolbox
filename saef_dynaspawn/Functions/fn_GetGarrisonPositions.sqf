/*
	fn_GetGarrisonPositions.sqf

	Description:
		Returns an array of positions to garrison based on the given parameters
*/

params
[
	"_pos",
	"_rad",
	"_countGrp"
];

private
[
	"_bldArr",
	"_countBld"
];
_bldArr = [];
_countBld = 0;

if (_rad > 150) then
{
	["DynaSpawn", 3, (format ["[Garrison] Radius [%1] for garrison is too large, reducing to 150m.", _rad])] call RS_fnc_LoggingHelper;
	_rad = 150;
};

// Get our Buildings
if (_rad < 0) then 
{
    _bldArr = [nearestBuilding _pos];
	_countBld = 1;
} 
else 
{
    _bldArr = nearestObjects [_pos, ["building"], _rad];
	{
		_x params ["_building"];

		// If building has no viable positions then remove it from the list of buildings
		if ((_building buildingPos 0) isEqualTo [0,0,0]) then
		{
			_bldArr = _bldArr - [_building];
		}
		else
		{
			// If the building is hidden then remove it from the list of buildings
			if (isObjectHidden _building) then
			{
				_bldArr = _bldArr - [_building];
			}
			else
			{
				// If there is a player within 15 meters of the building then remove it from the list of buildings
				if (!(([(getPos _building), 15] call RS_PLYR_fnc_GetClosestPlayer) isEqualTo [0,0,0])) then
				{
					_bldArr = _bldArr - [_building];
				};
			};
		};
	} forEach _bldArr;
	_countBld = (count _bldArr);
};

// If there are no Buildings in a Given Radius, Exit with Warning Message
if (_countBld == 0) exitWith
{
	["DynaSpawn", 1, (format ["[Garrison] No Buildings in Given Area, No Units Garrisoned"])] call RS_fnc_LoggingHelper;
	
	// Return empty array
	[]
};

// If there are more Buildings than Soldiers use one soldier per building
if (_countBld > _countGrp) then
{
	_countBld = _countGrp;
};

private
[
	"_itt"
];

_itt = 1;

if (_countBld < _countGrp) then
{
	_itt = ceil (_countGrp / _countBld);
};

private
[
	"_posArr",
	"_j"
];

_posArr = [];
_j = 0;

for "_i" from 0 to (_countBld - 1) do
{
	// Get Building Positions for this Building and Set Temp array to that
	_bldPos = [(_bldArr select _i)] call BIS_fnc_buildingPositions;
	
	// Make sure none of the positions are underground - if they are just put them at ground level
	{
		if ((_x select 2) < 0) then
		{
			_y = [(_x select 0), (_x select 1), 0];
			_bldPos set [_forEachIndex, _y];
		};
	} forEach _bldPos;
	
	// Assign our temp values
	_tmpArr = _bldPos;
	_j = 1;
	
	// While we still have to pick garrison slots in this building
	while {_j <= _itt} do
	{
		// Select a Random Position from this array
		_tmpPos = [];
		if ((count _tmpArr) != 0) then
		{
			_tmpPos = selectRandom _tmpArr;
		};
		
		// Check if Pos Array already has elements
		if ((count _posArr) > 0) then
		{
			for "_k" from 0 to ((count _posArr) - 1) do
			{
				// Make sure Temp Array is not empty
				if ((count _tmpArr) != 0) then
				{
					// If our temporary position already exists in the Pos Array
					// Remove that position from our possible choices and pick again
					if (_tmpPos isEqualTo (_posArr select _k)) then
					{
						_tmpArr = _tmpArr - [_tmpPos];
						_tmpPos = selectRandom _tmpArr;
					};
				}
				else
				{
					// If we've exhausted all the positions in this building, just grab any of them
					_tmpPos = selectRandom _bldPos;
				};
			};
		};
		
		// Add our position to the position array
		if (!isNil "_tmpPos") then
		{
			_posArr pushBack _tmpPos;
		}
		else
		{
			// Push Back Default Position
			_tmpPos = selectRandom _bldPos;
			_posArr pushBack _tmpPos;
		};
		
		_j = _j + 1;
	};
};

{
	_tmpPos = _x;
	if ((_tmpPos select 2) < 0) then
	{
		_tmpPos set [2, 0];
	};
	_posArr set [_forEachIndex, _tmpPos];
} forEach _posArr;

// Return the positions
_posArr