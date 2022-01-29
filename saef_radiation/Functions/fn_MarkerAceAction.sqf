/**
	@namespace RS_Radiation
	@class Radiation
	@method RS_Radiation_fnc_MarkerAceAction
	@file fn_MarkerAceAction.sqf
	@summary Adds an ace interaction to show and hide the radiation markers

	@usage ```[] call RS_Radiation_fnc_MarkerAceAction;```

**/

/*
	fn_MarkerAceAction.sqf
	Description: Adds an ace interaction to show and hide the radiation markers
	[] call RS_Radiation_fnc_MarkerAceAction;
*/

_action = ["toggle_rad_markers","Toggle Radiation Markers","saef_radiation\Images\rad_icon.paa",
	{
		if (!(player getVariable ["RS_RadiationZone_ShowMarkers", false])) then
		{
			player setVariable ["RS_RadiationZone_ShowMarkers", true, true];
		}
		else
		{
			player setVariable ["RS_RadiationZone_ShowMarkers", false, true];
		};
	}, 
	{visibleMap}
] call ace_interact_menu_fnc_createAction;
 
// Add the action to the Player
[player, 1, ["ACE_SelfActions"], _action, true] call ace_interact_menu_fnc_addActionToObject;

hint "Radiation Map Available";