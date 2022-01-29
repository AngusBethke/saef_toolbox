/**
	@namespace SAEF_AS
	@class AS
	@file XEH_preInit.sqf
	@summary Adds the CBA settings for DynaSpawn
**/
/*
	XEH_preInit.sqf

	Description:
		Adds the CBA settings for DynaSpawn
*/

["SAEF_AutomatedSpawning_ZeusHint", "CHECKBOX", "Hint Information to Zeus", "SAEF Automated Spawning", [], 1, {}, false] call CBA_fnc_addSetting;
["SAEF_AutomatedSpawning_ExtendedLogging", "CHECKBOX", "Enable Extended Logging", "SAEF Automated Spawning", [], 1, {}, false] call CBA_fnc_addSetting;