#include "\A3\modules_F_Tacops\Ambient\CivilianPresence\defines.inc"

/*
	fn_CoreDeactivation.sqf
	Description: Disables the civilian presence handler

	Originally Developed by Bohemia interactive
*/

params
[
    ["_moduleString", "", [""]]
];

private
[
	"_module"	
];

{
	if ((_x getVariable ["SAEF_CivilianPresenceLogicName", ""]) == _moduleString) then
    {
        _module = _x;
    };
} forEach (entities "Logic");

if (isNil "_module") exitWith
{
    ["RS Civilian Presence", 1, (format ["Civilian Presence %1 terminated. Logic entity given doesn't exist...", _moduleString])] call RS_fnc_loggingHelper;
};

if (is3DEN) exitwith {};

["RS Civilian Presence", 3, (format ["Civilian Presence %1 de-activating...", _module])] call RS_fnc_loggingHelper;

_module setVariable ['#active', false, true];