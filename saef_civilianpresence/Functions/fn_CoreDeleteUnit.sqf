/**
	@namespace RS_CP
	@class CivilianPresence
	@method RS_CP_fnc_CoreDeleteUnit
	@file fn_CoreDeleteUnit.sqf
	@summary Attempts to delete a given unit

	@param object _module
	@param object _unit

    @return bool if object is ABLE to be deleted - NOT if the unit was deleted

	@note Originally Developed by Bohemia interactive
**/

#include "\A3\modules_F_Tacops\Ambient\CivilianPresence\defines.inc"

/*
	fn_CoreDeleteUnit.sqf
	Description: Attempts to delete a given unit

	Originally Developed by Bohemia interactive
*/

params
[
    ["_module", objNull, [objNull]],
    ["_unit", objNull, [objNull]]
];

if (isNull _unit) exitWith 
{
    false
};

private _seenBy = allplayers select {
    _x distance _unit < 50 || {
        (_x distance _unit < 150 && {
            ([_x, "VIEW", _unit] checkVisibility [eyePos _x, eyePos _unit]) > 0.5
        })
    }
};

private _candelete = count _seenBy == 0;

if (_candelete) then 
{
    _unit call (_module getVariable ["#onDeleted", {}]);
    deletevehicle _unit;
};

_candelete