/*
	fn_Init.sqf

	Description:
		Initialises the spectator functions
*/

if (isServer) then
{
	missionNamespace setVariable ["SAEF_SPTR_Destroy_UI", true, true];
	
	// View settings
	["SETSWITCHDELAY", [30]] call SAEF_SPTR_fnc_View;
	["SETVIEWMODE", ["MODE_FPS"]] call SAEF_SPTR_fnc_View;
};

[] spawn SAEF_SPTR_fnc_EventHandler;

// Delayed initialisation
[] spawn {
	waitUntil {
		sleep 0.1;
		!(isNull player)
	}; 

	if ((typeOf player) == "VirtualSpectator_F") then
	{
		["SPECTATOR"] spawn SAEF_SPTR_fnc_Handler;
	};
};