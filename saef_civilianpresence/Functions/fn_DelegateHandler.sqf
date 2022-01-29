/**
	@namespace RS_CP
	@class CivilianPresence
	@method RS_CP_fnc_DelegateHandler
	@file fn_DelegateHandler.sqf
	@summary Delgates handling for the civi presence queue
    
**/
/*
	fn_DelegateHandler.sqf
	Description: Delgates handling for the civi presence queue
*/

_this spawn RS_CP_fnc_DelayedCreation;