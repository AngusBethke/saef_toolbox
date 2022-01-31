/**
	@namespace RS
	@class Respawn
	@method RS_fnc_RespawnPlayerInit
	@file fn_RespawnPlayerHandler.sqf
	@summary Adds player event handlers for respawn

**/

#include "\a3\ui_f\hpp\defineDIKCodes.inc"

/*
	fn_RespawnPlayerInit.sqf
	Description: Adds player event handlers for respawn
*/

// Killed event handler
player addEventHandler ["killed", 
{
	[] spawn RS_fnc_PlayerOnKilled;
}];

// ---- Removed as key binds cannot be used in spectator mode ---- //
/*
// Key press for respawn information
if (!isNil "CBA_fnc_addKeybind") then
{
	[
		"SAEF - Respawn", "SAEF_RespawnInfoKeyBind", ["Respawn Information", "Displays respawn information in the spectator screen when pressed"], 
		{
			// On key down we will display the information (if they are in the spectator screen)
			if (player getVariable ["SAEF_Respawn_AwaitingRespawn", false]) then
			{
				[] call RS_fnc_RespawnInformation;
			};
		},
		{
			// On key up we will display the information (if they are in the spectator screen)
			if (player getVariable ["SAEF_Respawn_AwaitingRespawn", false]) then
			{
				[] call RS_fnc_RespawnInformation;
			};
		},
		[DIK_R, [false, false, false]]
	] call CBA_fnc_addKeybind;
};
*/

// Parent Action
_action = ["SAEF_RespawnHint","Respawn Hints","saef_admin\Images\rs_logo.paa", {}, {true}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions", "SAEF_Tools"], _action, true] call ace_interact_menu_fnc_addActionToObject;
_respawnUtilsParent = ["ACE_SelfActions", "SAEF_Tools", "SAEF_RespawnHint"];

// Enable Respawn Hints
_action = ["SAEF_RespawnHint_Enable", "Enable", "",
	{
		// Execution Code Block
		player setVariable ["RespawnHandlerHint", true, true];
	}, 
	{
		// Condition Code Block
		!(player getVariable ["RespawnHandlerHint", false]);
	}
] call ace_interact_menu_fnc_createAction;
 
// Add the action to the Player
[player, 1, _respawnUtilsParent, _action, true] call ace_interact_menu_fnc_addActionToObject;

// Disable Respawn Hints
_action = ["SAEF_RespawnHint_Disable", "Disable", "",
	{
		// Execution Code Block
		player setVariable ["RespawnHandlerHint", false, true];
	}, 
	{
		// Condition Code Block
		(player getVariable ["RespawnHandlerHint", false]);
	}
] call ace_interact_menu_fnc_createAction;
 
// Add the action to the Player
[player, 1, _respawnUtilsParent, _action, true] call ace_interact_menu_fnc_addActionToObject;

// Disable Respawn Hints
_action = ["SAEF_RespawnInformation", "Information", "",
	{
		// Execution Code Block
		[] call RS_fnc_RespawnInformation;
	}, 
	{true}
] call ace_interact_menu_fnc_createAction;
 
// Add the action to the Player
[player, 1, _respawnUtilsParent, _action, true] call ace_interact_menu_fnc_addActionToObject;

/* -------------- */
/* ENABLE RESPAWN */
/* -------------- */
_adminUtilsParent = ["ACE_SelfActions", "SAEF_Tools", "SAEF_AdminUtils"];
_action = ["enable_respawn", "Enable Respawn", "",
	{
		// Execution Code Block
		_respawnEnabled = (missionNamespace getVariable ["RespawnEnabled", true]);
		
		if !(_respawnEnabled) then
		{
			missionNamespace setVariable ["RespawnEnabled", true, true];
		}
		else
		{
			hint "Respawn is already enabled!";
		};
	}, 
	{
		// Condition Code Block
		_respawnDisabled = !(missionNamespace getVariable ["RespawnEnabled", true]);
		
		// Condition
		_respawnDisabled
	}
] call ace_interact_menu_fnc_createAction;
 
// Add the action to the Player
[player, 1, _adminUtilsParent, _action, true] call ace_interact_menu_fnc_addActionToObject;

/* --------------- */
/* Disable RESPAWN */
/* --------------- */
_action = ["disable_respawn", "Disable Respawn", "",
	{
		// Execution Code Block
		_respawnDisabled = !(missionNamespace getVariable ["RespawnEnabled", true]);
		
		if !(_respawnDisabled) then
		{
			missionNamespace setVariable ["RespawnEnabled", false, true];
		}
		else
		{
			hint "Respawn is already disabled!";
		};
	}, 
	{
		// Condition Code Block
		_respawnEnabled = (missionNamespace getVariable ["RespawnEnabled", true]);
		
		// Condition
		_respawnEnabled
	}
] call ace_interact_menu_fnc_createAction;
 
// Add the action to the Player
[player, 1, _adminUtilsParent, _action, true] call ace_interact_menu_fnc_addActionToObject;

[_adminUtilsParent] call RS_fnc_RespawnPlayerHandler;

/*
	END
*/