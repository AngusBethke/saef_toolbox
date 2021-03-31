/*
	XEH_preInit.sqf

	Description:
		Adds the CBA settings for DynaSpawn
*/

["SAEF_DynaSpawn_AddToZeus", "CHECKBOX", "Add Units to Zeus", "SAEF Dyna Spawn", [], 1, {}, false] call CBA_fnc_addSetting;
["SAEF_DynaSpawn_DynamicGarrison", "CHECKBOX", "Enable Dynamic Garrison", "SAEF Dyna Spawn", [], 1, {}, false] call CBA_fnc_addSetting;
["SAEF_DynaSpawn_ExtendedLogging", "CHECKBOX", "Enable Extended Logging", "SAEF Dyna Spawn", [], 1, {}, false] call CBA_fnc_addSetting;