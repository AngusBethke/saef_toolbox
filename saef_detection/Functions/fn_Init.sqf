/**
	@namespace SAEF_Detection
	@class Detection
	@method SAEF_Detection_fnc_Init
	@file fn_Init.sqf
	@summary Initialises the Detection Function set (to avoid creating multiple event Handlers)

	@todo Doesn't have any params? Possible error?

	@note Original Author: Fritz
	@note Modified by: Angus Bethke
**/
/*
	fn_Init.sqf
	Description: Initialises the Detection Function set (to avoid creating multiple event Handlers)
	Original Author: Fritz
	Modified by: Angus Bethke
	
	How to Call:
		[
			[EAST],	// The side(s) of those you want to detect you
			true,	// Whether or not the environment influences detection (optional)
			30,		// The standing radius of detection (optional)
			10,		// The crouching radius of detection (optional)
			2,		// The proning radius of detection (optional)
			{true}	// Code that can be used to interrupt processing
		] call SAEF_Detection_fnc_Init;
		
	Examples:
		[[EAST], true] spawn SAEF_Detection_fnc_Init;
		[[EAST, INDEPENDENT], false] spawn SAEF_Detection_fnc_Init;
*/

if !(hasInterface) exitWith {};

if (!(player getVariable ["SAEF_Detection_Initialised", false])) then
{
	player setVariable ["SAEF_Detection_Initialised", true, true];
	_this call SAEF_Detection_fnc_EventHandler;
};

_this spawn SAEF_Detection_fnc_Handler;

/*
	END
*/