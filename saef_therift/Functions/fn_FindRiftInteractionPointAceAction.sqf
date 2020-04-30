/*
	fn_FindRiftInteractionPointAceAction.sqf
	Description: Adds an ace interaction to enable the rift interaction point locator
	[] call RS_Rift_fnc_FindRiftInteractionPointAceAction;
*/

_parentActionName = "Rift_Locator";

// --- Parent Action --- //
_action = [_parentActionName,"Rift Interaction","saef_radiation\Images\rad_icon.paa", {},{true}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions"], _action, true] call ace_interact_menu_fnc_addActionToObject;

// --- Toggle on Locator Action --- //
_action = ["Toggle_On_Rift_Locator","Turn On Locator","",
	{
		// Setup the Rift Interaction Locator
		player setVariable ["RS_Rift_Run_InteractionLocateHandler", true, true];
		[500, player, "RS_Rift_Run_InteractionLocateHandler"] spawn RS_Rift_fnc_FindRiftInteractionPoint;
	}, 
	{
		!(player getVariable ["RS_Rift_Run_InteractionLocateHandler", false])
	}
] call ace_interact_menu_fnc_createAction;
 
// Add the action to the Player
[player, 1, ["ACE_SelfActions", _parentActionName], _action, true] call ace_interact_menu_fnc_addActionToObject;

// --- Toggle off Locator Action --- //
_action = ["Toggle_Off_Rift_Locator","Turn Off Locator","",
	{
		// Setup the Rift Interaction Locator
		player setVariable ["RS_Rift_Run_InteractionLocateHandler", false, true];
	}, 
	{
		(player getVariable ["RS_Rift_Run_InteractionLocateHandler", false])
	}
] call ace_interact_menu_fnc_createAction;
 
// Add the action to the Player
[player, 1, ["ACE_SelfActions", _parentActionName], _action, true] call ace_interact_menu_fnc_addActionToObject;

// --- Create Rift Interaction Point --- //
_action = ["Create_Rift_Point","Create Rift Interaction Point","",
	{
		_object = [player] call RS_Rift_fnc_GetNearestRiftInteractionPoint;
		
		if (!(isNull _object)) then
		{
			[_object, "CTRL"] spawn RS_Rift_fnc_CreateRiftInteractionPoint;
		};
	}, 
	{
		_object = [player] call RS_Rift_fnc_GetNearestRiftInteractionPoint;
		_condition = false;
		
		if (!(isNull _object)) then
		{
			if ((_object distance player) <= 10) then
			{
				_condition = true;
			};
		};
		
		_condition
	}
] call ace_interact_menu_fnc_createAction;
 
// Add the action to the Player
[player, 1, ["ACE_SelfActions", _parentActionName], _action, true] call ace_interact_menu_fnc_addActionToObject;

/*
	END
*/