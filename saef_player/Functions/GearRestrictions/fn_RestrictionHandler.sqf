/*
	Function Set: GearRestriction
	fn_RestrictionHandler.sqf
	Description: 	Runs through the conditions under which gear 
					should be yanked from the player for restriction purposes.
	Author: Angus Bethke (a.k.a Rabid Squirrel)
*/

_uniformHint = "I'v got to say, this uniform just doesn't work on me...";
_vestHint = "This vest just isn't my style...";
_headgearHint = "I'm going to get shot wearing this headgear...";
_facewearHint = "I look silly in this facewear...";
_backpackHint = "I'm too tired to carry this backpack...";

if (player getVariable ["RS_GR_RestrictUniform", false]) then {
	_allowed = player getVariable ["RS_GR_AllowedUniforms", [(uniform player)]];
	
	if (!((uniform player) in _allowedUniforms) || ("NONE" in _allowedUniforms)) then {
		// Note: Need to find a way to drop this on the ground
		removeUniform player;
		
		hint format ["%1", (selectRandom (missionNamespace getVariable ["RS_GR_GearUniformHints", _uniformHint]))];
	};
};

if (player getVariable ["RS_GR_RestrictVest", false]) then {
	_allowed = player getVariable ["RS_GR_AllowedVests", [(vest player)]];
	
	if (!((uniform player) in _allowed) || ("NONE" in _allowed)) then {
		// Note: Need to find a way to drop this on the ground
		removeVest player;
		
		hint format ["%1", (selectRandom (missionNamespace getVariable ["RS_GR_GearVestHints", _vestHint]))];
	};
};

if (player getVariable ["RS_GR_RestrictHeadgear", false]) then {
	_allowed = player getVariable ["RS_GR_AllowedHeadgear", [(headgear player)]];
	
	if (!((headgear player) in _allowed) || ("NONE" in _allowed)) then {
		// Note: Need to find a way to drop this on the ground
		removeHeadgear player;
		
		hint format ["%1", (selectRandom (missionNamespace getVariable ["RS_GR_GearHeadgearHints", _headgearHint]))];
	};
};

if (player getVariable ["RS_GR_RestrictFacewear", false]) then {
	_allowed = player getVariable ["RS_GR_AllowedFacewear", [(goggles player)]];
	
	if (!((goggles player) in _allowed) || ("NONE" in _allowed)) then {
		// Note: Need to find a way to drop this on the ground
		removeGoggles player;
		
		hint format ["%1", (selectRandom (missionNamespace getVariable ["RS_GR_GearHeadgearHints", _facewearHint]))];
	};
};

if (player getVariable ["RS_GR_RestrictBackpack", false]) then {
	_allowed = player getVariable ["RS_GR_AllowedBackpacks", [(backpack player)]];
	
	if (!((backpack player) in _allowed) || ("NONE" in _allowed)) then {
		// Note: Need to find a way to drop this on the ground
		removeBackpack player;
		
		hint format ["%1", (selectRandom (missionNamespace getVariable ["RS_GR_GearHeadgearHints", _backpackHint]))];
	};
};
/*
	END
*/