/*
	fn_CP_SpawnPresenceModule.sqf
	Description: Handles creation of the Civilian Presence Spawn Point
	Parameters:	
		_pos	- position
*/


// Input Parameters
_pos = _this select 0;
_group = _this select 1;

// Create the Logic
_logic = _group createUnit ["ModuleCivilianPresenceUnit_F",_pos,[],0,"NONE"]; 

// Return Module
_logic

// End