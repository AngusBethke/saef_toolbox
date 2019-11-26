/*
	fn_Admin_Init.sqf
	Description: Initialises required variables for Admin Utitlies.
*/

if !(isServer) exitWith {};

// Can be overriden
missionNamespace setVariable ["AdminUtil_Enabled", true, true];

[] spawn RS_fnc_Admin_CheckAdmin;