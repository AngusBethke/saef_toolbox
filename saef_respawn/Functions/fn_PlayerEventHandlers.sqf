/*
	fn_PlayerEventHandlers.sqf
	Description: Adds player event handlers for respawn
*/

player addEventHandler ["killed", 
{
	[] spawn RS_fnc_PlayerOnKilled;
}];

// Parent Action
_action = ["SAEF_RespawnHint","Respawn Hints","saef_admin\Images\rs_logo.paa", {}, {true}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions"], _action, true] call ace_interact_menu_fnc_addActionToObject;
_respawnUtilsParent = ["ACE_SelfActions", "AdminUtils"];

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

/*
	END
*/