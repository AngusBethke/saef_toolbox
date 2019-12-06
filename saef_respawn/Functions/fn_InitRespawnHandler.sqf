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

private
[
	"_casCount"
];

// Initialise Event Handlers
player setVariable ["RespawnHandlerHint", true, true];
[] call RS_fnc_PlayerEventHandlers;

// Start Hints
[] spawn RS_fnc_RespawnHints;

// Fix for if Player Joins while Respawns are currently disabled
if (!(missionNamespace getVariable ["RespawnEnabled", true])) then 
{
	if (!isNil{missionNamespace getVariable "ST_AllowLogging"}) then
	{
		_casCount = missionNamespace getVariable "ST_Casualties";
		_casCount = _casCount - 1;
		missionNamespace setVariable ["ST_Casualties", _casCount, true];
	};
	
	player setDamage 1;
};

/*
	END
*/