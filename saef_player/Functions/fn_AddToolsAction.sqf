/*
	fn_AddToolsAction.sqf
	Description: Adds the tools ace action to nest all saef tools under
*/

_action = ["SAEF_Tools","Tools","saef_toolbox\Data\SAEF_logo_square.paa", {}, {true}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions"], _action, true] call ace_interact_menu_fnc_addActionToObject;