/*
	Function: fn_Garrison.sqf
	Author: Angus Bethke
	Description: Garrisons Units in Building Positions in a given radius
	Last Modified: 08-03-2018
*/

private
[
	"_pos",
	"_grp",
	"_rad",
	"_debug",
	"_countGrp",
	"_itt",
	"_j",
	"_bldArr",
	"_countBld",
	"_posArr",
	"_bldPos",
	"_tmpArr",
	"_tmpPos"
];

/* Variable Assignment */
_pos = _this select 0;
_grp = _this select 1;
_rad = _this select 2;
_debug = missionNamespace getVariable "RS_DS_Debug";

_countGrp = (count (units _grp));
_itt = 1;
_j = 0;

/* Get our Buildings, if Building has No Viable Positions Remove it from the list of Buildings */
if (_rad < 0) then 
{
    _bldArr = [nearestBuilding _pos];
	_countBld = 1;
} 
else 
{
    _bldArr = nearestObjects [_pos, ["building"], _rad];
	{
		if ((_x buildingPos 0) isEqualTo [0,0,0]) then
		{
			_bldArr = _bldArr - [_x];
		};
	} forEach _bldArr;
	_countBld = (count _bldArr);
};

/* If there are no Buildings in a Given Radius, Exit with Warning Message */
if (_countBld == 0) exitWith
{
	if (_debug select 0) then
	{
		diag_log format ["%1 [ERROR] Garrison: No Buildings in Given Area, No Units Garrisoned", (_debug select 1)];
	};
	
	// Garrison Failure will result in unit cleanup
	{
		deleteVehicle _x;
	} forEach units _grp;
};

/* If there are more Buildings than Soldiers use one soldier per building */
if (_countBld > _countGrp) then
{
	_countBld = _countGrp;
};

if (_countBld < _countGrp) then
{
	_itt = ceil (_countGrp / _countBld);
};

_posArr = [];

for "_i" from 0 to (_countBld - 1) do
{
	// Get Building Positions for this Building and Set Temp array to that
	_bldPos = [(_bldArr select _i)] call BIS_fnc_buildingPositions;
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

if (_debug select 0) then
{
	diag_log format ["%1 [INFO] Positions to Garrison: %2", (_debug select 1), _posArr];
};

_groupUnits = units _grp;
_useStatics = true;

if (_useStatics) then
{
	// Get in any nearby vehicles
	_vehicles = _pos nearEntities[["Car", "Tank", "Turret"], _rad];
	{
		_vehicle = _x;
		_gunnerPositions = fullCrew [_x, "gunner", true];
		
		{
			_object = _x select 0;
			if (isNull _object) then
			{
				(_groupUnits select 0) moveInGunner _vehicle;
				(_groupUnits select 0) action ["getInGunner", _vehicle];
				_groupUnits = _groupUnits - [(_groupUnits select 0)];
			};
	
			sleep 0.1;
		} forEach _gunnerPositions;
	} forEach _vehicles;
};

/* Assign units to their Building Positions */
_j = 0;
{
	_x setPos (_posArr select _j);
	_x setUnitPos (selectRandom ["UP", "MIDDLE"]);
	_x disableAI "PATH";
	
	/* TEMPORARY */
	_x setDir (random(360));
	/* TEMPORARY */
	
	_j = _j + 1;
	
	sleep 0.1;
} forEach _groupUnits;

/* Return: True */
true