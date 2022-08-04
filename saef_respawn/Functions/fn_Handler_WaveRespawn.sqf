/**
	@namespace RS
	@class Respawn
	@method RS_fnc_Handler_WaveRespawn
	@file fn_Handler_WaveRespawn.sqf
	@summary Handles the wave respawn functionality, enables respawn after x players are dead or an absolute timeout is reached as well as takes into account certain penalty parameters

	@param ?int _minTime The minimum time for respawn
	@param ?int _maxTime The maximum time for respawn
	@param ?int _holdTime The time the respawn is held open for
	@param ?int _playerThresholdForRespawn The amount of players required to force the respawn
	@param ?int _penaltyTime The base penalty time applied to players for dying
	@param ?array _classSpecificPenalties An array with penalty indicators to multiply penalties for certain classes

	@notes 
	```
	Class Specific Penalties:
	 _classSpecificPenalties =
		[
			[
				"B_medic_F",		// The class to apply the penalty to
				0.5					// The penalty factor 1 = 100%, 0.5 = 50%, 2 = 200% etc
			]
		];```
	@endnotes

	@usage

	How to Call:
		[
			_minTime,						// Optional: The minimum time for respawn
			_maxTime,						// Optional: The maximum time for respawn
			_holdTime,						// Optional: The time the respawn is held open for
			_playerThresholdForRespawn,		// Optional: The amount of players required to force the respawn
			_penaltyTime,					// Optional: The base penalty time applied to players for dying
			_classSpecificPenalties			// Optional: An array with penalty indicators to multiply penalties for certain classes
		] spawn RS_fnc_Handler_WaveRespawn;
	@endusage
**/

/*
	fn_Handler_WaveRespawn.sqf

	Description:
		Handles the wave respawn functionality,
			enables respawn after x players are dead
			or an absolute timeout is reached 
			as well as takes into account certain penalty parameters

	How to Call:
		[
			_minTime,						// Optional: The minimum time for respawn
			_maxTime,						// Optional: The maximum time for respawn
			_holdTime,						// Optional: The time the respawn is held open for
			_playerThresholdForRespawn,		// Optional: The amount of players required to force the respawn
			_penaltyTime,					// Optional: The base penalty time applied to players for dying
			_classSpecificPenalties			// Optional: An array with penalty indicators to multiply penalties for certain classes
		] spawn RS_fnc_Handler_WaveRespawn;

	Class Specific Penalties:
		_classSpecificPenalties =
		[
			[
				"B_medic_F",		// The class to apply the penalty to
				0.5					// The penalty factor 1 = 100%, 0.5 = 50%, 2 = 200% etc
			]
		];
*/

params
[
	["_minTime", 300],
	["_maxTime", 900],
	["_holdTime", 30],
	["_playerThresholdForRespawn", 5],
	["_penaltyTime", 0],
	["_classSpecificPenalties", []]
];

private
[
	"_respawnTime"
];

/* ----- Start of Validation Section ----- */
if (_minTime > _maxTime) exitWith
{
	[
		"RS_fnc_Handler_WaveRespawn", 
		1, 
		(format ["Given min time [%1] cannot be larger than given max time [%2]!", _minTime, _maxTime])
	] call RS_fnc_LoggingHelper;
};
/* ----- End of Validation Section ----- */

missionNamespace setVariable ["SAEF_Respawn_RunWaveRespawn", true, true];
missionNamespace setVariable ["SAEF_Respawn_RunWaveRespawn_PenaltyHandler", true, true];
missionNamespace setVariable ["SAEF_Respawn_WaveRespawn_PenaltyTime", 0, true];
missionNamespace setVariable ["SAEF_Respawn_WaveRespawn_MinTime", _minTime, true];

// Start up the penalty handler
[_penaltyTime, _classSpecificPenalties] spawn RS_fnc_Handler_WaveRespawn_PenaltyHandler;

// Make sure the user knows this has been initialised
[
	"RS_fnc_Handler_WaveRespawn", 
	0, 
	(format ["Initiating Wave Respawn Handler | To disable use variable [SAEF_Respawn_RunWaveRespawn] | Given parameters: %1", (_this - [_classSpecificPenalties])])
] call RS_fnc_LoggingHelper;

