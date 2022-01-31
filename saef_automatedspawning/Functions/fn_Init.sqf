/**
	@namespace SAEF_AS
	@class AutomatedSpawning
	@method SAEF_AS_fnc_Init
	@file fn_Init.sqf
	@summary Handles initialisation for the Automated Spawning Toolset
**/
/*
	fn_Init.sqf

	Description:
		Handles initialisation for the Automated Spawning Toolset
*/

// Players get the admin action to export config
if (hasInterface) then
{
	// Parent Action
	_action = ["SAEF_AutomatedSpawning","Automated Spawning","saef_toolbox\Data\SAEF_logo_square.paa", {}, {true}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions", "SAEF_Tools", "SAEF_AdminUtils"], _action, true] call ace_interact_menu_fnc_addActionToObject;

	_utilsParent = ["ACE_SelfActions", "SAEF_Tools", "SAEF_AdminUtils", "SAEF_AutomatedSpawning"];

	// Export Config Action
	_action = ["SAEF_AS_ExportConfig", "Export Config", "", {[] call SAEF_AS_fnc_ExportConfig;}, {true}] call ace_interact_menu_fnc_createAction;
	[player, 1, _utilsParent, _action, true] call ace_interact_menu_fnc_addActionToObject;
};

// We only want the server to handle this
if (!isServer) exitWith {};

// New up the module processing queue
["SAEF_AS_ModuleQueue"] call RS_MQ_fnc_CreateQueue;

// Set up the spawner queue
["SAEF_SpawnerQueue", "All_Headless"] call RS_MQ_fnc_CreateQueue;

// Check that our spawner queue exists and moan if it doesn't
[] spawn {
	sleep 10;
	
	if (!(missionNamespace getVariable ["SAEF_SpawnerQueue_MessageHandler_Run", false])) then
	{
		["SAEF Automated Spawning Init", 2, "[SAEF_SpawnerQueue] Message Queue is not running this will prevent AI spawns from running!"] call RS_fnc_LoggingHelper;
	};
};

[] spawn
{
	// Auto activate editor placed modules on load
	private
	[
		"_unitArray",
		"_modules"
	];

	// Get all the units in the mod
	_unitArray = getArray (configFile >> "CfgPatches" >> "SAEF_TOOLBOX_AUTOMATEDSPAWNING" >> "units");
	_modules = [];

	// Get our modules from the unit array
	{
		_x params ["_unitClassName"];

		// If this is a module
		if ("module_f" == toLower (configName (inheritsFrom (configFile >> "CfgVehicles" >> _unitClassName)))) then
		{
			_modules pushBack _unitClassName;
		};
	} forEach _unitArray;

	// This module will run on it's own
	_modules = _modules - ["SAEF_ModuleSpawnAreaConfigCore"];

	{
		_x params ["_module"];

		// Wait until all of our core modules have finished processing
		waitUntil {
			sleep 0.1;
			((_module getVariable ["ProcessingComplete", false]) || (isNull _module))
		};
	} forEach (entities "SAEF_ModuleSpawnAreaConfigCore");

	// Execute all of our base placed modules
	{
		_x params ["_moduleClassName"];

		{
			_x params ["_module"];

			// Set our default placed modules as active
			_module setVariable ["Active", true, true];

			// Execute the function for our module
			private
			[
				"_function"
			];

			_function = getText (configFile >> "CfgVehicles" >> _moduleClassName >> "function");

			if (!isNil "_function") then
			{
				if (_function != "") then
				{
					private
					[
						"_code",
						"_objects",
						"_activated"
					];

					_code = (call compile _function);

					// If any triggers are synced to this module, and they haven't yet been activated, then we need to flag activated as false.
					_objects = synchronizedObjects _module;

					_activated = true;
					{
						_x params ["_object"];

						if (_object isKindOf "EmptyDetector") then
						{
							if (!(triggerActivated _object)) then
							{
								_activated = false;
							};
						};
					} forEach _objects;

					// Run the function
					if (_activated) then
					{
						["SAEF Automated Spawning Init", 3, (format ["Executing Function [%1] for Module [%2]", _function, _moduleClassName])] call RS_fnc_LoggingHelper;
						[_module, [], _activated] call _code;
					};
				};
			};
		} forEach (entities _moduleClassName);
	} forEach _modules;
};