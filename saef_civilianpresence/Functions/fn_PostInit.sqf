/*
	fn_PostInit.sqf

	Description:
		Runs all Civilian Presence components that must fire post init
*/

// New up the message queue
["RS_CP_ModuleCreationQueue"] call RS_MQ_fnc_CreateQueue;