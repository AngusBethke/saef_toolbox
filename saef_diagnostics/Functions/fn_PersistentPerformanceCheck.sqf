/**
	@namespace RS_DIAG
	@class Diagnostics
	@method RS_DIAG_fnc_PersistentPerformanceCheck
	@file fn_PersistentPerformanceCheck.sqf
	@summary A script that persitently logs server performance, it displays AI unit numbers, player numbers, and server fps.

	@param ?int _time Time in seconds for the persistent performance check to run

**/

/*
	fn_PersistentPerformanceCheck.sqf

	Description: 
		A script that persitently logs server performance, it displays AI unit numbers, player numbers, and server fps.

	How to Call: 
		[
			_time		// (Optional) Time in seconds for the persistent performance check to run
		] spawn RS_DIAG_fnc_PersistentPerformanceCheck;

	Author: Angus Bethke (a.k.a. Rabid Squirrel)
*/

params
[
	["_time", 120]
];

if (isServer) then
{
	missionNamespace setVariable ["SAEF_PerformanceDiagnostics_Run", true, true];
}
else
{
	sleep 10;
};

// Runs the Diagnostics
while {missionNamespace getVariable ["SAEF_PerformanceDiagnostics_Run", false]} do
{
	private
	[
		"_aiCount",
		"_playerCount",
		"_localCount",
		"_fpsTtl"
	];

	// Resets Count Variables
	_aiCount = 0;
	_playerCount = 0;
	_localCount = 0;
	_fpsTtl = 0;
	
	// Averages the FPS over the wait period
	private
	[
		"_i"
	];

	_i = 0;
	while {_i < _time} do
	{
		_fpsTtl = _fpsTtl + diag_fps;
		_i = _i + 1;
		sleep 1;
	};

	private
	[
		"_avgFPS"
	];
	
	_avgFPS = _fpsTtl / _time;
	
	// Count Players and AI
	{
		_x params ["_unit"];

		if ((isPlayer _unit) && ((name _unit) != "headlessclient")) then
		{
			_playerCount = _playerCount + 1;
		}
		else
		{
			_aiCount = _aiCount + 1;
			
			if (local _unit) then
			{
				_localCount = _localCount + 1;
			};
		};
	} forEach allUnits;
	
	// Log the result
	["Performance Diagnostics", 0, (format ["Currently Active Players: %1 || Current AI Amount: %2 || Current Local AI Amount: %3 || Average FPS: %4", _playerCount, _aiCount, _localCount, _avgFPS])] call RS_fnc_LoggingHelper;
};