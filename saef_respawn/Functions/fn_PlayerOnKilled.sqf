/*
	fn_PlayerOnKilled.sqf
	Description: Runs on player death as per added event handler 
*/

private
[
	"_respawnTime"
];

_respawnTime = 5;

// If respawn is disabled then catch the player and lock them in spectate
if (!(missionNamespace getVariable ["RespawnEnabled", true])) then 
{
	// Disable "Actual" Respawn
	setPlayerRespawnTime 9999;

	// Start spectator
	["Initialize", [player, [], false, true, true, true, true, true, true, false]] call BIS_fnc_EGSpectator;

	// Wait until respawn is enabled again
	waitUntil {
		sleep 1; 
		(missionNamespace getVariable ["RespawnEnabled", true])
	};

	// Set original respawn time
	setPlayerRespawnTime _respawnTime;

	// Respawn the player
	forceRespawn player;

	// Stop spectator
	["Terminate"] call BIS_fnc_EGSpectator;
} 
else 
{
	// Set original respawn time
	setPlayerRespawnTime _respawnTime;
};