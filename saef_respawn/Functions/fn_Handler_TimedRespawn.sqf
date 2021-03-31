/*
	fn_Handler_TimedRespawn.sqf

	Description:
		Handles the timed respawn functionality (i.e. Enable the respawn every x seconds)

	How to Call:
		[
			_waitTime,		// Optional: The time between respawn waves
			_holdTime		// Optional: The time the respawn is held open for
		] spawn RS_fnc_Handler_TimedRespawn;
*/

params
[
	["_waitTime", 600],
	["_holdTime", 30]
];

missionNamespace setVariable ["SAEF_Respawn_RunTimedRespawn", true, true];
missionNamespace setVariable ["SAEF_Respawn_TimedRespawn_WaitTime", _waitTime, true];

// Make sure the user knows this has been initialised
[
	"RS_fnc_Handler_TimedRespawn", 
	0, 
	(format ["Initiating Timed Respawn Handler | Time between respawns is: %1 seconds | Time spawns are allowed for is: %2 seconds | To disable use variable [SAEF_Respawn_RunTimedRespawn]", _waitTime, _holdTime])
] call RS_fnc_LoggingHelper;

// Immediately disable spawns
missionNamespace setVariable ["RespawnEnabled", false, true];
	
while {(missionNamespace getVariable ["SAEF_Respawn_RunTimedRespawn", false])} do
{
	// Wait given seconds
	sleep _waitTime;

	// Allow tracking of respawn time left
	[_waitTime] spawn
	{
		params
		[
			"_waitTime"
		];

		while {_waitTime > 0} do
		{
			missionNamespace setVariable ["SAEF_Respawn_TimedRespawn_RespawnTimeLeft", _waitTime, true];
			_waitTime = _waitTime - 1;

			sleep 1;
		};
	};
	
	// Enable spawns
	missionNamespace setVariable ["RespawnEnabled", true, true];

	// Hold spawn open for given seconds
	sleep _holdTime;

	// Disable spawns
	missionNamespace setVariable ["RespawnEnabled", false, true];
};

// De-allocate variables
missionNamespace setVariable ["SAEF_Respawn_RunTimedRespawn", nil, true];
missionNamespace setVariable ["SAEF_Respawn_TimedRespawn_WaitTime", nil, true];