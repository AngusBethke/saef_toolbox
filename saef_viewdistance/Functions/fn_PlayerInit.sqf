/*
	fn_PlayerInit.sqf

	Description: 
		Initialises the scripts for the player

	How to call: 
		[] call SAEF_VD_fnc_PlayerInit;
*/

// Only player clients should be executing this stuff
if (!hasInterface) exitWith {};

// Setup the view distance for the player
["PLAYER"] call SAEF_VD_fnc_ViewDistance;

// Start up the height based view distance handler
[] spawn SAEF_VD_fnc_HeightBasedViewDistance;

// Setup the respawn event handler to reset view distance
player addEventHandler ["Respawn", {
	params ["_unit", "_corpse"];

	// Setup the view distance for the player when they respawn
	["PLAYER"] call SAEF_VD_fnc_ViewDistance;
}];