/*
	fn_HelicopterInsertion_Waypoints.sqf

	Description:
		Creates the waypoints for the helicopter insertion
*/

params
[
	"_vehicle",
	"_maybeNotPilot",
	"_waypointObjectString",
	"_canDeployFastRope"
];

if (isNil _waypointObjectString) exitWith
{
	["SAEF Helicopter Insertion", 4, (format ["Object [%1] does not exist! Cannot generate waypoints!", _waypointObjectString])] call RS_fnc_LoggingHelper;
};

private
[
	"_waypointObject",
	"_waypoints"
];

_waypointObject = (call compile _waypointObjectString);
_waypoints =
[
	[
		_waypointObject getRelPos [600, 180],
		false
	],
	[
		_waypointObject getRelPos [300, 180],
		true
	],
	[
		(getPos _waypointObject),
		true
	]
];

// Create insertion waypoints
private
[
	"_inverseWaypoints"
];

_inverseWaypoints = [[(position _vehicle), false]];

{
	_x params 
	[
		"_position",
		"_limited"
	];

	// Is last waypoint
	private
	[
		"_isLastWaypoint",
		"_isFirstWaypoint"
	];

	_isFirstWaypoint = (_forEachIndex == 0);
	_isLastWaypoint = (_forEachIndex == ((count _waypoints) - 1));

	// Add to our inverse waypoints
	if (!_isLastWaypoint) then
	{
		_inverseWaypoints = [[_position, _limited]] + _inverseWaypoints;
	};

	// Create the waypoint
	private
	[
		"_waypoint"
	];

	_waypoint = (group _maybeNotPilot) addWaypoint [_position, _forEachIndex];
	_waypoint setWaypointBehaviour "CARELESS";
	
	if (_limited) then
	{
		_waypoint setWaypointSpeed "LIMITED";
	}
	else
	{
		_waypoint setWaypointSpeed "NORMAL";
	};

	if (_isFirstWaypoint) then
	{
		_waypoint setWaypointStatements ["true", "(vehicle this) setVariable ['SAEF_ASA_INS_HelicopterOnApproach', true, true];"];
	};

	if (_isLastWaypoint) then
	{
		private
		[
			"_height"
		];

		_height = (_position select 2);

		if (_canDeployFastRope) then
		{
			_waypoint setWaypointType "MOVE";
			_waypoint setWaypointStatements ["(vehicle this) getVariable ['SAEF_ASA_INS_FastRopeComplete', false]", "(vehicle this) setVariable ['SAEF_ASA_INS_InsertionComplete', true, true];"];
			_height = 15;
		}
		else
		{
			_waypoint setWaypointType "TR UNLOAD";
			_waypoint setWaypointStatements ["([(vehicle this)] call SAEF_ASA_INS_fnc_HelicopterInsertion_NoPlayersInVehicle)", "(vehicle this) setVariable ['SAEF_ASA_INS_InsertionComplete', true, true];"];
			_height = 1.5;
		};

		// Create a landing pad if one doesn't exist already
		private
		[
			"_landingPadName"
		];

		_landingPadName = format ["%1_LandingPad", (vehicleVarName _vehicle)];

		if (isNil _landingPadName) then
		{
			private
			[
				"_landingPad"
			];

			_landingPad = createVehicle ["Land_HelipadEmpty_F", [(_position select 0), (_position select 1), _height], [], 0, "CAN_COLLIDE"];
			[_landingPad, _landingPadName] call SAEF_VEH_fnc_RnR_GlobalRename;
		}
		else
		{
			private
			[
				"_landingPad"
			];

			_landingPad = (call compile _landingPadName);
			_landingPad setPos [(_position select 0), (_position select 1), _height];
		};

		if (_canDeployFastRope) then
		{
			[_vehicle, _position, _maybeNotPilot, (call compile _landingPadName)] spawn SAEF_ASA_INS_fnc_HelicopterInsertion_HandleFastRope;
		}
		else
		{
			[_vehicle, _position, _maybeNotPilot, (call compile _landingPadName)] spawn SAEF_ASA_INS_fnc_HelicopterInsertion_HandleLanding;
		};
	}
	else
	{
		_waypoint setWaypointType "MOVE";
	};
} forEach _waypoints;

// Create inverse waypoints
{
	_x params 
	[
		"_position",
		"_limited"
	];

	// Is last waypoint
	private
	[
		"_isLastWaypoint"
	];
	
	_isLastWaypoint = (_forEachIndex == ((count _inverseWaypoints) - 1));

	private
	[
		"_waypoint"
	];

	_waypoint = (group _maybeNotPilot) addWaypoint [_position, _forEachIndex];
	_waypoint setWaypointBehaviour "CARELESS";
	_waypoint setWaypointType "MOVE";
	
	if (_limited) then
	{
		_waypoint setWaypointSpeed "LIMITED";
	}
	else
	{
		_waypoint setWaypointSpeed "NORMAL";
	};

	if (_isLastWaypoint) then
	{
		_waypoint setWaypointScript "A3\functions_f\waypoints\fn_wpLand.sqf";
	};
} forEach _inverseWaypoints;