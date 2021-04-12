/*
	fn_ApplyLoadout.sqf

	Description:
		Handles added complexity when applying the loadout so that the user doesn't need to

	How to Call:
		[
			_unit,						// The unit to apply the loadout to
			_loadout,					// The path to the loadout script
			_additionalParameters,		// (Optional) Array of additional parameters to add to the loadout script
			_skipRadioRegistration		// (Optional) Whether or not to skip the radio registration
		] spawn RS_LD_fnc_ApplyLoadout;
*/

private
[
	"_scriptTag"
];

_scriptTag = "Loadout: ApplyLoadout";

if (!canSuspend) exitWith
{
	[_scriptTag, 1, (format ["Function must be executed with suspension using 'spawn' instead of 'call'"])] call RS_fnc_LoggingHelper;
};

params
[
	"_unit",
	"_loadout",
	["_additionalParameters", []],
	["_skipRadioRegistration", false]
];

// Wait until the server is finished processing the radios
if (isPlayer _unit) then
{
	// Remove weapons and items immediately
	removeAllWeapons _unit;
	removeAllItems _unit;
	removeAllAssignedItems _unit;

	// Wait until radios have been registered
	if (!_skipRadioRegistration) then
	{
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
	};

	// Empty the variable
	_unit setVariable ["RS_TFR_RadiosReceived", nil, true];
};

// Add extra parameters if any
private
[
	"_params"
];

_params = [_unit];

if (!(_additionalParameters isEqualTo [])) then
{
	_params = _params + _additionalParameters;
};

// Wait until the loadout has been applied
private
[
	"_scriptHandle"
];

[_scriptTag, 3, (format ["Executing: %1 execVM '%2'", _params, _loadout])] call RS_fnc_LoggingHelper;

_scriptHandle = _params execVM _loadout;
waitUntil {
	sleep 0.1;
	((scriptDone _scriptHandle) || (isNull _scriptHandle))
};