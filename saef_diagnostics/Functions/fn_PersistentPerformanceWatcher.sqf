/**
	@namespace [?]
	@class [?]
	@method [?]
	@file fn_PersistentPerformanceCheck.sqf
	@summary A script that persitently logs server performance if it is below a certain threshold.

	@param int _time
	@param int _threshold

	@note NOT under a namespace - and therefore is unusable[?]
**/
/*
	fn_PersistentPerformanceWatcher.sqf
	Description: A script that persitently logs server performance if it is below a certain threshold.
	How to Call: [5, 25] spawn RS_DIAG_fnc_PersistentPerformanceWatcher;
	Author: Angus Bethke (a.k.a. Rabid Squirrel)
*/

missionNamespace setVariable ["PerformanceDiagnostics_Watcher", true, true];

_time = _this select 0;
_threshold = _this select 1;

/* Runs the Diagnostics */
while {missionNamespace getVariable ["PerformanceDiagnostics_Watcher", false]} do
{
	/* Resets Count Variables */
	_fps = diag_fps;
	
	if (_fps < _threshold) then
	{
		/* Creates Log */
		["Performance Diagnostics", 2, (format ["FPS: %1, is below the Threshold: %2", _fps, _threshold])] call RS_fnc_LoggingHelper;
	};
	
	sleep _time;
};