/*
	fn_MarkerTracking.sqf

	Description:
		Handles marker tracking functionality
*/

params
[
	"_type",
	["_params", []]
];

private
[
	"_scriptTag"
];

_scriptTag = "SAEF Marker Tracking";

/*
	----------
	-- INIT --
	----------

	Handles initialisation of global variables
*/
if (toUpper(_type) == "INIT") exitWith
{
	_params params
	[
		["_overrides", []],
		["_timeOverrides", []]
	];

	_overrides params
	[
		["_westOverride", ["ColorBlufor"]],
		["_eastOverride", ["ColorOpfor"]],
		["_indeOverride", ["ColorIndependent"]],
		["_contOverride", ["ColorCiv"]],
		["_mptyOverride", ["ColorBlack"]]
	];

	missionNamespace setVariable ["SAEF_AI_MarkerTracking_MarkerOverrides_West", _westOverride, true];
	missionNamespace setVariable ["SAEF_AI_MarkerTracking_MarkerOverrides_East", _eastOverride, true];
	missionNamespace setVariable ["SAEF_AI_MarkerTracking_MarkerOverrides_Independent", _indeOverride, true];
	missionNamespace setVariable ["SAEF_AI_MarkerTracking_MarkerOverrides_Contested", _contOverride, true];
	missionNamespace setVariable ["SAEF_AI_MarkerTracking_MarkerOverrides_Empty", _mptyOverride, true];

	_timeOverrides params
	[
		["_simulationIncrementalTime", 30]
	];

	missionNamespace setVariable ["SAEF_AI_MarkerTracking_SimulationIncrementalTime", _simulationIncrementalTime, true];
};

/*
	-----------------
	-- HANDLEMULTI --
	-----------------

	Handles multiple positions
*/
if (toUpper(_type) == "HANDLEMULTI") exitWith
{
	_params params
	[
		"_positions",
		["_simulate", false]
	];

	if (_simulate) then
	{
		{
			_x params
			[
				"_id",
				"_simulateSides",
				"_position",
				"_size",
				"_angle",
				"_delay",
				"_time",
				["_precedingSimulation", ""]
			];

			_id = (format ["saef_ai_markertracking_%1", _id]);

			if (_precedingSimulation != "") then
			{
				_precedingSimulation = (format ["saef_ai_markertracking_%1", _precedingSimulation]);
			};

			["Simulate", [_id, _simulateSides, (format ["saef_trackingmarker_simulate_%1", _forEachIndex]), _position, _size, _angle, _delay, _time, _precedingSimulation]] spawn SAEF_AI_fnc_MarkerTracking;
		} forEach _positions;
	}
	else
	{
		{
			_x params
			[
				"_position",
				"_size",
				"_angle"
			];

			["Handle", [(format ["saef_trackingmarker_%1", _forEachIndex]), (format ["SAEF_AI_MarkerTracking_HandleLocation_%1", _forEachIndex]), _position, _size, _angle]] spawn SAEF_AI_fnc_MarkerTracking;
		} forEach _positions;
	};
};

/*
	------------
	-- HANDLE --
	------------

	Handles the core loop of the function per area
*/
if (toUpper(_type) == "HANDLE") exitWith
{
	_params params
	[
		"_markerTag",
		"_handleVariable",
		"_position",
		"_size",
		"_angle"
	];

	// Size must be in multiples of 50
	if ((_size mod 100) != 0) exitWith
	{
		[_scriptTag, 1, (format ["[HANDLE] Position %1 size [%2] must be divisible by 100! Cannot continue...", _position, _size])] call RS_fnc_LoggingHelper;
	};

	missionNamespace setVariable [_handleVariable, true, true];

	[_scriptTag, 0, (format ["[HANDLE] Starting Handler for position %1 using variable [%2]...", _position, _handleVariable])] call RS_fnc_LoggingHelper;

	// Create the markers
	private
	[
		"_markers"
	];

	_markers = ["GenerateMarkers", [_markerTag, _position, _size, _angle]] call SAEF_AI_fnc_MarkerTracking;

	while {(missionNamespace getVariable [_handleVariable, false])} do
	{
		// Retrieve all units once per cycle
		private
		[
			"_allUnits"
		];

		_allUnits = [(allUnits select {(side _x) == EAST}), (allUnits select {(side _x) == WEST}), (allUnits select {(side _x) == INDEPENDENT})];

		// Evaluate each marker
		{
			["HandleMarker", [_forEachIndex, _x, _allUnits]] call SAEF_AI_fnc_MarkerTracking;
			sleep 0.15;
		} forEach _markers;

		sleep 0.15;
	};

	[_scriptTag, 0, (format ["[HANDLE] Ending Handler for position %1 using variable [%2]...", _position, _handleVariable])] call RS_fnc_LoggingHelper;
};

