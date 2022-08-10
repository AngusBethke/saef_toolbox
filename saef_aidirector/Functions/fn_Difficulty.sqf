/*
	fn_Difficulty.sqf

	Description:
		Handles the settings and methods related to the difficulty
*/

params
[
	"_type",
	["_params", []]
];

// Set the available difficulty levels
private
[
	"_difficultyLevels"
];

_difficultyLevels = ["EASY", "NORMAL", "HARD", "INSANE"]; 

/*
	---------
	-- GET --
	---------

	Gets the difficulty
*/
if (toUpper(_type) == "GET") exitWith
{
	// Return the difficulty
	(missionNamespace getVariable ["SAEF_AID_Difficulty", "NORMAL"])
};

/*
	---------
	-- SET --
	---------

	Sets the difficulty
*/
if (toUpper(_type) == "SET") exitWith
{
	_params params
	[
		["_difficulty", "Normal"]
	];

	_difficulty = toUpper(_difficulty);

	if (!(_difficulty in _difficultyLevels)) exitWith
	{
		["SAEF_AID_fnc_Difficulty", 1, (format ["[SET] Unrecognised difficulty [%1], value cannot be set!", _difficulty])] call RS_fnc_LoggingHelper;
	};

	missionNamespace setVariable ["SAEF_AID_Difficulty", _difficulty, true];
};

/*
	----------------
	-- GETAICOUNT --
	----------------

	Determines the number of AI to spawn based on area size and difficulty
*/
if (toUpper(_type) == "GETAICOUNT") exitWith
{
	_params params
	[
		"_position",
		["_areaSize", "MED"],
		["_clampByPositions", false]
	];

	private
	[
		"_min",
		"_max",
		"_radius"
	];

	_min = 0;
	_max = 0;
	_radius = 0;

	switch toUpper(_areaSize) do
	{
		case "SML": {
			(missionNamespace getVariable ["SAEF_AreaSpawner_Small_Params", []]) params
			[
				["_tBaseAICount", 4],
				["_tBaseAreaSize", 40],
				["_tBaseActivationRange", 500]
			];

			_min = 2;
			_max = 4;
			_radius = _tBaseAreaSize;
		};

		case "MED": {
			(missionNamespace getVariable ["SAEF_AreaSpawner_Medium_Params", []]) params
			[
				["_tBaseAICount", 8],
				["_tBaseAreaSize", 50],
				["_tBaseActivationRange", 500]
			];

			_min = 4;
			_max = 12;
			_radius = _tBaseAreaSize;
		};

		case "LRG": {
			(missionNamespace getVariable ["SAEF_AreaSpawner_Large_Params", []]) params
			[
				["_tBaseAICount", 12],
				["_tBaseAreaSize", 60],
				["_tBaseActivationRange", 500]
			];

			_min = 12;
			_max = 20;
			_radius = _tBaseAreaSize;
		};

		default {
			["SAEF_AID_fnc_Difficulty", 1, (format ["[GETAICOUNT] Unrecognised area size [%1], ai count cannot be determined!", _areaSize])] call RS_fnc_LoggingHelper;
		};
	};
	
	// Determine the ai count
	private
	[
		"_count"
	];

	_count = ["GetAiCountMinMax", [_position, _radius, _min, _max, _clampByPositions]] call SAEF_AID_fnc_Difficulty;

	// Return the count
	_count
};

/*
	----------------------
	-- GETAICOUNTMINMAX --
	----------------------

	Determines the number of AI to spawn based on min count, max count and difficulty
*/
if (toUpper(_type) == "GETAICOUNTMINMAX") exitWith
{
	_params params
	[
		"_position",
		["_radius", 50]
		["_min", 0],
		["_max", 0],
		["_clampByPositions", false]
	];

	if ((_min == 0) || (_max == 0)) exitWith
	{
		["SAEF_AID_fnc_Difficulty", 2, (format ["[GETAICOUNTMINMAX] Either min [%1] or max [%2] were 0, cannot determine AI count!", _min, _max])] call RS_fnc_LoggingHelper;

		// Return Zero
		0
	};

	if (_min > _max) exitWith
	{
		["SAEF_AID_fnc_Difficulty", 2, (format ["[GETAICOUNTMINMAX] Either min [%1] or max [%2] are out of range, cannot determine AI count!", _min, _max])] call RS_fnc_LoggingHelper;

		// Return Zero
		0
	}

	// Determine the ai count
	private
	[
		"_count",
		"_difficulty"
	];

	_difficulty = (["Get"] call SAEF_AID_fnc_Difficulty);

	switch (_difficulty) do
	{
		// Easy disregards all other settings and returns the lowest number
		case "EASY": {
			_count = _min;
		};

		case "NORMAL": {
			private
			[
				"_difference",
				"_newMax"
			];

			_newMax = (_min + ceil ((_max - _min) / 2));
			_difference = (_newMax - _min);

			// Determine count base on player status factor
			_count = (_min + round (_difference * (["GetPlayerStatusFactor", [_position]] call SAEF_AID_fnc_Player)));

			// Clamp count based on min and max
			if (_count > _newMax) then
			{
				_count = _newMax;
			};

			if (_count < _min) then
			{
				_count = _min;
			};
		};

		case "HARD": {
			private
			[
				"_difference",
				"_newMin"
			];

			_newMin = (_min + ceil ((_max - _min) / 2));
			_difference = (_max - _newMin);

			// Determine count base on player status factor
			_count = (_newMin + round (_difference * (["GetPlayerStatusFactor", [_position]] call SAEF_AID_fnc_Player)));

			// Clamp count based on min and max
			if (_count > _max) then
			{
				_count = _max;
			};

			if (_count < _newMin) then
			{
				_count = _newMin;
			};
		};

		// Insane disregards all other settings and returns the highest number
		case "INSANE": {
			_count = _max;
		};

		default {
			["SAEF_AID_fnc_Difficulty", 2, (format ["[GETAICOUNTMINMAX] Unrecognised difficulty [%1], cannot determine AI count!",_difficulty])] call RS_fnc_LoggingHelper;
			_count = 0;
		};
	};

	if (_clampByPositions) then
	{
		// Clamp the count based on number of building positions available
		private
		[
			"_positions"
		];

		_positions = ["GetUniqueBuildingPositions", [_position, _radius, _count]] call SAEF_AID_fnc_Difficulty;

		if (_count > (count _positions)) then
		{
			_count = (count _positions);
		};
	};

	// Return the count
	_count
};

/*
	--------------------------------
	-- GETUNIQUEBUILDINGPOSITIONS --
	--------------------------------

	Determines the number of AI to spawn based on min count, max count and difficulty
*/
if (toUpper(_type) == "GETUNIQUEBUILDINGPOSITIONS") exitWith
{
	_params params
	[
		"_position",
		"_radius",
		"_count"
	];

	if (_count == 0) exitWith
	{
		["SAEF_AID_fnc_Difficulty", 2, "[GETUNIQUEBUILDINGPOSITIONS] AI count is zero, cannot return any building positions!"] call RS_fnc_LoggingHelper;

		// Return empty array if the count is zero
		[]
	};

	private
	[
		"_uniquePositions"
	];

	_uniquePositions = [];

	{
		_uniquePositions pushBackUnique _x;
	} forEach ([_position, _radius, _count] call RS_DS_fnc_GetGarrisonPositions);

	// Return unique positions
	_uniquePositions
};

// Log warning if type is not recognised
["SAEF_AID_fnc_Difficulty", 2, (format ["Unrecognised type [%1], nothing is being executed!", _type])] call RS_fnc_LoggingHelper;