/*
	fn_ForcefulPardon.sqf
	Description: Alters default rating return value so that players do not need to be pardoned
	[] call RS_PLYR_fnc_ForcefulPardon;
*/

if (!hasInterface) exitWith {};

// Check if this is enabled
[("SAEF_Player_ForcefulPardon" call CBA_settings_fnc_get)] params [["_var_SAEF_Player_ForcefulPardon", false, [false]]];

if (_var_SAEF_Player_ForcefulPardon) then
{
	["SAEF Player", 0, "Forceful Pardon Enabled"] call RS_fnc_LoggingHelper;
	player addEventHandler ["HandleRating", {0}];
}
else
{
	["SAEF Player", 0, "Forceful Pardon Disabled"] call RS_fnc_LoggingHelper;
};