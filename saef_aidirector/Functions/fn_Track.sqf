/*
	fn_Track.sqf

	Description:
		Handles the settings and methods related to tracking data
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

_scriptTag = "SAEF AID Track";

/*
	---------
	-- GET --
	---------

	Gets value from the tracked variable
*/
if (toUpper(_type) == "GET") exitWith
{
	_params params
	[
		"_dataType"
	];

	private
	[
		"_trackedVariable",
		"_trackedValue"
	];

	_trackedVariable = ["GetTrackedVariable", [_dataType]] call SAEF_AID_fnc_Track;
	_trackedValue = missionNamespace getVariable [_trackedVariable, 0];

	// Return the tracked value and variable used to track it
	[_trackedVariable, _trackedValue]
};

/*
	------------------------------
	-- GETALLWITHTYPESEPARATION --
	------------------------------

	Gets all variables with separation based on given array
*/
if (toUpper(_type) == "GETALLWITHTYPESEPARATION") exitWith
{
	_params params
	[
		"_typesToSeparate"
	];

	private
	[
		"_trackedVariables"
	];

	_trackedVariables = [];

	{
		if (["SAEF_AID_TrackedVariable", _x] call BIS_fnc_inString) then
		{
			_trackedVariables pushBack _x;
		};
	} forEach (allVariables missionNamespace);

	private
	[
		"_separatedTrackedVariables"
	];

	_separatedTrackedVariables = [];

	{
		_x params
		[
			"_typeToSeparate",
			"_typeToSeparateName"
		];

		private
		[
			"_currentTrackedVariables"
		];

		_currentTrackedVariables = [];

		{
			private 
			[
				"_trackedVariable"
			];

			_trackedVariable = _x;

			if ([_typeToSeparate, _trackedVariable] call BIS_fnc_inString) then
			{
				private
				[
					"_trackedValue"
				];

				_trackedValue = missionNamespace getVariable [_trackedVariable, 0];

				_currentTrackedVariables pushBack [((_trackedVariable splitString "_") select 3), _trackedValue];
			};
		} forEach _trackedVariables;

		_separatedTrackedVariables pushBack [_typeToSeparateName, _currentTrackedVariables];
	} forEach _typesToSeparate;

	// Return our separated tracked variables
	_separatedTrackedVariables
};

/*
	----------------------------------
	-- GETALLWITHTYPESEPARATIONJSON --
	----------------------------------

	Gets all variables with separation based on given array
*/
if (toUpper(_type) == "GETALLWITHTYPESEPARATIONJSON") exitWith
{
	_params params
	[
		"_typesToSeparate"
	];

	private
	[
		"_separatedTrackedVariables"
	];

	_separatedTrackedVariables = ["GetAllWithTypeSeparation", [_typesToSeparate]] call SAEF_AID_fnc_Track;

	private
	[
		"_jsonResultArray"
	];

	_jsonResultArray = [];

	{
		_x params
		[
			"_size",
			"_trackedVariables"
		];

		_jsonResultArray pushBack (["BuildItem", [_size, (["BuildItems", _trackedVariables] call SAEF_LOG_fnc_JsonLogger), true]] call SAEF_LOG_fnc_JsonLogger);
	} forEach _separatedTrackedVariables;

	// Return the JSON result array
	_jsonResultArray
};

/*
	---------
	-- ADD --
	---------

	Adds the value to the tracked variable
*/
if (toUpper(_type) == "ADD") exitWith
{
	_params params
	[
		"_dataType",
		"_value"
	];

	(["Get", [_dataType]] call SAEF_AID_fnc_Track) params
	[
		"_trackedVariable",
		"_trackedValue"
	];

	// Increment the tracked value
	_trackedValue = _trackedValue + _value;

	// Set the tracked variable
	missionNamespace setVariable [_trackedVariable, _trackedValue, true];
};

/*
	---------
	-- SET --
	---------

	Sets the value of a tracked variable
*/
if (toUpper(_type) == "SET") exitWith
{
	_params params
	[
		"_dataType",
		"_value"
	];

	(["Get", [_dataType]] call SAEF_AID_fnc_Track) params
	[
		"_trackedVariable",
		"_trackedValue"
	];

	// Increment the tracked value
	_trackedValue = _value;

	// Set the tracked variable
	missionNamespace setVariable [_trackedVariable, _trackedValue, true];
};

/*
	-------------------------
	-- GETTRACKEDVARIABLE --
	-------------------------

	Gets the variable string for the tracked variable
*/
if (toUpper(_type) == "GETTRACKEDVARIABLE") exitWith
{
	_params params
	[
		"_dataType"
	];

	// Return the tracked variable
	(format ["SAEF_AID_TrackedVariable_%1", _dataType]);
};

// Log warning if type is not recognised
[_scriptTag, 2, (format ["Unrecognised type [%1], nothing is being executed!", _type])] call RS_fnc_LoggingHelper;