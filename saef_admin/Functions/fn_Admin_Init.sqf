/*
	fn_Admin_Init.sqf
	Description: Initialises required variables for Admin Utitlies.
*/

[] spawn RS_fnc_Admin_CheckAdmin;

// Run our mission maker helper (to moan if something is missing)
if (hasInterface && ((serverCommandAvailable "#logout") || (isServer))) then
{
	[] spawn RS_fnc_Admin_MissionMakerHelper;
};

if !(isServer) exitWith {};

// Can be overriden
missionNamespace setVariable ["AdminUtil_Enabled", true, true];