/**
	@namespace RS
	@class Respawn
	@method RS_fnc_ForceRespawnSelf
	@file fn_ForceRespawnSelf.sqf
	@summary Allows a privelaged user to force respawn themselves if necessary

	@usage ```[] call RS_fnc_ForceRespawnSelf;```

**/

/*
	fn_ForceRespawnSelf.sqf
	
	Description:
		Allows a privelaged user to force respawn themselves if necessary

	How to call:
		[] call RS_fnc_ForceRespawnSelf;
*/

player setVariable ["SAEF_Player_ForceRespawnEnabled", true, true];