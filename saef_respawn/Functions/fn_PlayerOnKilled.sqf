/**
	@namespace RS
	@class Respawn
	@method RS_fnc_PlayerOnKilled
	@file fn_PlayerOnKilled.sqf
	@summary Runs on player death as per added event handler 


**/

/*
	fn_PlayerOnKilled.sqf
	Description: Runs on player death as per added event handler 
*/

private
[
	"_respawnTime",
	"_initDelay",
	"_spectatorParams"
];

_respawnTime = 5;
_initDelay = missionNamespace getVariable ["SAEF_Respawn_InitDelay", 0.1];
_spectatorParams = missionNamespace getVariable ["SAEF_Respawn_SpectatorParams", [[], false, true, true, true, true, true, true, false]];

_spectatorParams = [player] + _spectatorParams;

// If respawn is disabled then catch the player and lock them in spectate
if (!(missionNamespace getVariable ["RespawnEnabled", true])) then 
{
	// Mark that the player is currently awaiting respawn
	player setVariable ["SAEF_Respawn_AwaitingRespawn", true, true];
	
	// Disable "Actual" Respawn
	setPlayerRespawnTime 9999;

	sleep _initDelay;

	// Start spectator
	["Initialize", _spectatorParams] call BIS_fnc_EGSpectator;

	// Wait until respawn is enabled again or we are forcing respawn for an existing player
	waitUntil {
		sleep 1; 
		((missionNamespace getVariable ["RespawnEnabled", true]) || (player getVariable ["SAEF_Player_ForceRespawnEnabled", false]))
	};

	// Reset forced variable
	player setVariable ["SAEF_Player_ForceRespawnEnabled", nil, true];

	// Set original respawn time
	setPlayerRespawnTime _respawnTime;

	// Respawn the player
	forceRespawn player;

	// Stop spectator
	["Terminate"] call BIS_fnc_EGSpectator;

	// Mark that the player is no longer awaiting respawn
	player setVariable ["SAEF_Respawn_AwaitingRespawn", false, true];
} 
else 
{
	// Set original respawn time
	setPlayerRespawnTime _respawnTime;
};