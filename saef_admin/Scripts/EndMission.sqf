/*
	Moved to saef_toolbox from the SAEF Mission Framework (Scripts\Utility\EndMission.sqf).
	The framework keeps Scripts\Utility\EndMission.sqf as a wrapper that forwards to \saef_admin\Scripts\EndMission.sqf.
*/

/*
	EndMission.sqf
	Description: Ends the mission for everyone on the server
*/

// Log stat track information
[] call RS_ST_fnc_LogInfo;

// End the mission
["end1", BIS_fnc_endMission] remoteExecCall ["call", 0, true];