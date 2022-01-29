/**
	@namespace RS_Radiation
	@class Radiation
	@method RS_Radiation_fnc_DeferredInit
	@file fn_DeferredInit.sqf
	@summary Handles suspended initialisation

**/

/*
	fn_DeferredInit.sqf
	Description: Handles suspended initialisation
	Author: Angus Bethke a.k.a. Rabid Squirrel
*/

waitUntil {
	sleep 1;
	(!isNull player)
};

[] spawn RS_Radiation_fnc_Zone;