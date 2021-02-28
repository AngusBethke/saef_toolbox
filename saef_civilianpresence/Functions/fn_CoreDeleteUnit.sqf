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