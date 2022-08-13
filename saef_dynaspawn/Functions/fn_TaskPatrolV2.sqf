/**
	@namespace RS_DS
	@class DynaSpawn
	@method RS_DS_fnc_TaskPatrolV2
	@file fn_TaskPatrolV2.sqf
	@summary Creates a patrol route for AI given a set of parameters
	
	@param string _type Type of functionality to execute
	@param array _params Params for that function
	

**/

/*
	fn_TaskPatrolV2.sqf

	Description:
		Handles patrol functionality

	[
		_type,						// Function type
		_params, 					// Parameters
	] call RS_DS_fnc_TaskPatrolV2;
*/

params
[
	"_type",
	["_params", []]
];

// Set the script tag
private
[
	"_scriptTag"
];

_scriptTag = "RS DS TaskPatrol V2";

/*
	-----------------
	-- STARTPATROL --
	-----------------

	Starts the patrol for a group
*/
if (toUpper(_type) == "STARTPATROL") exitWith
{
	_params params
	[
		"_group",
		"_pos",
		"_area",
		["_allowWaterCreation", false]
	];

	private
	[
		"_waypoints"
	];

	_waypoints = ["CreateWaypoints", [_pos, _area, _allowWaterCreation]] call RS_DS_fnc_TaskPatrolV2;

	if (_waypoints isEqualTo []) exitWith
	{
		[_scriptTag, 1, (format ["Unable to create waypoints at position %1, for group [%2], with area size [%3]. Waypoints might be underwater, consider flagging '_allowWaterCreation' to true", _pos, _group, _area])] call RS_fnc_LoggingHelper;
	};

	// Create the waypoints for the group
	{
		_x params
		[
			"_wpPosition",
			"_wpSpeed",
			"_wpType",
			"_wpBehaviour"
		];

		private
		[
			"_wp"
		];

		_wp = _group addWaypoint [_wpPosition, _forEachIndex];
		_wp setWaypointSpeed _wpSpeed;
		_wp setWaypointType _wpType;
		_wp setWaypointBehaviour _wpBehaviour;
	} forEach _waypoints;

	["HANDLEPATROL", [_group]] spawn RS_DS_fnc_TaskPatrolV2;
};

/*
	------------------
	-- HANDLEPATROL --
	------------------

	Handles the patrol for this group, if their linked area comes under attack, then remove their waypoints and turn them into Hunter Killers
*/
if (toUpper(_type) == "HANDLEPATROL") exitWith
{
	// Wait to initialise
	sleep 5;
	
	_params params
	[
		"_group"
	];

	private
	[
		"_marker"
	];

	_marker = _group getVariable ["SAEF_AS_Linked_Area", ""];

	[_scriptTag, 0, (format ["[HANDLEPATROL] Handling patrol for group [%1]...", _group])] call RS_fnc_LoggingHelper;

	// If no linked area is set, we don't need to manage this
	if (_marker == "") exitWith {};

	private
	[
		"_counterAttackVar"
	];

	_counterAttackVar = (format["Area_%1_UnderAttack", _marker]);

	waitUntil {
		sleep 10;
		((missionNamespace getVariable [_counterAttackVar, false]) || (({alive _x} count (units _group)) == 0))
	};

	// If there are any units left alive, they should become Hunter Killers
	if (({alive _x} count (units _group)) > 0) then
	{
		// Remove waypoints
		{
			deleteWaypoint _x;
		} forEach (waypoints _group);

		[_group, 4000, false, []] spawn RS_DS_fnc_HunterKiller;
	};
};

