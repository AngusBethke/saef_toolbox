/**
	@namespace RS
	@class Respawn
	@method RS_fnc_RespawnHints
	@file fn_RespawnHints.sqf
	@summary Lets the players know that respawn is enabled or disabled via hints


**/

/*
	fn_RespawnHints.sqf
	Description: Lets the players know that respawn is enabled or disabled via hints
*/

["RS Respawn", 0, (format ["Starting up respawn hint handler ..."])] call RS_fnc_LoggingHelper;

/* Main loop - Controlled by Public Variable */
while {(missionNamespace getVariable "RespawnHandlerEnabled")} do 
{
	// Wait until respawn disabled 
	waitUntil {
		sleep 5; 
		!(missionNamespace getVariable ["RespawnEnabled", true])
	};
	["Disabled"] call RS_fnc_SpectatorHint;
	
	// Wait until respawn enabled 
	waitUntil {
		sleep 5; 
		(missionNamespace getVariable ["RespawnEnabled", true])
	};
	["Enabled"] call RS_fnc_SpectatorHint;
};