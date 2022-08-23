/**
	@namespace RS_ST
	@class StatTrack
	@method RS_ST_fnc_LogInfo
	@file fn_LogInfo.sqf
	@summary Formats and Logs all the relevant Stats

**/

/*
	fn_LogInfo.sqf
	Description: Formats and Logs all the relevant Stats
	Author: Angus Bethke (a.k.a. Rabid Squirrel)
*/

_type = "Default";

if (!isNil{_this select 0}) then
{
	_type = _this select 0;
};

// Format the Text with all the Information from StatTrack
_info = format ["Total Player Count: %1 || Total Player Casualties: %2 || Total Enemies Killed: %3 || Friendly Fire Incidents: %4 || Mission Attendees: %5 || Civilian Casualties (by Player): %6", 
					(missionNamespace getVariable "ST_TotalPlayerCount"),
					(missionNamespace getVariable "ST_Casualties"),
					(missionNamespace getVariable "ST_KillCount"),
					(missionNamespace getVariable "ST_FriendlyFire"),
					(text (missionNamespace getVariable "ST_MissionAttendees")),
					(missionNamespace getVariable "ST_CivKillCount")];

// Log StatTrack info to the .rpt
["StatTrack", 0, _info] call RS_fnc_LoggingHelper;

_adminExists = false;
_hint = false;
_admin = objNull;

if (_type == "OnDeath") then
{
	_hint = false;
}
else
{
	_hint = true;
};

if (_hint) then
{
	// If an admin exists, copy StatTrack info to his clipboard
	{
		if (!isNil{_x getVariable "RS_IsAdmin"}) then
		{
			if (_x getVariable "RS_IsAdmin") then
			{
				_admin = _x;
				_adminExists = true;
			};
		};
	} forEach ([true, true] call RS_PLYR_fnc_GetTruePlayers);

	if (_adminExists) then
	{
		["StatTrack information has been logged to Server.rpt"] remoteExec ["hint", _admin, false];
	};
};

/*
	END
*/