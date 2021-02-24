/*
	fn_SpawnPresenceModule.sqf
	Description: Handles creation of the Civilian Presence Spawn Point
	Parameters:	
		_pos	- position
*/

params
[
	"_pos",
	"_group"
];

private
[
	"_logic"
];

// Create the Logic
_logic = _group createUnit ["ModuleCivilianPresenceUnit_F",_pos,[],0,"NONE"]; 

// Return Module
_logic

/*
	END
*/