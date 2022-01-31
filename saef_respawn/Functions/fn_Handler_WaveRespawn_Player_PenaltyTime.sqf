/**
	@namespace RS
	@class Respawn
	@method RS_fnc_Handler_WaveRespawn_Player_PenaltyTime
	@file fn_Handler_WaveRespawn_Player_PenaltyTime.sqf
	@summary Handles the wave respawn player penalty

**/

/*
	fn_Handler_WaveRespawn_Player_PenaltyTime.sqf

	Description:
		Handles the wave respawn player penalty
*/

private
[
	"_penaltyTime"
];

_penaltyTime = player getVariable ["SAEF_Respawn_WaveRespawn_Player_PenaltyTime", 0];
["SAEF_Respawn_WaveRespawn_PenaltyTime", _penaltyTime, true] call RS_ST_fnc_Incrementer;