/**
	@namespace RS_CP
	@class CivilianPresence
	@method RS_CP_fnc_CorecreateUnit
	@file fn_CorecreateUnit.sqf
	@summary Handles the creation of units for civilian presence

	@param object _module
	@param array _pos

	@return unit Created unit

**/

#include "\A3\modules_F_Tacops\Ambient\CivilianPresence\defines.inc"

/*
	fn_CorecreateUnit.sqf
	Description: Handles the creation of units for civilian presence

	Originally Developed by Bohemia interactive
*/

params
[
    ["_module", objNull, [objNull]],
    ["_pos", [], [[]]]
];

// randomize position
if (count _pos == 0) then 
{
    _pos = getPos selectRandom (_module getVariable ["#modulesUnit", []]);
};

private _posASL = (AGLtoASL _pos) vectorAdd [0, 0, 1.5];

// Check if any player can see the point of creation
private _seenBy = allplayers select {
    _x distance _pos < 50 || {
        (_x distance _pos < 150 && {
            ([_x, "VIEW"] checkVisibility [eyePos _x, _posASL]) > 0.5
        })
    }
};

// terminate if any player can see the position
if (count _seenBy > 0) exitwith 
{
    objNull
};

private _class = format["CivilianPresence_%1", selectRandom (_module getVariable ["#UnitTypes", []])];

private _unit = if (_module getVariable ["#useAgents", true]) then 
{
    createAgent [_class, _pos, [], 0, "NONE"];
} 
else 
{
    (creategroup civilian) createUnit [_class, _pos, [], 0, "NONE"];
};

// Make backlink to the core module
_unit setVariable ["#core", _module];

_unit setBehaviour "CARELESS";
_unit spawn (_module getVariable ["#onCreated", {}]);
_unit execFSM "A3\modules_F_Tacops\Ambient\CivilianPresence\FSM\behavior.fsm";

private _customClass = selectRandom (_module getVariable ["#unitTypesOverride", [""]]);
[_unit, _customClass] spawn
{
    params
    [
        "_unit",
        "_customClass"
    ];
    
    if (_customClass != "") then 
	{
        _unit setUnitLoadout (getUnitloadout (configFile >> "Cfgvehicles" >> _customClass));
        
        ([_unit, _customClass] call RS_CP_fnc_GetCompatiblefacesfromConfig) params ["_face", "_voice"];
        [_unit, _face, _voice] remoteExecCall ["BIS_fnc_setIdentity", 0, true];
    };
};

_unit