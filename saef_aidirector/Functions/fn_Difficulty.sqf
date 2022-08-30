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

// Set the script tag and available difficulty levels
private
[
	"_scriptTag",
	"_difficultyLevels"
];

_scriptTag = "SAEF AID Difficulty";
_difficultyLevels = ["EASY", "NORMAL", "HARD", "INSANE"]; 

/*
	---------
	-- GET --
	---------

	Gets the difficulty
*/
if (toUpper(_type) == "GET") exitWith
{
	// We clamp the difficulty by player number first
	(["ClampDifficultyByPlayerNumber", [((missionNamespace getVariable ["SAEF_AID_Difficulty", "NORMAL"])), (["GetCountWithDifficulty", [(missionNamespace getVariable ["SAEF_AID_Difficulty", "NORMAL"])]] call SAEF_AID_fnc_Difficulty)]] call SAEF_AID_fnc_Difficulty)
		params 
		[
			"_difficulty",
			"_difficultyCount"
		];

	// Clamped difficulty can still be overridden by max and min
	private
	[
		"_maxDifficulty",
		"_minDifficulty"
	];

	_maxDifficulty = ["GetMaxDifficulty"] call SAEF_AID_fnc_Difficulty;
	_minDifficulty = ["GetMinDifficulty"] call SAEF_AID_fnc_Difficulty;

	if ((_maxDifficulty != "") || (_minDifficulty != "")) then
	{
		if (_maxDifficulty != "") then
		{
			private
			[
				"_maxDifficultyCount"
			];

			_maxDifficultyCount = ["GetCountWithDifficulty", [_maxDifficulty]] call SAEF_AID_fnc_Difficulty;

			if (_difficultyCount > _maxDifficultyCount) then
			{
				["SAEF_AID_fnc_Difficulty", 3, (format ["[GET] Difficulty [%1] is higher than max difficulty [%2], returning the max...", _difficulty, _maxDifficulty])] call RS_fnc_LoggingHelper;
				_difficulty = _maxDifficulty;
			};
		};

		if (_minDifficulty != "") then
		{
			private
			[
				"_minDifficultyCount"
			];

			_minDifficultyCount = ["GetCountWithDifficulty", [_minDifficulty]] call SAEF_AID_fnc_Difficulty;

			if (_difficultyCount < _minDifficultyCount) then
			{
				["SAEF_AID_fnc_Difficulty", 3, (format ["[GET] Difficulty [%1] is lower than min difficulty [%2], returning the min...", _difficulty, _minDifficulty])] call RS_fnc_LoggingHelper;
				_difficulty = _minDifficulty;
			};
		};
	};
	
	// Return the difficulty
	_difficulty
};

/*
	----------------------
	-- GETMAXDIFFICULTY --
	----------------------

	Gets the max difficulty
*/
if (toUpper(_type) == "GETMAXDIFFICULTY") exitWith
{
	// Return the max difficulty
	(missionNamespace getVariable ["SAEF_AID_MaxDifficulty", ""])
};

/*
	----------------------
	-- GETMINDIFFICULTY --
	----------------------

	Gets the min difficulty
*/
if (toUpper(_type) == "GETMINDIFFICULTY") exitWith
{
	// Return the min difficulty
	(missionNamespace getVariable ["SAEF_AID_MinDifficulty", ""])
};

/*
	--------------
	-- GETCOUNT --
	--------------

	Gets the difficulty and its count
*/
if (toUpper(_type) == "GETCOUNT") exitWith
{
	private
	[
		"_difficulty",
		"_difficultyCount"
	];

	_difficulty = toUpper(["Get"] call SAEF_AID_fnc_Difficulty);
	_difficultyCount = ["GetCountWithDifficulty", [_difficulty]] call SAEF_AID_fnc_Difficulty;

	// Return the difficulty
	[_difficulty, _difficultyCount]
};

/*
	----------------------------
	-- GETCOUNTWITHDIFFICULTY --
	----------------------------

	Gets the difficulty count
*/
if (toUpper(_type) == "GETCOUNTWITHDIFFICULTY") exitWith
{
	_params params
	[
		"_difficulty"
	];

	private
	[
		"_difficultyCount"
	];

	_difficultyCount = 0;
	
	{
		if (_difficulty == _x) then
		{
			_difficultyCount = (_forEachIndex + 1);
		};
	} forEach _difficultyLevels;

	// Return the difficulty count
	_difficultyCount
};

