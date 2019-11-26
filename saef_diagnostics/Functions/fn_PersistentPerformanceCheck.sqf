/*
	fn_PersistentPerformanceCheck.sqf
	Description: A script that persitently logs server performance, it displays AI unit numbers, player numbers, and server fps.
	How to Call: [30] spawn RS_DIAG_fnc_PersistentPerformanceCheck;
	Author: Angus Bethke (a.k.a. Rabid Squirrel)
*/

missionNamespace setVariable ["ServerDiagnostics", true, true];

_time = _this select 0;

/* Runs the Diagnostics */
while {missionNamespace getVariable "ServerDiagnostics"} do
{
	/* Resets AI Count and Player Count */
	_aiCount = 0;
	_playerCount = 0;
	
	/* Counts Players and AI */
	{
		if ((isPlayer _x)&&((name _x) != "headlessclient")) then
		{
			_playerCount = _playerCount + 1;
		}
		else
		{
			_aiCount = _aiCount + 1;
		};
	} forEach allUnits;
	
	/* Creates Log */
	diag_log format ["[Server Diagnostics] || Currently Active Players: %1 || Current AI Amount: %2 || Current Server FPS: %3", _playerCount, _aiCount, diag_fps];
	
	sleep _time;
};