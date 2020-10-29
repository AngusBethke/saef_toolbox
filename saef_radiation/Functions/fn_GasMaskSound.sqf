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

/* 
	Ace script component was required for the macro, but as it turns out the macro simply creates a fully qualified name,
	so what I have done now is remove the macro reference and simply reference the fully qualified name (ace_advanced_fatigue_anFatigue) instead
*/

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
	
	if (ace_advanced_fatigue_anFatigue != 0) then
	{
		_var = (((log (ace_advanced_fatigue_anFatigue) * -1) / 2) + 0.25;
		
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