/*
	--------------
	-- SIMULATE --
	--------------

	Simulate mimics the handler but without actual enemy checking, simply uses time to override from one side to another.
	Once the override completes, this simulation stops to save performance...
*/
if (toUpper(_type) == "SIMULATE") exitWith
{
	_params params
	[
		"_simulationId",
		"_simulateSides",
		"_markerTag",
		"_position",
		"_size",
		"_angle",
		"_simulationDelay",
		"_simulationTime",
		["_precedingSimulation", ""]
	];

	_simulateSides params
	[
		"_winningSide",
		"_losingSide"
	];

	private
	[
		"_incrementalTime",
		"_simulationDelay",
		"_simulationHalf",
		"_markers",
		"_markerIncrement"
	];

	_incrementalTime = (missionNamespace getVariable ["SAEF_AI_MarkerTracking_SimulationIncrementalTime", 30]);
	_simulationDelay = ((_simulationDelay * 60) + (random 60));
	_simulationTime = (_simulationTime * (60 / _incrementalTime));

	// Get our markers for this area
	_markers = ["GenerateMarkers", [_markerTag, _position, _size, _angle, _losingSide]] call SAEF_AI_fnc_MarkerTracking;
	_markerIncrement = (count _markers) / _simulationTime;

	// Wait for the previous simulation to complete
	if (_precedingSimulation != "") then
	{
		waitUntil {
			sleep 0.1;
			(missionNamespace getVariable [_precedingSimulation, false])
		};
	};

	sleep _simulationDelay;

	[_scriptTag, 0, (format ["Starting simulation [%1]...", _simulationId])] call RS_fnc_LoggingHelper;

	// Run the simulation - i.e. the second team winning
	for "_i" from 1 to _simulationTime do
	{
		["SimulateMarkerChange", [_markers, (round (_markerIncrement * _i)), _simulateSides]] spawn SAEF_AI_fnc_MarkerTracking;

		sleep _incrementalTime;
	};

	missionNamespace setVariable [_simulationId, true, true];

	[_scriptTag, 0, (format ["Simulation complete [%1]...", _simulationId])] call RS_fnc_LoggingHelper;
};

/*
	--------------------------
	-- SIMULATEMARKERCHANGE --
	--------------------------

	Simulates change to given marker
*/
if (toUpper(_type) == "SIMULATEMARKERCHANGE") exitWith
{
	_params params
	[
		"_markers",
		"_numberToChange",
		"_simulateSides",
		["_invert", false]
	];

	_simulateSides params
	[
		"_winningSide",
		"_losingSide"
	];

	private
	[
		"_eastIsLargest",
		"_westIsLargest",
		"_indeIsLargest",
		"_startValue",
		"_endValue"
	];

	_startValue = 0;
	_endValue = 0;
	_eastIsLargest = false;
	_westIsLargest = false;
	_indeIsLargest = false;

	if (_invert) then
	{
		(["SimulateSideParams", [_losingSide]] call SAEF_AI_fnc_MarkerTracking) params
		[
			"_tEastIsLargest",
			"_tWestIsLargest",
			"_tIndeIsLargest"
		];
		
		_eastIsLargest = _tEastIsLargest;
		_westIsLargest = _tWestIsLargest;
		_indeIsLargest = _tIndeIsLargest;

		_startValue = ((count _markers) - 1);
		_endValue = (_startValue - _numberToChange);

		// Clamp EndValue to 0
		if (_endValue < 0) then
		{
			_endValue = 0;
		};
	}
	else
	{
		(["SimulateSideParams", [_winningSide]] call SAEF_AI_fnc_MarkerTracking) params
		[
			"_tEastIsLargest",
			"_tWestIsLargest",
			"_tIndeIsLargest"
		];
		
		_eastIsLargest = _tEastIsLargest;
		_westIsLargest = _tWestIsLargest;
		_indeIsLargest = _tIndeIsLargest;

		_startValue = 0;
		_endValue = _numberToChange;

		// Clamp EndValue to max index
		if (_endValue > ((count _markers) - 1)) then
		{
			_endValue = ((count _markers) - 1);
		};
	};

	if (_startValue > _endValue) then
	{
		for "_i" from _startValue to _endValue step -1 do
		{
			private
			[
				"_hasChanged"
			];

			_hasChanged = ["HandleMarkerColor", [(_markers select _i), _eastIsLargest, _westIsLargest, _indeIsLargest]] call SAEF_AI_fnc_MarkerTracking;

			if (_hasChanged) then
			{
				sleep 0.1;
			};
		};
	}
	else
	{
		for "_i" from _startValue to _endValue do
		{
			private
			[
				"_hasChanged"
			];

			_hasChanged = ["HandleMarkerColor", [(_markers select _i), _eastIsLargest, _westIsLargest, _indeIsLargest]] call SAEF_AI_fnc_MarkerTracking;

			if (_hasChanged) then
			{
				sleep 0.1;
			};
		};
	};
};

