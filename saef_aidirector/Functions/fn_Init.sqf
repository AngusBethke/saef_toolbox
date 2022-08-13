/*
	fn_Init.sqf

	Description:
		Handles initialisation of the script component
*/

// Server should be responsible for everything past this point
if (!isServer) exitWith {};

// Set the default difficulty - will be normal, can be overridden during initialisation
["SET", [(["GET"] call SAEF_AID_fnc_Difficulty)]] call SAEF_AID_fnc_Difficulty;

// Initialise the director handler
["HANDLE"] spawn SAEF_AID_fnc_Director;