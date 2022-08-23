/*
	fn_Helpers.sqf

	Description:
		Handles helper methods and functionality for the ambient combat toolset
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

_scriptTag = "SAEF Ambient Combat - Helper";

/*
	----------
	-- INIT --
	----------

	Handles initialisation of the function set
*/
if (toUpper(_type) == "INIT") exitWith
{
	[_scriptTag, 2, (format ["[%1] Method not yet implemeneted!", _type])] call RS_fnc_LoggingHelper;
};

/*
	--------------------------------
	-- GETSAFEPLACESAROUNDPLAYERS --
	--------------------------------

	Finds and returns all the "safe" places around players
*/
if (toUpper(_type) == "GETSAFEPLACESAROUNDPLAYERS") exitWith
{
	_params params
	[
		"_distance",
		["_headingIncrement", 45]
	];

	private
	[
		"_players",
		"_unsafePositions"
	];

	_players = [] call RS_PLYR_fnc_GetTruePlayers;
	_unsafePositions = [];

	{
		private
		[
			"_player",
			"_heading"
		];

		_player = _x;
		_heading = 0;

		while {_heading < 360} do
		{
			_unsafePositions pushBackUnique (_player getPos [_distance, _heading]);
			_heading = _heading + _headingIncrement;
		};
	} forEach _players;

	private
	[
		"_safePositions"
	];

	_safePositions = ["GetSafePositionsFromUnsafe", [_distance, _unsafePositions, _players]] call SAEF_AC_fnc_Helpers;

	// Return the safe positions
	_safePositions
};

/*
	---------------------------------
	-- GETPOSITIONSFORAMBIENTSPAWN --
	---------------------------------

	Finds positions for ambient spawns
*/
if (toUpper(_type) == "GETPOSITIONSFORAMBIENTSPAWN") exitWith
{
	_params params
	[
		["_distance", 500],
		["_friendly", false]
	];

	private
	[
		"_playerGroups",
		"_unsafePositions"
	];

	_playerGroups = ["GetAllPlayerGroups"] call SAEF_AID_fnc_Player;
	_unsafePositions = [];

	{
		_x params
		[
			"_groupId",
			"_groupPlayers",
			"_groupLength",
			"_groupCenter",
			"_groupAvgDirection"
		];
		
		private
		[
			"_safeDistance",
			"_leftPosition",
			"_rightPosition"
		];	

		_safeDistance = (_distance + (_groupLength / 2));
		_leftPosition = (_groupCenter getPos [_safeDistance, (_groupAvgDirection - 90)]);
		_rightPosition = (_groupCenter getPos [_safeDistance, (_groupAvgDirection + 90)]);

		if (_friendly) then
		{
			// Pushback positions "behind" the group
			_unsafePositions pushBackUnique (_leftPosition getPos [250, 180]);
			_unsafePositions pushBackUnique (_rightPosition getPos [250, 180]);
		}
		else
		{
			// PushBack positions "in front of" the group
			_unsafePositions pushBackUnique (_leftPosition getPos [250, 0]);
			_unsafePositions pushBackUnique (_rightPosition getPos [250, 0]);
		};
	} forEach _playerGroups;

	// Ensure that none of these establish positions are unsafe
	private
	[
		"_safePositions"
	];

	_safePositions = ["GetSafePositionsFromUnsafe", [(_distance - 50), _unsafePositions, ([] call RS_PLYR_fnc_GetTruePlayers)]] call SAEF_AC_fnc_Helpers;
	
	// Return the safe positions
	_safePositions
};

/*
	--------------------------------
	-- GETSAFEPOSITIONSFROMUNSAFE --
	--------------------------------

	Finds safe positions given unsafe ones
*/
if (toUpper(_type) == "GETSAFEPOSITIONSFROMUNSAFE") exitWith
{
	_params params
	[
		"_distance",
		"_unsafePositions",
		"_players"
	];

	private
	[
		"_safePositions"
	];

	_safePositions = [];

	{
		private
		[
			"_isSafe",
			"_unsafePosition"
		];

		_isSafe = true;
		_unsafePosition = _x;

		{
			private
			[
				"_player"
			];

			_player = _x;

			if ((_player distance _unsafePosition) < _distance) exitWith
			{
				_isSafe = false;
			};
		} forEach _players;

		if (_isSafe) then
		{
			_safePositions pushBackUnique _x;
		};
	} forEach _unsafePositions;

	// Return the safe positions
	_safePositions
};

/*
	----------------------------
	-- GETCONFIGBYTAGORMARKER --
	----------------------------

	Finds area config by given area tag or marker
*/
if (toUpper(_type) == "GETCONFIGBYTAGORMARKER") exitWith
{
	_params params
	[
		["_areaTag", ""],
		["_marker", ""]
	];

	if ((_areaTag == "") && (_marker == "")) exitWith
	{
		[_scriptTag, 1, (format ["[%1] No area tag or marker supplied, cannot get config!", _type])] call RS_fnc_LoggingHelper;

		// Return empty array
		[]
	};

	private
	[
		"_areaTags",
		"_areaConfigVar"
	];

	_areaTags = (missionNamespace getVariable ["SAEF_AreaMarkerTags", []]);
	_areaConfigVar = "";

	{
		_x params
		[
			"_tag"
			,"_name"
			,"_config"
			,["_overrides", []]
		];

		private
		[
			"_matchFound"
		];

		_matchFound = false;
		
		if (_areaTag == "") then
		{
			if ([toUpper(_tag), toUpper(_marker)] call BIS_fnc_InString) then
			{
				_matchFound = true;
			};
		}
		else
		{
			if (_areaTag == _tag) then
			{
				_matchFound = true;
			};
		};

		if (_matchFound) exitWith 
		{
			_areaTag = _tag;
			_areaConfigVar = _config;
		};
	} forEach _areaTags;

	if (_areaConfigVar == "") exitWith
	{
		[_scriptTag, 1, (format ["[%1] Unable to find area config with given tag [%2] and marker [%2]!", _type, _areaTag, _marker])] call RS_fnc_LoggingHelper;

		// Return empty array
		[]
	};

	// Load the configuration for the area
	(missionNamespace getVariable [_areaConfigVar, []]) params
	[
		["_blockPatrol", false],
		["_blockGarrison", false],
		["_units", ""],
		["_side", ""],
		["_lightVehicles", ""],
		["_heavyVehicles", ""],
		["_paraVehicles", ""],
		["_playerValidation", {true}],
		["_groupScripts", []],
		["_queueValidation", {true}],
		["_defaultDetector", true],
		["_useAiDirector", true],
		["_aiDirectorParams", []],
		["_paraStartPosVariable", ""]
	];

	// Return our config
	[
		_blockPatrol,
		_blockGarrison,
		_units,
		_side,
		_lightVehicles,
		_heavyVehicles,
		_paraVehicles,
		_playerValidation,
		_groupScripts,
		_queueValidation,
		_defaultDetector,
		_useAiDirector,
		_aiDirectorParams,
		_paraStartPosVariable
	]
};

// Log warning if type is not recognised
[_scriptTag, 2, (format ["Unrecognised type [%1], nothing is being executed!", _type])] call RS_fnc_LoggingHelper;