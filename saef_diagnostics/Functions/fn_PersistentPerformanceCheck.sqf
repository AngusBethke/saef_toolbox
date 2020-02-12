/*
	fn_PersistentPerformanceCheck.sqf
	Description: A script that persitently logs server performance, it displays AI unit numbers, player numbers, and server fps.
	How to Call: [30] spawn RS_DIAG_fnc_PersistentPerformanceCheck;
	Author: Angus Bethke (a.k.a. Rabid Squirrel)
*/

missionNamespace setVariable ["PerformanceDiagnostics", true, true];

_time = _this select 0;

/* Runs the Diagnostics */
while {missionNamespace getVariable ["PerformanceDiagnostics", false]} do
{
	/* Resets Count Variables */
	_aiCount = 0;
	_playerCount = 0;
	_localCount = 0;
	_fpsTtl = 0;
	
	/* Averages the FPS over the wait period */
	_i = 0;
	while {_i < _time} do
	{
		_fpsTtl = _fpsTtl + diag_fps;
		_i = _i + 1;
		sleep 1;
	};
	
	_avgFPS = _fpsTtl / _time;
	
	/* Counts Players and AI */
	{
		if ((isPlayer _x) && ((name _x) != "headlessclient")) then
		{
			_playerCount = _playerCount + 1;
		}
		else
		{
			_aiCount = _aiCount + 1;
			
			if (local _x) then
			{
				_localCount = _localCount + 1;
			};
		};
	} forEach allUnits;
	
	/* Creates Log */
	diag_log format ["[Performance Diagnostics] || Currently Active Players: %1 || Current AI Amount: %2 || Current Local AI Amount: %3 || Average FPS: %4", _playerCount, _aiCount, _localCount, _avgFPS];
};