/*
	-------------------
	-- CREATEMARKERS --
	-------------------

	Creates markers to debug waypoint positions

	["CreateMarkers", [(markerPos "marker_0"), 25]] call RS_DS_fnc_TaskPatrolV2;
*/
if (toUpper(_type) == "CREATEMARKERS") exitWith
{
	_params params
	[
		"_pos",
		"_area",
		["_allowWaterCreation", false]
	];

	private
	[
		"_waypoints"
	];

	_waypoints = ["CreateWaypoints", [_pos, _area, _allowWaterCreation]] call RS_DS_fnc_TaskPatrolV2;

	if (_waypoints isEqualTo []) exitWith
	{
		[_scriptTag, 1, (format ["Unable to create waypoints at position %1, for group [%2], with area size [%3]. Waypoints might be underwater, consider flagging '_allowWaterCreation' to true", _pos, _group, _area])] call RS_fnc_LoggingHelper;
	};

	// Create the waypoints for the group
	{
		_x params
		[
			"_wpPosition",
			"_wpSpeed",
			"_wpType",
			"_wpBehaviour"
		];

		private
		[
			"_marker"
		];

		_marker = createMarker [(format ["WaypointMarker_%1", _forEachIndex]), _wpPosition];
		_marker setMarkerType "hd_dot";
		_marker setMarkerText (format ["%1 | %2 | %3", _wpType, _wpSpeed, _wpBehaviour]);
	} forEach _waypoints;
};

/*
	---------------------
	-- CREATEWAYPOINTS --
	---------------------

	Creates the waypoints and assigns them to a patrol
*/
if (toUpper(_type) == "CREATEWAYPOINTS") exitWith
{
	_params params
	[
		"_pos",
		"_area",
		["_allowWaterCreation", false]
	];

	private
	[
		"_clockWise",
		"_dir",
		"_waypoints"
	];

	// Some randomization
	_clockWise = (selectRandom [true, false]);

	_dir = 0;
	if (!_clockWise) then
	{
		_dir = 360;
	};

	// Add our default circle of waypoints
	_waypoints = [];

	for "_i" from 0 to 7 do
	{
		private
		[
			"_waypointPosition",
			"_buildingPositions"
		];

		_waypointPosition = (_pos getPos [_area, _dir]);

		_buildingPositions = ["GetBuildingPositions", [_waypointPosition, (_area / 2.5)]] call RS_DS_fnc_TaskPatrolV2;
		if (!(_buildingPositions isEqualTo [])) then
		{
			_waypointPosition = (selectRandom _buildingPositions);
		};

		// Make sure we don't create waypoints in the water
		if (!(surfaceIsWater _waypointPosition) || _allowWaterCreation) then
		{
			_waypoints pushBack [_waypointPosition, "LIMITED", "MOVE", "SAFE"];
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
			"_waypointPosition"
		];

		_waypointPosition = (_pos getPos [_area, _dir]);

		_buildingPositions = ["GetBuildingPositions", [_waypointPosition, (_area / 2.5)]] call RS_DS_fnc_TaskPatrolV2;
		if (!(_buildingPositions isEqualTo [])) then
		{
			_waypointPosition = (selectRandom _buildingPositions);
		};

		// Make sure we don't create waypoints in the water
		if (!(surfaceIsWater _waypointPosition) || _allowWaterCreation) then
		{
			_waypoints pushBack [_waypointPosition, "LIMITED", "MOVE", "SAFE"];
		};
	} forEach _crossPoints;

	// Add our final cycle waypoint
	if (!(_waypoints isEqualTo [])) then
	{
		_waypoints pushBack [((_waypoints select 0) select 0), "LIMITED", "CYCLE", "SAFE"];
	};

	// Return the waypoints
	_waypoints
};

/*
	--------------------------
	-- GETBUILDINGPOSITIONS --
	--------------------------

	Gets some building positions
*/
if (toUpper(_type) == "GETBUILDINGPOSITIONS") exitWith
{
	_params params
	[
		"_pos",
		"_rad"
	];

	private
	[
		"_buildings"
	];

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
			};
		};
	} forEach _buildings;

	// If there are no buildings in a given radius, exit with warning message
	if ((count _buildings) == 0) exitWith
	{
		[_scriptTag, 3, "No Buildings in given area, waypoint will be created using default functionality..."] call RS_fnc_LoggingHelper;
		
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
		_buildingPositions = _buildingPositions + ([_building] call BIS_fnc_buildingPositions);
	} forEach _buildings;

	// Return the building positions
	_buildingPositions
};

// Log warning if type is not recognised
[_scriptTag, 2, (format ["Unrecognised type [%1], nothing is being executed!", _type])] call RS_fnc_LoggingHelper;