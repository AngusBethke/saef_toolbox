/*
	Name:			fn_Admin_AddActions.sqf
	Description:	Adds Action to Player for Admin Utilities
*/

// Admin Utilities Parent
_action = ["SAEF_AdminUtils","Admin Utilities","saef_admin\Images\rs_logo.paa", {} ,
	{
		_adminUtilEnabled = (missionNamespace getVariable ["AdminUtil_Enabled", false]);
		
		// Condition - Admin Utilities are enabled and Player is an Admin
		(_adminUtilEnabled && (player getVariable ["RS_IsAdmin", false]))
	}
] call ace_interact_menu_fnc_createAction;

[player, 1, ["ACE_SelfActions", "SAEF_Tools"], _action, true] call ace_interact_menu_fnc_addActionToObject;
_adminUtilsParent = ["ACE_SelfActions", "SAEF_Tools", "SAEF_AdminUtils"];

/* ----------------- */
/* Debug Respawn Pos */
/* ----------------- */
_action = ["SAEF_debug_respawn", "Debug Respawn Position", "",
	{
		// Execution Code Block
		[player] call RS_fnc_Admin_CreateRespawnPos;
	}, 
	{
		// Condition Code Block
		_markerExists = (missionNamespace getVariable ["Admin_RespawnMarkerExists", false]);
		
		// Condition
		!(_markerExists)
	}
] call ace_interact_menu_fnc_createAction;
 
// Add the action to the Player
[player, 1, _adminUtilsParent, _action, true] call ace_interact_menu_fnc_addActionToObject;

/* ------------------------- */
/* Generic Mission Utilities */
/* ------------------------- */
_action = ["SAEF_AdminUtils_Mission","Mission Utilities","", {} ,
	{
		// Condition Code Block
		_numFuncs = (missionNamespace getVariable ["RS_Admin_MissionFunctionsCount", 0]);
		
		// Condition
		(_numFuncs > 0)
	}
] call ace_interact_menu_fnc_createAction;

[player, 1, _adminUtilsParent, _action, true] call ace_interact_menu_fnc_addActionToObject;
 
/* 
	END 
*/