/**
	@namespace SAEF_AS
	@class AutomatedSpawning
	@method SAEF_AS_fnc_ModuleSpawnAreaVehicle
	@file fn_ModuleSpawnAreaVehicle.sqf
	@summary Handles module functionality for spawn areas

	@param object _logic
	@param array _units
	@param bool _activated
	@param bool _fromQueue

	@todo Empty script? Strange.
**/
/*
	fn_ModuleSpawnAreaVehicle.sqf

	Description:
		Handles module functionality for spawn areas
*/

if (!isServer) exitWith {};

if (is3DEN) exitWith {};

params
[
	 ["_logic", objNull, [objNull]]
	,["_units", [], [[]]]
	,["_activated", true, [true]]
	,["_fromQueue", false, [false]]
];

// If our module is active then we execute
if (_activated) then 
{
	// We aint doing nothing
};

// Return Function Success
true