/*
	------------------
	-- GETAMMOSETUP --
	------------------

	Gets the ammo setup
*/
if (toUpper(_type) == "GETAMMOSETUP") exitWith
{
	// Return the ammo setup
	(missionNamespace getVariable ["SAEF_AID_AmmoSetup", [180, 45, 1]])
};

/*
	-----------------------------------
	-- CLAMPDIFFICULTYBYPLAYERNUMBER --
	-----------------------------------

	Clamps the difficulty by player number
*/
if (toUpper(_type) == "CLAMPDIFFICULTYBYPLAYERNUMBER") exitWith
{
	_params params
	[
		["_difficulty", "Normal"],
		["_difficultyCount", 2]
	];

	private
	[
		"_players",
		"_clamped"
	];

	_players = ([true, true] call RS_PLYR_fnc_GetTruePlayers);
	_clamped = false;

	// Clamp max difficulty to hard if there are less than or equal to 12 but more than 8 players
	if (((count _players) <= 12) && ((count _players) > 8)) then
	{
		if (_difficultyCount > 3) then
		{
			_difficultyCount = 3;
			_difficulty = (_difficultyLevels select (_difficultyCount - 1));
			_clamped = true;
		};
	};

	// Clamp max difficulty to normal if there are less than or equal to 8 but more than 4 players
	if (((count _players) <= 8) && ((count _players) > 4)) then
	{
		if (_difficultyCount > 2) then
		{
			_difficultyCount = 2;
			_difficulty = (_difficultyLevels select (_difficultyCount - 1));
			_clamped = true;
		};
	};

	// Clamp max difficulty to easy if there are less than or equal to 8 but more than 4 players
	if ((count _players) <= 4) then
	{
		if (_difficultyCount > 1) then
		{
			_difficultyCount = 1;
			_difficulty = (_difficultyLevels select (_difficultyCount - 1));
			_clamped = true;
		};
	};

	if (_clamped) then
	{
		["SAEF_AID_fnc_Difficulty", 3, (format ["[CLAMPDIFFICULTYBYPLAYERNUMBER] Clamping difficulty to [%1] in order to match the number of players [%2]...", _difficulty, (count _players)])] call RS_fnc_LoggingHelper;
	};

	// Default is to return the given difficulty and count
	[_difficulty, _difficultyCount]
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

	[_scriptTag, 3, (format ["Setting the difficulty: [%1]", _difficulty])] call RS_fnc_LoggingHelper;

	missionNamespace setVariable ["SAEF_AID_Difficulty", _difficulty, true];
};

/*
	----------------------
	-- SETMAXDIFFICULTY --
	----------------------

	Sets the max difficulty
*/
if (toUpper(_type) == "SETMAXDIFFICULTY") exitWith
{
	_params params
	[
		["_difficulty", "Insane"]
	];

	_difficulty = toUpper(_difficulty);

	if (!(_difficulty in _difficultyLevels)) exitWith
	{
		["SAEF_AID_fnc_Difficulty", 1, (format ["[SETMAXDIFFICULTY] Unrecognised difficulty [%1], value cannot be set!", _difficulty])] call RS_fnc_LoggingHelper;
	};

	missionNamespace setVariable ["SAEF_AID_MaxDifficulty", _difficulty, true];
};

/*
	----------------------
	-- SETMINDIFFICULTY --
	----------------------

	Sets the min difficulty
*/
if (toUpper(_type) == "SETMINDIFFICULTY") exitWith
{
	_params params
	[
		["_difficulty", "Easy"]
	];

	_difficulty = toUpper(_difficulty);

	if (!(_difficulty in _difficultyLevels)) exitWith
	{
		["SAEF_AID_fnc_Difficulty", 1, (format ["[SETMINDIFFICULTY] Unrecognised difficulty [%1], value cannot be set!", _difficulty])] call RS_fnc_LoggingHelper;
	};

	missionNamespace setVariable ["SAEF_AID_MinDifficulty", _difficulty, true];
};

