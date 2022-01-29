/**
	@namespace SAEF_VD
	@class ViewDistance
	@method SAEF_VD_fnc_ModuleSpawnAreaVehicle
	@file fn_ModuleSpawnAreaVehicle.sqf
	@summary Handles module functionality for spawn areas

	@param ?object _logic
	@param ?array _units
	@param ?bool _activated


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
];

// If our module is active then we execute
if (_activated) then 
{
	// Get our variables from the module
	private
	[
		"_serverViewDistance"
		,"_playerViewDistance"
		,"_aircraftViewDistance"
		,"_shadowViewDistance"
		,"_fixedCeiling"
	];
	
	_serverViewDistance = _logic getVariable ["ServerViewDistance", 1200];
	_playerViewDistance = _logic getVariable ["PlayerViewDistance", 1200];
	_aircraftViewDistance = _logic getVariable ["AircraftViewDistance", 5000];
	_shadowViewDistance = _logic getVariable ["ShadowViewDistance", 50];
	_fixedCeiling = _logic getVariable ["FixedCeiling", 150];

	// Run the initialisation
	[
		_serverViewDistance,		// (Optional) The default view distance for the server
		_playerViewDistance,		// (Optional) The default view distance for the player
		_aircraftViewDistance,		// (Optional) The default view distance for the aircraft
		_shadowViewDistance,		// (Optional) The default shadow view distance for everyone
		_fixedCeiling				// (Optional) The capped ceiling for max view distance based on height
	] call SAEF_VD_fnc_Init;
};

// We are going to cleanup the module at this point
deleteVehicle _logic;

// Return Function Success
true