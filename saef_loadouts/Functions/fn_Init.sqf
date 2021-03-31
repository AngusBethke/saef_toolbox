/*
	fn_Init.sqf

	Description:
		Runs initialisation for the SAEF loadout toolset
*/

// Only the server will process this
if (!isServer) exitWith {};

["SAEF_LoadoutQueue"] call RS_MQ_fnc_CreateQueue;