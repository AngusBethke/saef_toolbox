/**
	@namespace RS
	@class Respawn
	@method RS_fnc_Handler_WaveRespawn_PenaltyHandler
	@file fn_Handler_WaveRespawn_PenaltyHandler.sqf
	@summary Handles the wave respawn penalty functionality

	@param ?int _waitTime The time between respawn waves
	@param ?int _holdTime The time the respawn is held open for

	@usage ```[_waitTime, _holdTime] call RS_fnc_Handler_WaveRespawn;```

**/

/*
	fn_Handler_WaveRespawn_PenaltyHandler.sqf

	Description:
		Handles the wave respawn penalty functionality

	How to Call:
		[
			_waitTime,		// Optional: The time between respawn waves
			_holdTime		// Optional: The time the respawn is held open for
		] call RS_fnc_Handler_WaveRespawn;
*/

params
[
	"_penaltyTime",
	"_classSpecificPenalties"
];

// Make sure the user knows this has been initialised
[
	"RS_fnc_Handler_WaveRespawn", 
	0, 
	(format ["Initiating Wave Respawn Penalty Handler | With a base penalty time of: %1 seconds | To disable use variable [SAEF_Respawn_RunWaveRespawn_PenaltyHandler]", _penaltyTime])
] call RS_fnc_LoggingHelper;

while {(missionNamespace getVariable ["SAEF_Respawn_RunWaveRespawn", false]) && (missionNamespace getVariable ["SAEF_Respawn_RunWaveRespawn_PenaltyHandler", false])} do
{
	{
		private
		[
			"_multiplier",
			"_alteredPenaltyTime",
			"_unit"
		];

		_unit = _x;

		if (!(_unit getVariable ["SAEF_Respawn_WaveRespawn_PenaltyHandlerAdded", false])) then
		{
			
			_unit setVariable ["SAEF_Respawn_WaveRespawn_PenaltyHandlerAdded", true, true];

			// Adjust the multiplier
			_multiplier = 1;

			{
				_x params
				[
					"_class",
					"_penaltyMultiplier"
				];

				if (_unit isKindOf _class) then
				{
					_multiplier = _multiplier + _penaltyMultiplier;
				};
			} forEach _classSpecificPenalties;

			_alteredPenaltyTime = _penaltyTime * _multiplier;
			_unit setVariable ["SAEF_Respawn_WaveRespawn_Player_PenaltyTime", _alteredPenaltyTime, true];

			[_unit, ["killed", { [] call RS_fnc_Handler_WaveRespawn_Player_PenaltyTime;	}]] remoteExecCall ["addEventHandler", _unit, false];
		};
	} forEach ([true, true] call RS_PLYR_fnc_GetTruePlayers);

	sleep 60;
};