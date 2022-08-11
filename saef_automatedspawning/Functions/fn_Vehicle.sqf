/*
	fn_Vehicle.sqf

	Description:
		Handles functionality related to vehicles
*/

params
[
	"_type",
	["_params", []]
];

/*
	---------------------------
	-- GETSAFESPAWNPOSITIONS --
	---------------------------

	Gets a safe spawn positions for a vehicle
*/
if (toUpper(_type) == "GETSAFESPAWNPOSITIONS") exitWith
{
	_params params
	[
		"_position",
		"_radius",
		["_target", []]
	];

	// Default the target
	if (_target isEqualTo []) then
	{
		_target = _position;
	};

	private
	[
		"_roads"
	];

	_roads = ["GetRoadPositions", [_position, _radius, _target]] call SAEF_AS_fnc_Vehicle;

	// TODO - Perhaps think about evaluating these road segments as safe places to spawn objects

	// Return all the viable road segments
	_roads
};

/*
	----------------------
	-- GETROADPOSITIONS --
	----------------------

	Gets road positions
*/
if (toUpper(_type) == "GETROADPOSITIONS") exitWith
{
	_params params
	[
		"_position",
		"_radius",
		"_target"
	];

	private
	[
		"_roads",
		"_roadSegments"
	];

	_roads = _position nearRoads _radius;
	_roadSegments = [];

	{
		// Get the road's information
		_x params ["_road"];

		(getRoadInfo _road) params
		[
			"_mapType", 
			"_width", 
			"_isPedestrian", 
			"_texture", 
			"_textureEnd", 
			"_material", 
			"_begPos", 
			"_endPos", 
			"_isBridge"
		];

		// Basic Calculations
		private
		[
			"_direction",
			"_roadPosition"
		];

		_direction = ["GetRoadDirection", [(_road getRelDir _endPos), (_road getRelDir _target)]] call SAEF_AS_fnc_Vehicle;
		_roadPosition = getPos _road;

		// Pushback the road segment
		_roadSegments pushBack (_roadPosition + [_direction]);
	} forEach _roads;

	// Return the Road Segments
	_roadSegments
};

/*
	----------------------
	-- GETROADDIRECTION --
	----------------------

	Gets road direction
*/
if (toUpper(_type) == "GETROADDIRECTION") exitWith
{
	_params params
	[
		"_directionRoadFront",
		"_directionTarget"
	];

	private
	[
		"_directionRoadBack",
		"_differenceToFrontDirection",
		"_differenceToBackDirection"
	];

	if (_directionRoadFront >= 180) then
	{
		_directionRoadBack = _directionRoadFront - 180;
	}
	else
	{
		_directionRoadBack = _directionRoadFront + 180;
	};

	_differenceToFrontDirection = ["GetDirectionDifference", [_directionTarget, _directionRoadFront]] call SAEF_AS_fnc_Vehicle;
	_differenceToBackDirection = ["GetDirectionDifference", [_directionTarget, _directionRoadBack]] call SAEF_AS_fnc_Vehicle;

	private
	[
		"_direction"
	];

	_direction = _directionRoadFront;

	if (_differenceToBackDirection < _differenceToFrontDirection) then
	{
		_direction = _directionRoadBack;
	};

	// Return the direction
	_direction
};

/*
	----------------------------
	-- GETDIRECTIONDIFFERENCE --
	----------------------------

	Gets road direction
*/
if (toUpper(_type) == "GETDIRECTIONDIFFERENCE") exitWith
{
	_params params
	[
		"_directionTarget",
		"_directionRoad"
	];

	private
	[
		"_differenceToDirection"
	];

	if (_directionTarget >= _directionRoad) then
	{
		_differenceToDirection = _directionTarget - _directionRoad;
	}
	else
	{
		_differenceToDirection = _directionRoad - _directionTarget;
	};

	// Return the difference
	_differenceToDirection
};

// Log warning if type is not recognised
["SAEF_AS_fnc_Vehicle", 2, (format ["Unrecognised type [%1], nothing is being executed!", _type])] call RS_fnc_LoggingHelper;