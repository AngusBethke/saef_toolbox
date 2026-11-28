/*
	fn_Init.sqf

	Description:
		Initialises paradrop variables for running of the handler
*/

// We only want the server to handle this
if (!isServer) exitWith {};

missionNamespace setVariable ["SAEF_ASA_INS_ParadropVehicles", (missionNamespace getVariable ["SAEF_ASA_INS_ParadropVehicles", []]), true];
missionNamespace setVariable ["SAEF_ASA_INS_HeavyParadropVehicles", (missionNamespace getVariable ["SAEF_ASA_INS_HeavyParadropVehicles", []]), true];
missionNamespace setVariable ["SAEF_ASA_INS_ParadropVehicle_Side", (missionNamespace getVariable ["SAEF_ASA_INS_ParadropVehicle_Side", CIVILIAN]), true];
missionNamespace setVariable ["SAEF_ASA_INS_ParadropCargoItems", (missionNamespace getVariable ["SAEF_ASA_INS_ParadropCargoItems", []]), true];

// Create our message queue
["SAEF_ASA_INS_Queue"] call RS_MQ_fnc_CreateQueue;