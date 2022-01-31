/**
	@namespace RS
	@class PreventFullHeal
	@method RS_fnc_PFH_ServerInit
	@file fn_PFH_ServerInit.sqf
	@summary Declares global handler variables
**/

/*
	fn_PFH_ServerInit.sqf
	Description: Declares global handler variables
	Author: Angus Bethke (a.k.a. Rabid Squirrel)
*/

missionNamespace setVariable ["PFH_RunFullHealPrevention", true, true];
missionNamespace setVariable ["PFH_Debug", true, true];