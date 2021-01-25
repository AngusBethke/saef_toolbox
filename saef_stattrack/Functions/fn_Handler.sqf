/*
	fn_Handler.sqf
	Description: Runs the StatTrack handler
	Author: Angus Bethke (a.k.a. Rabid Squirrel)
*/

// Run the Logging Component: This allows the Admin to request the Information be logged
while {(missionNamespace getVariable "ST_AllowLogging")} do
{
	waitUntil {sleep 10; (missionNamespace getVariable "ST_LogNow")};
	
	[] call RS_ST_fnc_LogInfo;
	
	// Reset Logging Variable for Next Log Command
	missionNamespace setVariable ["ST_LogNow", false, true];
};

/*
	END
*/