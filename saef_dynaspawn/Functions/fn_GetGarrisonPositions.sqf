/*
	fn_GetGarrisonPositions.sqf

	Description:
		Returns an array of positions to garrison based on the given parameters
*/

params
[
	"_pos",
	"_rad",
	"_countGroup"
];

private
[
	"_buildings"
];

_buildings = [];

if (_rad > 150) then
{
	["DynaSpawn", 3, (format ["[Garrison] Radius [%1] for garrison is too large, reducing to 150m.", _rad])] call RS_fnc_LoggingHelper;
	_rad = 150;
};

// Get our buildings
if (_rad < 0) then 
{
    _buildings = [nearestBuilding _pos];
} 
else 
{
    _buildings = nearestObjects [_pos, ["building"], _rad];
	{
		_x params ["_building"];

		// If building has no viable positions then remove it from the list of buildings
		if ((_building buildingPos 0) isEqualTo [0,0,0]) then
		{
			_buildings = _buildings - [_building];
		}
		else
		{
			// If the building is hidden then remove it from the list of buildings
			if (isObjectHidden _building) then
			{
				_buildings = _buildings - [_building];
			}
			else
			{
				// If there is a player within 15 meters of the building then remove it from the list of buildings
				if (!(([(getPos _building), 15] call RS_PLYR_fnc_GetClosestPlayer) isEqualTo [0,0,0])) then
				{
					_buildings = _buildings - [_building];
				}
				else
				{
					// If this building is blacklisted for spawns then remove it from the list of buildings
					if ((typeOf _building) in (missionNamespace getVariable ["RS_DS_Garrison_BuildingTypeBlacklist", []])) then
					{
						_buildings = _buildings - [_building];
					};
				};
			};
		};
	} forEach _buildings;
};

// If there are no buildings in a given radius, exit with warning message
if ((count _buildings) == 0) exitWith
{
	["DynaSpawn", 1, (format ["[Garrison] No Buildings in Given Area, No Units Garrisoned"])] call RS_fnc_LoggingHelper;
	
	// Return empty array
	[]
};

// Get building positions for the buildings and load them into a 2d array
private
[
	"_buildingPositions"
];

_buildingPositions = [];

{
	_x params ["_building"];
	_buildingPositions pushBack ([_building] call BIS_fnc_buildingPositions);
} forEach _buildings;

// Cull the building positions to fit number of units
private
[
	"_tempBuildingPositions"
];

_tempBuildingPositions = [];

if ((count _buildingPositions) > _countGroup) then
{
	for "_i" from 0 to (_countGroup - 1) do
	{
		_tempBuildingPositions pushBack (_buildingPositions select _i);
	};

	_buildingPositions = _tempBuildingPositions;
};

// Get the largest number of slots for outer array
private
[
	"_mostPositions"
];

_mostPositions = 0;
_tempBuildingPositions = [];

{
	private
	[
		"_currentBuildingPositions"
	];

	_currentBuildingPositions = _x;

	if ((count _currentBuildingPositions) > _mostPositions) then
	{
		_mostPositions = (count _currentBuildingPositions);
	};

	// Shuffle array
	_tempBuildingPositions pushBack (_currentBuildingPositions call BIS_fnc_arrayShuffle);
} forEach _buildingPositions;

_buildingPositions = _tempBuildingPositions;

// Start assigning our positions
private
[
	"_positions",
	"_positionsAssigned",
	"_itteration"
];

_positions = [];
_positionsAssigned = 0;
_itteration = 0;

while {_positionsAssigned <= _countGroup} do
{
	if (_itteration > _mostPositions) then
	{
		_itteration = 0;
	};

	{
		private
		[
			"_currentBuildingPositions"
		];

		_currentBuildingPositions = _x;

		// If there is still a position available in this building, assign it
		if (((count _currentBuildingPositions) - 1) >= _itteration) then
		{
			_positions pushBack (_currentBuildingPositions select _itteration);
			_positionsAssigned = _positionsAssigned + 1;
		};
	} forEach _buildingPositions;

	_itteration = _itteration + 1;
};

// Ensure that there are no positions below the ground
{
	private
	[
		"_tmpPos"
	];

	_tmpPos = _x;

	if ((_tmpPos select 2) < 0) then
	{
		_tmpPos set [2, 0];
	};
	_positions set [_forEachIndex, _tmpPos];
} forEach _positions;

// Return the positions
_positions