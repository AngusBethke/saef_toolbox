/*
	fn_Director.sqf

	Description:
		Handles the main direction component for the AI director, this is scoped on a "server wide" basis
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

_scriptTag = "SAEF AID Director";

/*
	------------
	-- HANDLE --
	------------

	Handles the AI Director, attempts to curve the difficulty adjusting to player current status
*/
if (toUpper(_type) == "HANDLE") exitWith
{
	missionNamespace setVariable ["SAEF_AID_RunDirector", true, true];

	// Sets the min max on start for tracking
	["SetAreaMinMax", [["SML", "MED", "LRG"]]] call SAEF_AID_fnc_Director;

	while {(missionNamespace getVariable ["SAEF_AID_RunDirector", false])} do
	{
		// Get overall status factor
		private
		[
			"_recDifficulty"
		];

		(["GetOverallStatusFactor", [true]] call SAEF_AID_fnc_Player) params
		[
			"_statusFactor",
			["_jsonResult", ""]
		];

		if (_jsonResult != "") then
		{
			["Log", ["SAEF AI Director | Current Status", _jsonResult]] call SAEF_LOG_fnc_JsonLogger;
		};

		_recDifficulty = "Easy";

		// Suggest the recommended difficulty
		if (_statusFactor > 0.8) then
		{
			_recDifficulty = "Insane";
		};

		if ((_statusFactor <= 0.8) && (_statusFactor > 0.6)) then
		{
			_recDifficulty = "Hard";
		};

		if ((_statusFactor <= 0.6) && (_statusFactor > 0.3)) then
		{
			_recDifficulty = "Normal";
		};

		// Get the last 2 and a half minutes worth of recommended difficulties
		private
		[
			"_recDifficulties",
			"_newRecDifficulties"
		];

		_newRecDifficulties = [];
		_recDifficulties = missionNamespace getVariable ["SAEF_AID_RecommendedDifficulties", []];

		// If we don't have 10 recommendations yet, we'll simply add
		if ((count _recDifficulties) < 10) then
		{
			_recDifficulties pushBack toUpper(_recDifficulty);
			_newRecDifficulties = _recDifficulties;
		}
		else
		{
			{
				// Pushback everything but the first
				if (_forEachIndex != 0) then
				{
					_newRecDifficulties pushBack _x;
				};
			} forEach _recDifficulties;

			_newRecDifficulties pushBack toUpper(_recDifficulty);
		};

		missionNamespace setVariable ["SAEF_AID_RecommendedDifficulties", _newRecDifficulties, true];

		// Now we take the most prevalent recommended difficulty and set the difficulty to that
		["SetByRecommended", [_newRecDifficulties]] call SAEF_AID_fnc_Difficulty;

		// Re-evaluate every 15 seconds
		sleep 15;
	};
};

/*
	-------------------
	-- SETAREAMINMAX --
	-------------------

	Sets the area min/max variables on start
*/
if (toUpper(_type) == "SETAREAMINMAX") exitWith
{
	_params params
	[
		"_areaTypes"
	];

	{
		["SetMinMax", [_x]] call SAEF_AID_fnc_Director;
	} forEach _areaTypes;
};

/*
	---------------
	-- SETMINMAX --
	---------------

	Sets min/max variable on start
*/
if (toUpper(_type) == "SETMINMAX") exitWith
{
	_params params
	[
		"_areaSize"
	];

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
			
			["SAEF_AID_ProcessQueue", ["Set", [(format ["AreaMinMax_%1", _areaSize]), _tBaseAICountMinMax]], "SAEF_AID_fnc_Track"] call RS_MQ_fnc_MessageEnqueue;
		};

		case "MED": {
			(missionNamespace getVariable ["SAEF_AreaSpawner_Medium_Params", []]) params
			[
				["_tBaseAICount", 8],
				["_tBaseAreaSize", 50],
				["_tBaseActivationRange", 500],
				["_tBaseAICountMinMax", [4, 12]]
			];

			["SAEF_AID_ProcessQueue", ["Set", [(format ["AreaMinMax_%1", _areaSize]), _tBaseAICountMinMax]], "SAEF_AID_fnc_Track"] call RS_MQ_fnc_MessageEnqueue;
		};

		case "LRG": {
			(missionNamespace getVariable ["SAEF_AreaSpawner_Large_Params", []]) params
			[
				["_tBaseAICount", 12],
				["_tBaseAreaSize", 60],
				["_tBaseActivationRange", 500],
				["_tBaseAICountMinMax", [12, 20]]
			];

			["SAEF_AID_ProcessQueue", ["Set", [(format ["AreaMinMax_%1", _areaSize]), _tBaseAICountMinMax]], "SAEF_AID_fnc_Track"] call RS_MQ_fnc_MessageEnqueue;
		};

		default {
			[_scriptTag, 1, (format ["[SETMINMAX] Unrecognised area size [%1], value cannot be set!", _areaSize])] call RS_fnc_LoggingHelper;
		};
	};
};

// Log warning if type is not recognised
[_scriptTag, 2, (format ["Unrecognised type [%1], nothing is being executed!", _type])] call RS_fnc_LoggingHelper;