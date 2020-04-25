/*
	fn_GasMaskSound.sqf
	Description: Handles gasmask sounds
	[_unit] spawn RS_Rift_fnc_GasMaskSound;
*/

params
[
	"_unit"
];

private
[
	 "_sounds"
	,"_multiplier"
];

// Gain access to ACE variables
#include "\z\ace\addons\advanced_fatigue\script_component.hpp"

_sounds = 
[
	"gm_breath_1"
	,"gm_breath_2"
	,"gm_breath_3"
	,"gm_breath_4"
	,"gm_breath_5"
];
_multiplier = 5;

while {_unit getVariable ["RS_Radiation_Wearing_Gasmask", false]} do 
{
	_time = _multiplier;
	
	if ((GVAR(anFatigue)) != 0) then
	{
		_var = (((log (GVAR(anFatigue))) * -1) / 2) + 0.25;
		
		if (_var < 0.35) then
		{
			_var = 0.35;
		};
		
		if (_var > 1) then
		{
			_var = 1;
		};
		
		_time = _multiplier * _var;
		
	};
	
	playsound (selectRandom _sounds);
	sleep _time;
};