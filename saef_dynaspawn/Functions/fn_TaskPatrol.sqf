/**
	@namespace RS_DS
	@class DynaSpawn
	@method RS_DS_fnc_TaskPatrol
	@file fn_TaskPatrol.sqf
	@summary Creates a patrol route for AI given a set of parameters
	
	@param group _group Given group
	@param position _pos Starting Position
	@param int _area Size of area
	@param ?bool _allowWaterCreation Allow waypoints to be created in the water
	

**/

/*
	fn_TaskPatrol.sqf

	Description:
		Creates a patrol route for AI given a set of parameters

	[
		_group,					// Given group
		_pos, 					// Starting Position
		_area,					// Size of area
		_allowWaterCreation		// (Optional) Allow waypoints to be created in the water
	] call RS_DS_fnc_TaskPatrol;
*/

params
[
	"_group",
	"_pos",
	"_area",
	["_allowWaterCreation", false]
];

private
[
	"_clockWise",
	"_dir",
	"_waypointIndex",
	"_startingWaypointPosition"
];

// Some randomization
_clockWise = (selectRandom [true, false]);

_dir = 0;
if (!_clockWise) then
{
	_dir = 360;
};

// Add our default circle of waypoints
_waypointIndex = 0;
_startingWaypointPosition = [];
for "_i" from 0 to 7 do
{
	private
	[
		"_wp",
		"_waypointPosition"
	];

	_waypointPosition = (_pos getPos [_area, _dir]);

	// Make sure we don't create waypoints in the water
	if (!(surfaceIsWater _waypointPosition) || _allowWaterCreation) then
	{
		_wp = _group addWaypoint [_waypointPosition, _waypointIndex];
		_wp setWaypointSpeed "LIMITED";
		_wp setWaypointType "MOVE";
		_wp setWaypointBehaviour "SAFE";

		if (_waypointIndex == 0) then
		{
			_startingWaypointPosition = _waypointPosition;
		};

		_waypointIndex = _waypointIndex + 1;
	};

	if (_clockWise) then
	{
		_dir = _dir + 45;
	}
	else
	{
		_dir = _dir - 45;
	};
};

// Add our cross waypoints
private
[
	"_crossPoints"
];

_crossPoints = [135, 45, 225, 315];
if (!_clockWise) then
{
	_crossPoints = [225, 315, 135, 45];
};

{
	_x params ["_dir"];

	private
	[
		"_wp",
		"_waypointPosition"
	];

	_waypointPosition = (_pos getPos [_area, _dir]);

	// Make sure we don't create waypoints in the water
	if (!(surfaceIsWater _waypointPosition) || _allowWaterCreation) then
	{
		_wp = _group addWaypoint [_waypointPosition, _waypointIndex];
		_wp setWaypointSpeed "LIMITED";
		_wp setWaypointType "MOVE";
		_wp setWaypointBehaviour "SAFE";

		_waypointIndex = _waypointIndex + 1;
	};
} forEach _crossPoints;

// Add our final cycle waypoint
if (!(_startingWaypointPosition isEqualTo [])) then
{
	private
	[
		"_wp"
	];

	_wp = _group addWaypoint [_startingWaypointPosition, _waypointIndex];
	_wp setWaypointSpeed "LIMITED";
	_wp setWaypointType "CYCLE";
	_wp setWaypointBehaviour "SAFE";
}
else
{
	["DynaSpawn", 1, (format ["[TaskPatrol] Unable to create waypoints at position %1, for group [%2], with area size [%3]. Waypoints might be underwater, consider flagging '_allowWaterCreation' to true", _pos, _group, _area])] call RS_fnc_LoggingHelper;
};