/*
	XEH_preInit.sqf

	Description:
		Adds the CBA settings for Civilian Presence
*/

["SAEF_Player_ForcefulPardon", "CHECKBOX", "Run Forceful Pardon", "SAEF Player", [], 1, {}, true] call CBA_fnc_addSetting;

// Start up the function
[] call RS_PLYR_fnc_ForcefulPardon;