/**
	@namespace RS_INS
	@class Insurgency
	@method RS_INS_fnc_SwitchToInsurgent
	@file fn_SwitchToInsurgent.sqf
	@summary Will switch the all the units to an insurgent if they meet the required conditions
	
	@usage ```[] call RS_INS_fnc_SwitchToInsurgent;```
	
**/

/*
	fn_SwitchToInsurgent.sqf
	Description: Will switch the all the units to an insurgent if they meet the required conditions
	[] call RS_INS_fnc_SwitchToInsurgent;
*/

{
	// Make sure the unit is local
	if (local _x) then
	{
		// Fetch the assigned weapon
		_weapon = _x getVariable ["RS_Insurgency_HasWeapon", ""];
		
		// Make sure there is a weapon
		_hasWeapon = (_weapon != "");
		
		// Make sure the unit has not been disarmed
		_notDisarmed = (_weapon in (backpackItems _x));
		
		if ((_x getVariable ["RS_Insurgency_IsInsurgent", false]) && _hasWeapon && _notDisarmed) then
		{
			[_x] spawn RS_INS_fnc_SwitchToInsurgent_Individual;
		};
	};
} forEach allUnits;