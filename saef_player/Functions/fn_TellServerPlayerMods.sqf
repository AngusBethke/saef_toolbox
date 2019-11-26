/*
	fn_TellServerPlayerMods.sqf
	Description: Gets a list of player mods and logs them on the server, for mod debug purposes.
*/

//_allMods = configSourceModList (configFile >> "CfgMods");
_allMods = configSourceModList (configFile >> "CfgPatches");
_allMods sort true;

_name = name player;
_modString = format ["[RS] [INFO] [MODS] Player: %1 | Loaded Mods: %2", _name, _allMods];
[_modString] remoteExecCall ["diag_log", 2, false];