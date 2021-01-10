/*
	fn_TogglePlayerHud.sqf

	Description:
		Adds ACE Action to Player to allow them to toggle their Hud

	How to Call:
		[] call RS_PLYR_fnc_TogglePlayerHud;
*/

if (!hasInterface) exitWith {};

private 
[
	 "_hudStatus"
	,"_action"
];

_hudStatus = shownHUD;
player setVariable ["RS_PlayerHudStatus", _hudStatus, true];
 
_action = ["rs_toggle_hud","Toggle HUD","",
	{
		_allOff = shownHUD;
		{
			_allOff set [_forEachIndex, false];
		} forEach _allOff;
		
		// If the hud is off
		if (_allOff isEqualTo shownHUD) then
		{
			// Return player hud to their original settings
			showHUD (player getVariable "RS_PlayerHudStatus");
		}
		else
		{
			// Else, turn the hud off
			showHUD _allOff;
		};
	}, 
	{!visibleMap}
] call ace_interact_menu_fnc_createAction;
 
// Add the action to the Player
[player, 1, ["ACE_SelfActions"], _action, true] call ace_interact_menu_fnc_addActionToObject;

/*
	END
*/