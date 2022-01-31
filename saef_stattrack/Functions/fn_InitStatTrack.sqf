/**
	@namespace RS_ST
	@class StatTrack
	@method RS_ST_fnc_InitStatTrack
	@file fn_InitStatTrack.sqf
	@summary Sets up all the Variables required for StatTrack

**/

/*
	fn_InitStatTrack.sqf
	Description: Sets up all the Variables required for StatTrack
	Author: Angus Bethke (a.k.a. Rabid Squirrel)
*/

if (!isServer) exitWith {};

// Set up the Variables
missionNamespace setVariable ["ST_TrackUIDs", [], true];
missionNamespace setVariable ["ST_TotalPlayerCount", 0, true];
missionNamespace setVariable ["ST_MissionAttendees", [], true];
missionNamespace setVariable ["ST_Casualties", 0, true];
missionNamespace setVariable ["ST_KillCount", 0, true];
missionNamespace setVariable ["ST_FriendlyFire", 0, true];
missionNamespace setVariable ["ST_CivKillCount", 0, true];
missionNamespace setVariable ["ST_AllowLogging", true, true];
missionNamespace setVariable ["ST_LogNow", false, true];
missionNamespace setVariable ["ST_PlayerFriendSides", [CIVILIAN], true];
missionNamespace setVariable ["ST_TrackPlayers", true, true];

// Launch all of the EventHandlers
[] spawn RS_ST_fnc_TrackPlayers;
[] call RS_ST_fnc_TrackDeaths;
[] call RS_ST_fnc_LogOnEnd;
[] spawn RS_ST_fnc_Handler;

/*
	END
*/