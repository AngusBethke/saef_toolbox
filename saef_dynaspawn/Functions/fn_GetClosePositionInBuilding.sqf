/*
	fn_GetClosePositionInBuilding.sqf

	Description:
		Given a position returns the closest building position to that (if it's in a building)

	[
		_position
	] call RS_DS_fnc_GetClosePositionInBuilding;
*/

params
[
	"_position"
];

private
[
	"_inBuildingInfo"
];

_inBuildingInfo = [_position] call RS_LC_fnc_InBuilding;
_inBuildingInfo params
[
	"_inside",
	"_building"
];

// If this position is not inside a building, exit with the given position
if (!_inside) exitWith
{
	_position
};

// If this building has no building positions, exit with the given position
if ((_building buildingPos 0) isEqualTo [0,0,0]) exitWith
{
	_position
};

// Get Building Positions for this Building
private
[
	"_buildingPositions"
];

_buildingPositions = [_building] call BIS_fnc_buildingPositions;

// Make sure none of the positions are underground - if they are just put them at ground level
{
	private
	[
		"_buildingPosition"
	];

	_buildingPosition = _x;
	_buildingPosition params
	[
		"_myX",
		"_myY",
		"_myZ"
	];

	if (_myZ < 0) then
	{
		private
		[
			"_newBuildingPosition"
		];

		_newBuildingPosition = [_myX, _myY, 0];
		_buildingPositions set [_forEachIndex, _newBuildingPosition];
	};
} forEach _buildingPositions;

// Test the distance of each position to our position to find the closest one
private
[
	"_distance",
	"_newPosition"
];

_distance = 9999;
_newPosition = _position;
{
	private
	[
		"_buildingPosition"
	];

	_buildingPosition = _x;

	if ((_buildingPosition distance _position) < _distance) then
	{
		_distance = (_buildingPosition distance _position);
		_newPosition = _buildingPosition;
	};

} forEach _buildingPositions;

// Return the closest building position to our position
_newPosition