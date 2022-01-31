/**
	@namespace RS_TFR
	@class TFR
	@method RS_TFR_fnc_JamTfrRadios
	@file fn_JamTfrRadios.sqf
	@summary Jams tfar radios if the player has them while in a specific rift state

	@param unit _unit
	@param string _vrbl

	@usage ```[_unit, _vrbl] spawn RS_TFR_fnc_JamTfrRadios;```
**/


/*
	fn_JamTfrRadios.sqf
	Description: Jams tfar radios if the player has them while in a specific rift state
	How to call: [<object: player>, <string: variable>] spawn RS_TFR_fnc_JamTfrRadios;
*/

private
[
	"_unit"
	,"_vrbl"
];

_unit = _this select 0;
_vrbl = _this select 1;

// Add our new variable
_unit setVariable [_vrbl, true, true];

// Jam Radios while a certain condition is met
while {(_unit getVariable [_vrbl, false]) && (alive _unit)} do
{
	if (alive _unit) then 
	{
		// SW radio
		if (!((TFAR_currentUnit call TFAR_fnc_radiosList) isEqualTo [])) then
		{
			_chan = (ceil(random(8)) - 1);
			[(call TFAR_fnc_activeSwRadio), _chan] call TFAR_fnc_setSwChannel;

			_freq = format["%1.%2", ceil(random(60)), ceil(random(9))];
			[(call TFAR_fnc_activeSwRadio), _freq] call TFAR_fnc_setSwFrequency;
		};
	};
		
	if (alive _unit) then 
	{
		// LR radio
		if (!((TFAR_currentUnit call TFAR_fnc_lrRadiosList) isEqualTo [])) then
		{
			_chan = (ceil(random(8)) - 1);
			[(call TFAR_fnc_activeLrRadio) select 0, (call TFAR_fnc_activeLrRadio) select 1, _chan] call TFAR_fnc_setLrChannel;
			
			_freq = format["%1.%2", ceil(random(60)), ceil(random(9))];
			[(call TFAR_fnc_activeLrRadio) select 0, (call TFAR_fnc_activeLrRadio) select 1, _freq] call TFAR_fnc_setLrFrequency;
		};
	};

	sleep 5;
};

// Cleanup
_unit setVariable [_vrbl, nil, true];

/*
	END
*/