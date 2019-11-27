/*
	fn_Admin_Init.sqf
	Description: Initialises required variables for Admin Utitlies.
*/

[] spawn RS_fnc_Admin_CheckAdmin;

if !(isServer) exitWith {};

// Can be overriden
missionNamespace setVariable ["AdminUtil_Enabled", true, true];