/*
	------------------------
	-- SIMULATESIDEPARAMS --
	------------------------

	Simulates side to win params
*/
if (toUpper(_type) == "SIMULATESIDEPARAMS") exitWith
{
	_params params
	[
		"_side"
	];

	private
	[
		"_eastIsLargest",
		"_westIsLargest",
		"_indeIsLargest"
	];

	_eastIsLargest = false;
	_westIsLargest = false;
	_indeIsLargest = false;

	if (_side == EAST) then
	{
		_eastIsLargest = true;
	};

	if (_side == WEST) then
	{
		_westIsLargest = true;
	};

	if (_side == INDEPENDENT) then
	{
		_indeIsLargest = true;
	};

	[_eastIsLargest, _westIsLargest, _indeIsLargest]
};

/*
	------------------
	-- HANDLEMARKER --
	------------------

	Handles given marker
*/
if (toUpper(_type) == "HANDLEMARKER") exitWith
{
	_params params
	[
		"_index",
		"_marker",
		"_allUnits"
	];

	_allUnits params
	[
		"_allEastUnits",
		"_allWestUnits",
		"_allIndeUnits"
	];

	private
	[
		"_eastInside",
		"_westInside",
		"_indeInside"
	];

	_eastInside = _allEastUnits inAreaArray [(markerPos _marker), -50, -50, (markerDir _marker), false];
	_westInside = _allWestUnits inAreaArray [(markerPos _marker), -50, -50, (markerDir _marker), false];
	_indeInside = _allIndeUnits inAreaArray [(markerPos _marker), -50, -50, (markerDir _marker), false];

	// We're going to preserve the marker state if there is nothing inside of this
	if ((_eastInside isEqualTo []) && (_westInside isEqualTo []) && (_indeInside isEqualTo [])) exitWith {};

	private
	[
		"_eastIsLargest",
		"_westIsLargest",
		"_indeIsLargest"
	];

	_eastIsLargest = ((count _eastInside) > (count _westInside)) && ((count _eastInside) > (count _indeInside));
	_westIsLargest = ((count _westInside) > (count _eastInside)) && ((count _westInside) > (count _indeInside));
	_indeIsLargest = ((count _indeInside) > (count _eastInside)) && ((count _indeInside) > (count _westInside));

	["HandleMarkerColor", [_marker, _eastIsLargest, _westIsLargest, _indeIsLargest]] call SAEF_AI_fnc_MarkerTracking;
};

/*
	-----------------------
	-- HANDLEMARKERCOLOR --
	-----------------------

	Handles given marker's color changes
*/
if (toUpper(_type) == "HANDLEMARKERCOLOR") exitWith
{
	_params params
	[
		"_marker",
		"_eastIsLargest",
		"_westIsLargest",
		"_indeIsLargest"
	];

	private
	[
		"_markerColor"
	];

	_markerColor = "";

	// If they're all not the largest, this is contested
	if (!_eastIsLargest && !_westIsLargest && !_indeIsLargest) then
	{
		(missionNamespace getVariable ["SAEF_AI_MarkerTracking_MarkerOverrides_Contested", []]) params [["_tMarkerColor", "ColorCiv"]];
		_markerColor = _tMarkerColor;
	}
	else
	{
		if (_eastIsLargest) then
		{
			(missionNamespace getVariable ["SAEF_AI_MarkerTracking_MarkerOverrides_East", []]) params [["_tMarkerColor", "ColorOpfor"]];
			_markerColor = _tMarkerColor;
		};

		if (_westIsLargest) then
		{
			(missionNamespace getVariable ["SAEF_AI_MarkerTracking_MarkerOverrides_West", []]) params [["_tMarkerColor", "ColorBlufor"]];
			_markerColor = _tMarkerColor;
		};

		if (_indeIsLargest) then
		{
			(missionNamespace getVariable ["SAEF_AI_MarkerTracking_MarkerOverrides_Independent", []]) params [["_tMarkerColor", "ColorIndependent"]];
			_markerColor = _tMarkerColor;
		};
	};

	// We should ensure we don't make any unnecessary changes
	if (toLower(markerColor _marker) != toLower(_markerColor)) exitWith
	{
		_marker setMarkerColor _markerColor;

		// Return that we have changed it
		true
	};

	false
};

