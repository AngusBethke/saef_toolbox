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

diag_log format ["[RS] [ACE] [Prevent Full Heal] Attaching Event Handler to Player ..."];

["ace_treatmentSucceded", { _this call RS_fnc_PFH_Prevent; }] call CBA_fnc_addEventHandler;