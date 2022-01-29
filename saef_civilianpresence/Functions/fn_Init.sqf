/**
	@namespace RS_CP
	@class CivilianPresence
	@method RS_CP_fnc_Init
	@file fn_Init.sqf
	@summary Launches Civilian Presence Modules
    
	@note Interesting discovery, it appears that module must run on all clients and server in order to work.
	@note BIS must have planned this when building the modules (as I suspect they get loaded on all connected clients and the server when in module format)
	@note I have no idea what the implication is on server performance with this running, hopeful that it isn't terrible.

**/
/*
	fn_Init.sqf
	Description: Launches Civilian Presence Modules
	Note: 	Interesting discovery, it appears that module must run on all clients and server in order to work.
			BIS must have planned this when building the modules (as I suspect they get loaded on all connected clients and the server when in module format).
			I have no idea what the implication is on server performance with this running, hopeful that it isn't terrible.
*/

// Make sure we're not in 3DEN when this happens
if (is3DEN) exitWith {};

// Take two of making this server only
if (!isServer) exitWith {};

// Check if this is enabled
[("SAEF_CivilianPresence_Enabled" call CBA_settings_fnc_get)] params [["_var_SAEF_CivilianPresence_Enabled", false, [false]]];

if (_var_SAEF_CivilianPresence_Enabled) exitWith
{
	private
	[
		"_unitTypes",
		"_supportedLocationTypes"
	];

	// Safely set up all the variables from CBA
	[("SAEF_CivilianPresence_Enabled" call CBA_settings_fnc_get)] params [["_var_SAEF_CivilianPresence_RunOnServer", false, [false]]];
	[("SAEF_CivilianPresence_Enabled" call CBA_settings_fnc_get)] params [["_var_SAEF_CivilianPresence_RunOnClient", false, [false]]];
	[("SAEF_CivilianPresence_Run_UnitTypeHandler" call CBA_settings_fnc_get)] params [["_var_SAEF_CivilianPresence_Run_UnitTypeHandler", false, [false]]];
	[("SAEF_CivilianPresence_Debug" call CBA_settings_fnc_get)] params [["_var_SAEF_CivilianPresence_Debug", false, [false]]];
	[("SAEF_CivilianPresence_UseAgents" call CBA_settings_fnc_get)] params [["_var_SAEF_CivilianPresence_UseAgents", false, [false]]];
	[("SAEF_CivilianPresence_UsePanicMode" call CBA_settings_fnc_get)] params [["_var_SAEF_CivilianPresence_UsePanicMode", false, [false]]];
	[("SAEF_CivilianPresence_SupportedLocationTypes_String" call CBA_settings_fnc_get)] params [["_var_SAEF_CivilianPresence_SupportedLocationTypes", "", ["STRING"]]];
	[("SAEF_CivilianPresence_Whitelist" call CBA_settings_fnc_get)] params [["_var_SAEF_CivilianPresence_Whitelist", "", ["STRING"]]];
	[("SAEF_CivilianPresence_UnitTypes_String" call CBA_settings_fnc_get)] params [["_var_SAEF_CivilianPresence_UnitTypes", "", ["STRING"]]];
	[("SAEF_CivilianPresence_CustomLocations" call CBA_settings_fnc_get)] params [["_var_SAEF_CivilianPresence_CustomLocations", "", ["STRING"]]];
	[("SAEF_CivilianPresence_MaxUnitCount" call CBA_settings_fnc_get)] params [["_var_SAEF_CivilianPresence_MaxUnitCount", 24, [0]]];
	[("SAEF_CivilianPresence_MaxTotalUnitCount" call CBA_settings_fnc_get)] params [["_var_SAEF_CivilianPresence_MaxTotalUnitCount", 48, [0]]];
	[("SAEF_CivilianPresence_ExecutionLocality" call CBA_settings_fnc_get)] params [["_var_SAEF_CivilianPresence_ExecutionLocality", "HC1", ["STRING"]]];

	// Notify that we've launched
	[
		"RS Civilian Presence", 
		0, 
		(format [
			"Civilian Presence Launching with Parameters: [RunOnServer: %1], [RunOnClient: %2], [RunUnitTypeHandler: %3], [Debug: %4], [UseAgents: %5], [UsePanicMode: %6], [MaxUnitCount: %7], [MaxTotalUnitCount: %8]",
			_var_SAEF_CivilianPresence_RunOnServer,
			_var_SAEF_CivilianPresence_RunOnClient,
			_var_SAEF_CivilianPresence_Run_UnitTypeHandler,
			_var_SAEF_CivilianPresence_Debug,
			_var_SAEF_CivilianPresence_UseAgents,
			_var_SAEF_CivilianPresence_UsePanicMode,
			_var_SAEF_CivilianPresence_MaxUnitCount,
			_var_SAEF_CivilianPresence_MaxTotalUnitCount
		])
	] call RS_fnc_LoggingHelper;

	_supportedLocationTypes = [];
	if (_var_SAEF_CivilianPresence_SupportedLocationTypes != "") then
	{
		_supportedLocationTypes = _var_SAEF_CivilianPresence_SupportedLocationTypes splitString ",";
	}
	else
	{
		_supportedLocationTypes = ["NameCity", "NameCityCapital", "NameVillage", "NameLocal"];
	};

	_unitTypes = [];
	if (_var_SAEF_CivilianPresence_UnitTypes != "") then
	{
		_unitTypes = _var_SAEF_CivilianPresence_UnitTypes splitString ",";
	};

	// Control Variables
	missionNamespace setVariable ["SAEF_CivilianPresence_Enabled", _var_SAEF_CivilianPresence_Enabled, true];
	missionNamespace setVariable ["SAEF_CivilianPresence_RunOnServer", _var_SAEF_CivilianPresence_RunOnServer, true];
	missionNamespace setVariable ["SAEF_CivilianPresence_RunOnClient", _var_SAEF_CivilianPresence_RunOnClient, true];
	missionNamespace setVariable ["SAEF_CivilianPresence_Run_UnitTypeHandler", _var_SAEF_CivilianPresence_Run_UnitTypeHandler, true];
	missionNamespace setVariable ["SAEF_CivilianPresence_UnitTypes", _unitTypes, true];
	missionNamespace setVariable ["SAEF_CivilianPresence_SupportedLocationTypes", _supportedLocationTypes, true];
	missionNamespace setVariable ["SAEF_CivilianPresence_MaxTotalUnitCount", _var_SAEF_CivilianPresence_MaxTotalUnitCount, true];
	missionNamespace setVariable ["SAEF_CivilianPresence_MaxUnitCount", _var_SAEF_CivilianPresence_MaxUnitCount, true];
	missionNamespace setVariable ["SAEF_CivilianPresence_ExecutionLocality", _var_SAEF_CivilianPresence_ExecutionLocality, true];

	// Waits for custom locations to be defined (if any)
	if (_var_SAEF_CivilianPresence_CustomLocations != "") then
	{
		[_var_SAEF_CivilianPresence_CustomLocations] call RS_CP_fnc_AddCustomLocations;
	};

	[
		_var_SAEF_CivilianPresence_Debug,				// Debug
		{
			[_this] call RS_CP_fnc_UnitInit;
		}, 
		{}, 
		_var_SAEF_CivilianPresence_UseAgents, 			// Use Agents
		_var_SAEF_CivilianPresence_UsePanicMode,		// Use Panic Mode
		_var_SAEF_CivilianPresence_Whitelist,			// Whitelist
		_unitTypes										// Unit Types to Spawn
	] call RS_CP_fnc_Handler;

	// Run the unit type handler
	if (_var_SAEF_CivilianPresence_Run_UnitTypeHandler) then
	{
		[] spawn RS_CP_fnc_UnitTypeHandler;
	};
};

["RS Civilian Presence", 0, "Civilian Presence Disabled..."] call RS_fnc_LoggingHelper;