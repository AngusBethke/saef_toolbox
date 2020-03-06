/*
	fn_InitRespawnHandler.sqf
	Description: Initialises what we need initialised for the spectator
*/

diag_log format ["[RS] [Respawn] [INFO] Starting up respawn handler ..."];

// SP DEBUG
if (hasInterface && isServer) then
{
	// Set up our variables
	missionNamespace setVariable ["RespawnHandlerEnabled", true, true];
	missionNamespace setVariable ["RespawnHandlerHint", true, true];
	missionNamespace setVariable ["RespawnEnabled", true, true];
};

// Server initialisation
if !(hasInterface) exitWith 
{
	// Kick headless out
	if !(isServer) exitWith {};
	
	// Set up our variables
	missionNamespace setVariable ["RespawnHandlerEnabled", true, true];
	missionNamespace setVariable ["RespawnHandlerHint", true, true];
	missionNamespace setVariable ["RespawnEnabled", true, true];
};

// Delayed Functions
[] spawn RS_fnc_RespawnDelayedStart;

/*
	END
*/