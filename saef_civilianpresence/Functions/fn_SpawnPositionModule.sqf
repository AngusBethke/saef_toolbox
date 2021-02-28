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
_logic = _group createUnit ["Logic",_pos,[],0,"NONE"]; // ModuleCivilianPresenceUnit_F
_logic setVariable ["LogicType", "ModuleCivilianPresenceUnit_F", true];

// Return Module
_logic

/*
	END
*/