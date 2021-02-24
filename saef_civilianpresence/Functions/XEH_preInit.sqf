/*
	XEH_preInit.sqf

	Description:
		Adds the CBA settings for Civilian Presence
*/

["SAEF_CivilianPresence_Debug", "CHECKBOX", "Debug Mode", "SAEF Civilian Presence", [], 1, {}, true] call CBA_fnc_addSetting;
["SAEF_CivilianPresence_Enabled", "CHECKBOX", "Enabled", "SAEF Civilian Presence", [], 1, {}, true] call CBA_fnc_addSetting;
//["SAEF_CivilianPresence_RunOnServer", "CHECKBOX", "Run on Server", "SAEF Civilian Presence", [], 1, {}, true] call CBA_fnc_addSetting;
//["SAEF_CivilianPresence_RunOnClient", "CHECKBOX", "Run on Client", "SAEF Civilian Presence", [], 1, {}, true] call CBA_fnc_addSetting;
["SAEF_CivilianPresence_UseAgents", "CHECKBOX", "Use Agents", "SAEF Civilian Presence", [], 1, {}, true] call CBA_fnc_addSetting;
["SAEF_CivilianPresence_UsePanicMode", "CHECKBOX", "Use Panic Mode", "SAEF Civilian Presence", [], 1, {}, true] call CBA_fnc_addSetting;
["SAEF_CivilianPresence_ExecutionLocality", "LIST", "Execution Locality", "SAEF Civilian Presence", [["HC1", "HC2", "HC3", "<no-target>"], ["Headless Client 1", "Headless Client 2", "Headless Client 3", "Server"], 0], 1, {}, true] call CBA_fnc_addSetting;
//["SAEF_CivilianPresence_Run_UnitTypeHandler", "CHECKBOX", "Run UnitType Handler", "SAEF Civilian Presence", [], 1, {}, true] call CBA_fnc_addSetting;
["SAEF_CivilianPresence_MaxUnitCount", "SLIDER", "Maximum AI per Location ", "SAEF Civilian Presence", [10, 30, 24, 0], 1, {}, true] call CBA_fnc_addSetting;
["SAEF_CivilianPresence_MaxTotalUnitCount", "SLIDER", "Maximum Total AI", "SAEF Civilian Presence", [10, 100, 48, 0], 1, {}, true] call CBA_fnc_addSetting;
["SAEF_CivilianPresence_SupportedLocationTypes_String", "EDITBOX", "Supported Location Types", "SAEF Civilian Presence", [], 1, {}, true] call CBA_fnc_addSetting;
["SAEF_CivilianPresence_CustomLocations", "EDITBOX", "Custom Locations", "SAEF Civilian Presence", [], 1, {}, true] call CBA_fnc_addSetting;
["SAEF_CivilianPresence_Whitelist", "EDITBOX", "Whitelisted Locations", "SAEF Civilian Presence", [], 1, {}, true] call CBA_fnc_addSetting;
["SAEF_CivilianPresence_UnitTypes_String", "EDITBOX", "Unit Types", "SAEF Civilian Presence", [], 1, {}, true] call CBA_fnc_addSetting;

// Start up the function
[] call RS_CP_fnc_Init;