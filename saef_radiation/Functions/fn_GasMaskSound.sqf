/**
	@namespace RS_Radiation
	@class Radiation
	@method RS_Radiation_fnc_GasMaskSound
	@file fn_GasMaskSound.sqf
	@summary Handles gasmask sounds

	@param unit _unit

	@usage ```[_unit] spawn RS_Radiation_fnc_GasMaskSound;```

**/

/*
	fn_GasMaskSound.sqf
	Description: Handles gasmask sounds
	[_unit] spawn RS_Radiation_fnc_GasMaskSound;
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
	so what I have done now is remove the macro reference and simply reference the fully qualified name: 
		ace_advanced_fatigue_anFatigue
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

if ((isNil "ace_advanced_fatigue_anFatigue")) then
{
	["RS_Radiation_fnc_GasMaskSound", 2, (format ["Variable 'ace_advanced_fatigue_anFatigue' not found, breathing will be regulated at %1 second intervals", _multiplier])] call RS_fnc_LoggingHelper;
};

while {_unit getVariable ["RS_Radiation_Wearing_Gasmask", false]} do 
{
	_time = _multiplier;
	
	if (!(isNil "ace_advanced_fatigue_anFatigue")) then
	{
		if (ace_advanced_fatigue_anFatigue != 0) then
		{
			_var = ((log (ace_advanced_fatigue_anFatigue) * -1) / 2) + 0.25;
			
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
	};
	
	playsound (selectRandom _sounds);
	sleep _time;
};
