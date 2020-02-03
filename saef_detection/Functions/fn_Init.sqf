/*
	fn_Init.sqf
	Description: Initialises the Detection Function set (to avoid creating multiple event Handlers)
	Original Author: Fritz
	Modified by: Angus Bethke
	
	How to Call:
		[
			EAST,	// The side of those you want to detect you
			true,	// Whether or not the environment influences detection (optional)
			30,		// The standing radius of detection (optional)
			10,		// The crouching radius of detection (optional)
			2,		// The proning radius of detection (optional)
		] call SAEF_Detection_fnc_Init;
*/

if !(hasInterface) exitWith {};

if (!(player getVariable ["SAEF_Detection_Initialised", false])) then
{
	player setVariable ["SAEF_Detection_Initialised", true, true];
	[] call SAEF_Detection_fnc_EventHandler;
};

_this spawn SAEF_Detection_fnc_Handler;

/*
	END
*/