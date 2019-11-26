/*
	Name:			fn_TogglePlayerHud.sqf
	Description:	Adds ACE Action to Player to allow them to toggle their Hud
*/

if (!hasInterface) exitWith {}:

private 
[
	 "_hudStatus"
	,"_action"
];

_hudStatus = shownHUD;
player setVariable ["RS_PlayerHudStatus", _hudStatus, true];
 
_action = ["toggle_hud","Toggle HUD","",
	{
		// Get our HUD status
		_hudStatus = shownHUD;
		_hudCount = 0;
		
		{
			if (!_x) then
			{
				_hudCount = _hudCount + 1;
			};
		} forEach _hudStatus;
		
		// If _hudCount is the same as the array's length, then we know that the hud is off
		if (_hudCount == (count shownHUD)) then
		{
			// Return player hud to their original settings
			showHUD (player getVariable "RS_PlayerHudStatus");
		}
		else
		{
			// Kill the player hud
			showHUD [false, false, false, false, false, false, false, false, false, false];
		};
	}, 
	{!visibleMap}
] call ace_interact_menu_fnc_createAction;
 
// Add the action to the Player
[player, 1, ["ACE_SelfActions"], _action, true] call ace_interact_menu_fnc_addActionToObject;

/*
	END
*/