/*
	----------------------
	-- SETBYRECOMMENDED --
	----------------------

	Sets the difficulty based on a recommendation array
*/
if (toUpper(_type) == "SETBYRECOMMENDED") exitWith
{
	_params params
	[
		["_recDifficulties", []]
	];

	private
	[
		"_easyCount",
		"_normalCount",
		"_hardCount",
		"_insaneCount"
	];

	_easyCount = 0;
	_normalCount = 0;
	_hardCount = 0;
	_insaneCount = 0;

	{
		switch toUpper(_x) do
		{
			case "EASY": {
				_easyCount = _easyCount + 1;
			};

			case "NORMAL": {
				_normalCount = _normalCount + 1;
			};

			case "HARD": {
				_hardCount = _hardCount + 1;
			};

			case "INSANE": {
				_insaneCount = _insaneCount + 1;
			};

			default {
				["SAEF_AID_fnc_Difficulty", 1, (format ["[SETBYRECOMMENDED] Unrecognised difficulty [%1]!", _x])] call RS_fnc_LoggingHelper;
			};
		};
	} forEach _recDifficulties;

	private
	[
		"_difficultyArray",
		"_selectedDifficulty"
	];

	_difficultyArray = [_easyCount, _normalCount, _hardCount, _insaneCount];
	_difficultyArray sort false;

	_selectedDifficulty = (_difficultyArray select 0);

	if (_easyCount == _selectedDifficulty) exitWith
	{
		["SET", ["Easy"]] call SAEF_AID_fnc_Difficulty;
	};

	if (_normalCount == _selectedDifficulty) exitWith
	{
		["SET", ["Normal"]] call SAEF_AID_fnc_Difficulty;
	};

	if (_hardCount == _selectedDifficulty) exitWith
	{
		["SET", ["Hard"]] call SAEF_AID_fnc_Difficulty;
	};

	if (_insaneCount == _selectedDifficulty) exitWith
	{
		["SET", ["Insane"]] call SAEF_AID_fnc_Difficulty;
	};
};

/*
	------------------
	-- SETAMMOSETUP --
	------------------

	Sets the ammo setup
*/
if (toUpper(_type) == "SETAMMOSETUP") exitWith
{
	_params params
	[
		"_primaryWeaponAmmo",
		"_secondaryWeaponAmmo",
		"_launcherWeaponAmmo"
	];

	missionNamespace setVariable ["SAEF_AID_AmmoSetup", [_primaryWeaponAmmo, _secondaryWeaponAmmo, _launcherWeaponAmmo], true];
};

