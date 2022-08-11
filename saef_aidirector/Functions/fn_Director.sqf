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

/*
	------------
	-- HANDLE --
	------------

	Handles the AI Director, attempts to curve the difficulty adjusting to player current status
*/
if (toUpper(_type) == "HANDLE") exitWith
{
	missionNamespace setVariable ["SAEF_AID_RunDirector", true, true];

	while {(missionNamespace getVariable ["SAEF_AID_RunDirector", false])} do
	{
		// Get overall status factor
		private
		[
			"_statusFactor",
			"_recDifficulty"
		];

		_statusFactor = (["GetOverallStatusFactor", [true]] call SAEF_AID_fnc_Player);
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

// Log warning if type is not recognised
["SAEF_AID_fnc_Director", 2, (format ["Unrecognised type [%1], nothing is being executed!", _type])] call RS_fnc_LoggingHelper;