// Immediately disable spawns
missionNamespace setVariable ["RespawnEnabled", false, true];

// Main Handler Loop
_respawnTime = _minTime;
while {(missionNamespace getVariable ["SAEF_Respawn_RunWaveRespawn", false])} do
{
	private
	[
		"_currentPenaltyTime",
		"_countWaitingPlayers"
	];

	_countWaitingPlayers = 0;

	{
		if (_x getVariable ["SAEF_Respawn_AwaitingRespawn", false]) then
		{
			_countWaitingPlayers = _countWaitingPlayers + 1;
		};
	} forEach ([true, true] call RS_PLYR_fnc_GetTruePlayers);

	// If we have players awaiting respawn
	if (_countWaitingPlayers > 0) then
	{
		// If we've hit the end of the respawn countdown or we've hit the player threshold
		if ((_respawnTime <= 0) || (_countWaitingPlayers >= _playerThresholdForRespawn)) then
		{
			// Reset our respawn time
			_respawnTime = _minTime;
			missionNamespace setVariable ["SAEF_Respawn_WaveRespawn_RespawnTimeLeft", 0, true];

			// Evaluate our penalty time and shorten it if necessary
			_currentPenaltyTime = (missionNamespace getVariable ["SAEF_Respawn_WaveRespawn_PenaltyTime", 0]);
			if ((_maxTime - _minTime) < _currentPenaltyTime) then
			{
				_currentPenaltyTime = (_maxTime - _minTime);
			};

			// Now that we've used our penalty, reset it
			missionNamespace setVariable ["SAEF_Respawn_WaveRespawn_PenaltyTime", 0, true];

			// Allow tracking of penalty time left
			[_currentPenaltyTime] spawn
			{
				params
				[
					"_currentPenaltyTime"
				];

				while {_currentPenaltyTime > 0} do
				{
					missionNamespace setVariable ["SAEF_Respawn_WaveRespawn_PenaltyRespawnTimeLeft", _currentPenaltyTime, true];
					_currentPenaltyTime = _currentPenaltyTime - 1;

					sleep 1;
				};
			};

			// Now we wait out the total penalty time
			sleep _currentPenaltyTime;

			// Enable spawns
			missionNamespace setVariable ["RespawnEnabled", true, true];

			// Hold spawn open for given seconds
			sleep _holdTime;

			// Disable spawns
			missionNamespace setVariable ["RespawnEnabled", false, true];
		}
		else 
		{
			// Else we de-crement the respawn time
			_respawnTime = _respawnTime - 1;

			missionNamespace setVariable ["SAEF_Respawn_WaveRespawn_PenaltyRespawnTimeLeft", (missionNamespace getVariable ["SAEF_Respawn_WaveRespawn_PenaltyTime", 0]), true];
			missionNamespace setVariable ["SAEF_Respawn_WaveRespawn_RespawnTimeLeft", _respawnTime, true];
		};

		// We need to re-evaluate every second
		sleep 1;
	}
	else
	{
		// Reset our respawn time
		_respawnTime = _minTime;

		missionNamespace setVariable ["SAEF_Respawn_WaveRespawn_PenaltyRespawnTimeLeft", (missionNamespace getVariable ["SAEF_Respawn_WaveRespawn_PenaltyTime", 0]), true];
		missionNamespace setVariable ["SAEF_Respawn_WaveRespawn_RespawnTimeLeft", _respawnTime, true];
	};

	// We run in 10 second cycles when not having to evaluate every second
	if (_countWaitingPlayers <= 0) then
	{
		sleep 10;
	};
};

// De-allocate variables
missionNamespace setVariable ["SAEF_Respawn_RunWaveRespawn", nil, true];
missionNamespace setVariable ["SAEF_Respawn_RunWaveRespawn_PenaltyHandler", nil, true];
missionNamespace setVariable ["SAEF_Respawn_WaveRespawn_PenaltyTime", nil, true];
missionNamespace setVariable ["SAEF_Respawn_WaveRespawn_MinTime", nil, true];