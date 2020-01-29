/*
	fn_CP_PreInit.sqf
	Description: Launches Civilian Presence Modules
	Note: 	Interesting discovery, it appears that module must run on all clients and server in order to work.
			BIS must have planned this when building the modules (as I suspect they get loaded on all connected clients and the server when in module format).
			I have no idea what the implication is on server performance with this running, hopeful that it isn't terrible.
*/

// Control Variable
missionNamespace setVariable ["RS_CivilianPresence_Enabled", true, true];
missionNamespace setVariable ["RS_CivilianPresence_RunOnServer", true, true];
missionNamespace setVariable ["RS_CivilianPresence_RunOnClient", true, true];

// Waits for custom locations to be defined (if any)
[] call RS_fnc_CP_AddCustomLocations;

[
	false,	// Debug
	{
		[_this] call RS_fnc_CP_UnitInit;
	}, 
	{}, 
	false, 	// Use Agents
	true,	// Use Panic Mode
	true	// Whitelist
] call RS_fnc_CP_Handler;
