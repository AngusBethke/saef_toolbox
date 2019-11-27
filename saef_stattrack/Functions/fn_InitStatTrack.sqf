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
missionNamespace setVariable ["ST_AllowLogging", true, true];
missionNamespace setVariable ["ST_LogNow", false, true];
missionNamespace setVariable ["ST_PlayerFriendSides", [CIVILIAN], true];

// Launch all of the EventHandlers
[] call RS_ST_fnc_TrackPlayers;
[] call RS_ST_fnc_TrackDeaths;
[] call RS_ST_fnc_LogOnEnd;
[] spawn RS_ST_fnc_Handler;

/*
	END
*/