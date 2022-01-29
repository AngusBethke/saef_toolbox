/**
	@namespace RS_CP
	@class CivilianPresence
	@method RS_CP_fnc_PostInit
	@file fn_PostInit.sqf
	@summary Runs all Civilian Presence components that must fire post init
    
**/
/*
	fn_PostInit.sqf

	Description:
		Runs all Civilian Presence components that must fire post init
*/

// New up the message queue
["RS_CP_ModuleCreationQueue"] call RS_MQ_fnc_CreateQueue;