/*
	-----------------------
	-- GETAICOUNTFORAREA --
	-----------------------

	Determines the number of AI to spawn based on area size and difficulty
*/
if (toUpper(_type) == "GETAICOUNTFORAREA") exitWith
{
	_params params
	[
		"_marker",
		"_areaType",
		"_count"
	];

	private
	[
		"_tempCount",
		"_clampByPositions",
		"_areaSize"
	];

	_clampByPositions = false;
	_tempCount = 0;
	_areaSize = ["DetermineAreaSize", [_marker]] call SAEF_AID_fnc_Difficulty;

	if (toUpper(_areaType) == "GAR") then
	{
		_clampByPositions = true;
	};

	(["GetAreaMinMax", [_areaSize]] call SAEF_AID_fnc_Difficulty) params
	[
		"_min",
		"_max"
	];

	// Need to ensure that we're not re-populating attacked areas
	if (_count >= _min) then
	{
		_tempCount = (["GetAiCount", [(markerPos _marker), _areaSize, _clampByPositions]] call SAEF_AID_fnc_Difficulty);
	};

	if (_tempCount != 0) then
	{
		_count = _tempCount;
	};

	// Return the count
	_count
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

	// Set the radius
	private
	[
		"_radius",
		"_min",
		"_max"
	];

	_radius = 0;
	_min = 0;
	_max = 0;

	switch toUpper(_areaSize) do
	{
		case "SML": {
			(missionNamespace getVariable ["SAEF_AreaSpawner_Small_Params", []]) params
			[
				["_tBaseAICount", 4],
				["_tBaseAreaSize", 40],
				["_tBaseActivationRange", 500],
				["_tBaseAICountMinMax", [2, 4]]
			];

			_tBaseAICountMinMax params
			[
				"_tMin",
				"_tMax"
			];
			
			_radius = _tBaseAreaSize;
			_min = _tMin;
			_max = _tMax;
		};

		case "MED": {
			(missionNamespace getVariable ["SAEF_AreaSpawner_Medium_Params", []]) params
			[
				["_tBaseAICount", 8],
				["_tBaseAreaSize", 50],
				["_tBaseActivationRange", 500],
				["_tBaseAICountMinMax", [4, 12]]
			];

			_tBaseAICountMinMax params
			[
				"_tMin",
				"_tMax"
			];
			
			_radius = _tBaseAreaSize;
			_min = _tMin;
			_max = _tMax;
		};

		case "LRG": {
			(missionNamespace getVariable ["SAEF_AreaSpawner_Large_Params", []]) params
			[
				["_tBaseAICount", 12],
				["_tBaseAreaSize", 60],
				["_tBaseActivationRange", 500],
				["_tBaseAICountMinMax", [12, 20]]
			];

			_tBaseAICountMinMax params
			[
				"_tMin",
				"_tMax"
			];
			
			_radius = _tBaseAreaSize;
			_min = _tMin;
			_max = _tMax;
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

	_count = ["GetAiCountMinMax", [_position, _min, _max, [_clampByPositions, _radius]]] call SAEF_AID_fnc_Difficulty;

	// Return the count
	_count
};

/*
	------------------------------
	-- GETNUMBEROFGROUPSTOSPAWN --
	------------------------------

	Determines the number of AI groups to spawn based on area size and difficulty
*/
if (toUpper(_type) == "GETNUMBEROFGROUPSTOSPAWN") exitWith
{
	_params params
	[
		"_areaSize",
		"_marker"
	];

	private
	[
		"_groupNumber",
		"_countPerGroup",
		"_lightVehicleNumber",
		"_heavyVehicleNumber",
		"_hasAntiTank"
	];

	_groupNumber = 0;
	_countPerGroup = (["GetAiCount", [(markerPos _marker), _areaSize]] call SAEF_AID_fnc_Difficulty);
	_lightVehicleNumber = 0;
	_heavyVehicleNumber = 0;

	// Clamp group size max to 12
	if (_countPerGroup > 12) then
	{
		_countPerGroup = 12;
	};

	// Clamp group size min to 4
	if (_countPerGroup < 4) then
	{
		_countPerGroup = 4;
	};

	// Check if players have anti-tank equipment for destruction of heavy vehicles
	(["GetPlayerLauncherType", [(markerPos _marker)]] call SAEF_AID_fnc_Player) params
	[
		"_hasAntiAir",
		"_hasAntiTank"
	];

	// Get the current difficulty
	(["GetCount"] call SAEF_AID_fnc_Difficulty) params
	[
		"_difficulty",
		"_difficultyCount"
	];

	// Determine the number of items to spawn based on the area size
	switch toUpper(_areaSize) do
	{
		case "LRG": {
			if (_difficultyCount >= 3) then
			{
				if (_hasAntiTank) then
				{
					_heavyVehicleNumber = _heavyVehicleNumber + 1;
				};
			};

			if (_difficultyCount >= 2) then
			{
				_lightVehicleNumber = _lightVehicleNumber + 2;
			};
			
			_groupNumber = ceil (_difficultyCount * (0.45 + (random 0.3)));
		};

		case "MED": {
			if (_difficultyCount >= 4) then
			{
				if (_hasAntiTank) then
				{
					_heavyVehicleNumber = _heavyVehicleNumber + 1;
				};
			};

			if (_difficultyCount >= 3) then
			{
				_lightVehicleNumber = _lightVehicleNumber + 1;
			};

			if (_difficultyCount >= 2) then
			{
				_lightVehicleNumber = _lightVehicleNumber + 1;
			};

			_groupNumber = ceil (_difficultyCount * (0.2 + (random 0.3)));
		};

		// Default is small
		default {
			if (_difficultyCount >= 4) then
			{
				_lightVehicleNumber = _lightVehicleNumber + 1;
			};

			if (_difficultyCount >= 2) then
			{
				_lightVehicleNumber = _lightVehicleNumber + 1;
			};

			_groupNumber = 1;
		};
	};

	// Return our parameters
	[
		_groupNumber,
		_countPerGroup,
		_lightVehicleNumber,
		_heavyVehicleNumber
	]
};

/*
	-------------------
	-- GETAREAMINMAX --
	-------------------

	Get the min max based on the area
*/
if (toUpper(_type) == "GETAREAMINMAX") exitWith
{
	_params params
	[
		"_areaSize"
	];

	private
	[
		"_min",
		"_max"
	];

	_min = 0;
	_max = 0;

	switch toUpper(_areaSize) do
	{
		case "SML": {
			(missionNamespace getVariable ["SAEF_AreaSpawner_Small_Params", []]) params
			[
				["_tBaseAICount", 4],
				["_tBaseAreaSize", 40],
				["_tBaseActivationRange", 500],
				["_tBaseAICountMinMax", [2, 4]]
			];

			_tBaseAICountMinMax params
			[
				"_tMin",
				"_tMax"
			];
			
			_min = _tMin;
			_max = _tMax;
		};

		case "MED": {
			(missionNamespace getVariable ["SAEF_AreaSpawner_Medium_Params", []]) params
			[
				["_tBaseAICount", 8],
				["_tBaseAreaSize", 50],
				["_tBaseActivationRange", 500],
				["_tBaseAICountMinMax", [4, 12]]
			];

			_tBaseAICountMinMax params
			[
				"_tMin",
				"_tMax"
			];
			
			_min = _tMin;
			_max = _tMax;
		};

		case "LRG": {
			(missionNamespace getVariable ["SAEF_AreaSpawner_Large_Params", []]) params
			[
				["_tBaseAICount", 12],
				["_tBaseAreaSize", 60],
				["_tBaseActivationRange", 500],
				["_tBaseAICountMinMax", [12, 20]]
			];

			_tBaseAICountMinMax params
			[
				"_tMin",
				"_tMax"
			];
			
			_min = _tMin;
			_max = _tMax;
		};

		default {
			["SAEF_AID_fnc_Difficulty", 1, (format ["[GETAICOUNT] Unrecognised area size [%1], ai count cannot be determined!", _areaSize])] call RS_fnc_LoggingHelper;
		};
	};

	// Return the min and max
	[_min, _max]
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
		["_min", 0],
		["_max", 0],
		["_clampSettings", []]
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
	};

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
			(["GetGroupStatusFactorAtPos", [_position]] call SAEF_AID_fnc_Player) params
			[
				"_statusFactor",
				["_jsonResult", ""]
			];

			_count = (_min + round (_difference * _statusFactor));

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

			// Determine count based on player status factor
			(["GetGroupStatusFactorAtPos", [_position]] call SAEF_AID_fnc_Player) params
			[
				"_statusFactor",
				["_jsonResult", ""]
			];

			_count = (_newMin + round (_difference * _statusFactor));

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

	if (!(_clampSettings isEqualTo [])) then
	{
		_clampSettings params
		[
			["_clampByPositions", false],
			["_radius", 50]
		];
		
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
				["SAEF_AID_fnc_Difficulty", 2, (format ["[GETAICOUNTMINMAX] Clamping number of AI to fit available building positions: %1", [_position, _radius, _count]])] call RS_fnc_LoggingHelper;
			};
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

/*
	-----------------------
	-- DETERMINEAREASIZE --
	-----------------------

	Determines the area size string
*/
if (toUpper(_type) == "DETERMINEAREASIZE") exitWith
{
	_params params
	[
		"_marker"
	];

	private
	[
		"_areaSize"
	];

	_areaSize = "";

	if (["LRG", _marker] call BIS_fnc_InString) then
	{
		_areaSize = "LRG";
	};

	if (["MED", _marker] call BIS_fnc_InString) then
	{
		_areaSize = "MED";
	};

	if (["SML", _marker] call BIS_fnc_InString) then
	{
		_areaSize = "SML";
	};

	// Return the area size
	_areaSize
};

// Log warning if type is not recognised
["SAEF_AID_fnc_Difficulty", 2, (format ["Unrecognised type [%1], nothing is being executed!", _type])] call RS_fnc_LoggingHelper;