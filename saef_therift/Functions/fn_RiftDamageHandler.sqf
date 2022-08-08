/**
	@namespace RS_Rift
	@class TheRift
	@method RS_Rift_fnc_RiftDamageHandler
	@file fn_RiftDamageHandler.sqf
	@summary Handles damage taken while in the rift

	@param unit _unit

	@usages ```	
	[_unit] spawn RS_Rift_fnc_RiftDamageHandler;
	``` @endusages

**/


/*
	fn_RiftDamageHandler.sqf
	Description: Handles damage taken while in the rift
	[_unit] spawn RS_Rift_fnc_RiftDamageHandler;
*/

private
[
	"_unit",
	"_selections",
	"_sounds"
];

_unit = _this select 0;

_selections = 
[
	 "head"
	,"body"
	//,"arm_r"
	//,"arm_l"
	,"leg_r"
	,"leg_l"
];

_sounds =
[
	 "Breath_Struggle_1"
	,"Breath_Struggle_2"
	,"Breath_Struggle_3"
	,"Breath_Struggle_4"
	,"Breath_Struggle_5"
];
	
// Reset Rift Damage
{
	_hitPoint = format ["RS_Rift_Damage_%1", _x];
	_unit setVariable [_hitPoint, 0, true];
} forEach _selections;

["RiftDamageHandler", 3, (format ["Handler started for unit: %1", _unit])] call RS_fnc_LoggingHelper;

while { (_unit getVariable ["RS_Rift_CurrentRiftState", "OUTSIDE"] == "INSIDE") && (alive _unit) } do
{
	// If our player is not wearing a gasmask, we need to start doing damage to them
	if (!(_unit getVariable ["RS_Radiation_Wearing_Gasmask", false]) && (alive _unit)) then
	{
		{
			_hitPoint = format ["RS_Rift_Damage_%1", _x];
			_damage = (_unit getVariable [_hitPoint, 0]) + 0.1;
			_unit setVariable [_hitPoint, _damage, true];
			
			[_unit, _damage, _x, "backblast"] call ace_medical_fnc_addDamageToUnit;
		} forEach _selections;
	
		playSound (selectRandom _sounds);
	};
	
	sleep 6;
};

["RiftDamageHandler", 3, (format ["Handler stopped for unit: %1", _unit])] call RS_fnc_LoggingHelper;