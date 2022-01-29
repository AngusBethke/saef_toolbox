/**
	@namespace RS_PLYR
	@class PlayerFunctions
	@method RS_PLYR_fnc_ForcefulPardon
	@file fn_ForcefulPardon.sqf
	@summary Alters default rating return value so that players do not need to be pardoned

	@usage ```[] call RS_PLYR_fnc_ForcefulPardon;```

**/

/*
	fn_ForcefulPardon.sqf
	Description: Alters default rating return value so that players do not need to be pardoned
	[] call RS_PLYR_fnc_ForcefulPardon;
*/

if (!hasInterface) exitWith {};

// Check if this is enabled
[("SAEF_Player_ForcefulPardon" call CBA_settings_fnc_get)] params [["_var_SAEF_Player_ForcefulPardon", false, [false]]];

if (_var_SAEF_Player_ForcefulPardon) then
{
	[] spawn
	{
		player setVariable ["SAEF_Player_ForcefulPardon_Run", true, true];

		["SAEF Player", 0, (format ["Forceful Pardon Enabled, set variable [SAEF_Player_ForcefulPardon_Run] on player [%1] to false to disable.", player])] call RS_fnc_LoggingHelper;

		private
		[
			"_playerValidationCode"
		];

		_playerValidationCode = 
		{
			params
			[
				"_player"
			];

			((vehicle _player) != _player)
		};

		while { (player getVariable ["SAEF_Player_ForcefulPardon_Run", false]) } do
		{
			private
			[
				"_closeBy"
			];

			// If there is a friendly vehicle close by
			_closeBy = !(([(getPos player), 15, _playerValidationCode] call RS_PLYR_fnc_GetClosestPlayer) isEqualTo [0,0,0]);

			if (_closeBy) then
			{
				if ((rating player) < 0) then
				{
					// Reset player rating to 0
					player addRating ((rating player) * -1);
				};
			};

			sleep 5;
		};
	};
}
else
{
	["SAEF Player", 0, "Forceful Pardon Disabled"] call RS_fnc_LoggingHelper;
};