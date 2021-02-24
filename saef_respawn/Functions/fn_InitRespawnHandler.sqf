/*
	fn_InitRespawnHandler.sqf
	Description: Initialises what we need initialised for the spectator
*/

["RS Respawn", 0, (format ["Starting up respawn handler ..."])] call RS_fnc_LoggingHelper;

// SP DEBUG
if (hasInterface && isServer) then
{
	// Set up our variables
	missionNamespace setVariable ["RespawnHandlerEnabled", true, true];
	missionNamespace setVariable ["RespawnHandlerHint", true, true];
	missionNamespace setVariable ["RespawnEnabled", true, true];
	missionNamespace setVariable ["SAEF_Respawn_RunPlayerHandler", true, true];
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
	missionNamespace setVariable ["SAEF_Respawn_RunPlayerHandler", true, true];
};

// Delayed Functions
[] spawn RS_fnc_RespawnDelayedStart;

/*
	END
*/