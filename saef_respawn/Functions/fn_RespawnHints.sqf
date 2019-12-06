/*
	fn_RespawnHints.sqf
	Description: Lets the players know that respawn is enabled or disabled via hints
*/

diag_log format ["[RS] [Respawn] [INFO] Starting up respawn hint handler ..."];

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