/*
	---------------------
	-- GENERATEMARKERS --
	---------------------

	Generates markers for the location given the marker tag and location
*/
if (toUpper(_type) == "GENERATEMARKERS") exitWith
{
	_params params
	[
		"_markerTag",
		"_position",
		"_size",
		"_angle",
		["_sideToStart", CIVILIAN]
	];

	// Build location grid
	private
	[
		"_radialIterations",
		"_startingPoint",
		"_grid"
	];

	_radialIterations = ceil ((_size / 75) / 2);
	_startingPoint = _position getPos [((_radialIterations * 75) - 40), (_angle + 180)];
	_grid = [];

	for "_i" from -(_radialIterations - 1) to _radialIterations do
	{
		private
		[
			"_row",
			"_rowStartingPoint"
		];

		_row = [];
		_rowStartingPoint = _startingPoint;

		for "_j" from -(_radialIterations - 1) to (_radialIterations - (ceil (_radialIterations * 0.25))) do
		{
			(_rowStartingPoint getPos [((_radialIterations * 75) - 70.5), (_angle + 90)]) params
			[
				"_xPos",
				"_yPos",
				"_zPos"
			];

			_row pushBack [_xPos, _yPos, 0];

			// Move the row starting point 86 meters left
			_rowStartingPoint = _rowStartingPoint getPos [86, (_angle - 90)];
		};

		_grid pushBack _row;

		// Move the starting point 75 meters forward
		_startingPoint = _startingPoint getPos [75, _angle];

		if ((_i mod 2) == 0) then
		{
			_startingPoint = _startingPoint getPos [43, (_angle + 90)];
		}
		else
		{
			_startingPoint = _startingPoint getPos [43, (_angle - 90)];
		};
	};

	private
	[
		"_markers",
		"_index",
		"_outerIndex"
	];

	_outerIndex = 0;
	_markers = [];
	_index = 0;

	{
		private
		[
			"_row",
			"_rowIndex"
		];

		_row = _x;
		_rowIndex = _forEachIndex;

		if ((_rowIndex mod 2) == 0) then
		{
			_outerIndex = 0;
		}
		else
		{
			_outerIndex = 1;
		};

		{
			private
			[
				"_position",
				"_positionIndex",
				"_buildings",
				"_buildingsInArea"
			];

			_position = _x;
			_positionIndex = _forEachIndex;

			_buildings = nearestObjects [_position, ["building"], 80];
			_buildingsInArea = _buildings inAreaArray [_position, -50, -50, _angle, false];

			if (!(_buildingsInArea isEqualTo [])) then
			{
				private
				[
					"_markerAlpha",
					"_markerName",
					"_markerColor"
				];

				_markerName = (format ["%1_%2", _markerTag, _index]);
				_markerAlpha = 0.5;

				if ((_outerIndex mod 2) == 0) then
				{
					_markerAlpha = 0.75;
				};

				_markerColor = ["GetMarkerColorSide", [_sideToStart]] call SAEF_AI_fnc_MarkerTracking;

				_marker = createMarkerLocal [_markerName, _position];
				_marker setMarkerShapeLocal "ELLIPSE";
				_marker setMarkerSizeLocal [-50, -50];
				_marker setMarkerBrushLocal "DiagGrid";
				_marker setMarkerDirLocal _angle;
				_marker setMarkerAlphaLocal _markerAlpha;
				_marker setMarkerColor _markerColor;

				_markers pushBack _marker;

				_index = _index + 1;
			};

			_outerIndex = _outerIndex + 1;
		} forEach _row;
	} forEach _grid;

	// Return the markers
	_markers
};

/*
	------------------------
	-- GETMARKERCOLORSIDE --
	------------------------

	Gets the marker color for a particular side
*/
if (toUpper(_type) == "GETMARKERCOLORSIDE") exitWith
{
	_params params
	[
		"_side"
	];

	// Build location grid
	private
	[
		"_markerColor"
	];

	(missionNamespace getVariable ["SAEF_AI_MarkerTracking_MarkerOverrides_Empty", []]) params [["_tMarkerColor", "ColorBlack"]];
	_markerColor = _tMarkerColor;
	
	if (_side == EAST) then
	{
		(missionNamespace getVariable ["SAEF_AI_MarkerTracking_MarkerOverrides_East", []]) params [["_tMarkerColor", "ColorOpfor"]];
		_markerColor = _tMarkerColor;
	};

	if (_side == WEST) then
	{
		(missionNamespace getVariable ["SAEF_AI_MarkerTracking_MarkerOverrides_West", []]) params [["_tMarkerColor", "ColorBlufor"]];
		_markerColor = _tMarkerColor;
	};

	if (_side == INDEPENDENT) then
	{
		(missionNamespace getVariable ["SAEF_AI_MarkerTracking_MarkerOverrides_Independent", []]) params [["_tMarkerColor", "ColorIndependent"]];
		_markerColor = _tMarkerColor;
	};

	// Return the marker color
	_markerColor
};

// Log warning if type is not recognised
[_scriptTag, 2, (format ["Unrecognised type [%1], nothing is being executed!", _type])] call RS_fnc_LoggingHelper;