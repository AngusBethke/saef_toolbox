/*
	fn_ReplaceMissingRadio.sqf

	Description:
		Watches the given units inventory for given (optional) amount of time, and if radio is replaced with a different radio, replaces that radio with the right one.

	How to Call:
	[

	] spawn RS_LD_fnc_ReplaceMissingRadio.sqf;
*/

private
[
	"_scriptTag"
];

_scriptTag = "Loadout: ReplaceMissingRadio";

if (!canSuspend) exitWith
{
	[_scriptTag, 1, (format ["Function must be executed with suspension using 'spawn' instead of 'call'"])] call RS_fnc_LoggingHelper;
};

params
[
	"_unit",
	"_radio",
	["_watchTime", 60]
];

// Start-up delay
private
[
	"_control"
];

_control = 1;
waitUntil {
	sleep 1;
	_control = _control + 1;
	((_unit getVariable ["RS_TFR_RadiosReceived", false]) || (_control == 20))
};

// Empty the variable
_unit setVariable ["RS_TFR_RadiosReceived", nil, true];

// Start out watcher
_control = 1;
while {_watchTime >= _control} do
{
	_found = false;

	{
		_x params ["_item"];

		if ([_radio, (format ["%1", _item])] call BIS_fnc_InString) then
		{
			_found = true;
		};
	} forEach (assignedItems _unit);

	if (!_found) exitWith
	{
		[_scriptTag, 0, (format ["Radio [%1] missing from unit's [%2] inventory, replacing it now...", _radio, _unit])] call RS_fnc_LoggingHelper;
		
		_unit linkItem _radio;
	};

	_control = _control + 1;
	sleep 1;
};

[_scriptTag, 0, (format ["Helper for Unit [%2] and Radio [%1] Complete...", _radio, _unit])] call RS_fnc_LoggingHelper;