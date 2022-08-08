/**
	@namespace RS
	@class PreventFullHeal
	@method RS_fnc_PFH_Init
	@file fn_PFH_Init.sqf
	@summary  Adds event handlers to players for Full Heal Prevention
**/

/*
	fn_PFH_Init.sqf
	Description: Adds event handlers to players for Full Heal Prevention
	Author: Angus Bethke (a.k.a. Rabid Squirrel)
*/

if !(hasInterface) exitWith {};

["Prevent Full Heal", 0, "Attaching Event Handler to Player ..."] call RS_fnc_LoggingHelper;

["ace_treatmentSucceded", { _this call RS_fnc_PFH_Prevent; }] call CBA_fnc_addEventHandler;