/*
	fn_PFH_Prevent.sqf
	Description: Prevents non-Medic players from fully healing themselves
	Author: Angus Bethke (a.k.a. Rabid Squirrel)
*/

private
[
	"_debug",
	"_caller",
	"_target",
	"_selectionName",
	"_className",
	"_isMedic"
];

_debug = (missionNamespace getVariable "PFH_Debug");

// Control Variable in case we want to turn this off
if (missionNamespace getVariable "PFH_RunFullHealPrevention") then
{
	// Parameters
	_caller = _this select 0;
	_target = _this select 1;
	_selectionName = _this select 2;
	_className = _this select 3;
	
	// Figure out if you're a medic or not
	_isMedic = [_caller] call ace_medical_fnc_isMedic;

	// If you're not a medic, we want to inflict the damage again
	if (!_isMedic) then
	{
		// Get the current hitpoint damage
		_damageVar = _target getvariable ["ace_medical_bodyPartStatus", [0,0,0,0,0,0]]; 
		_damageVal = _damageVar select ([_selectionName] call ace_medical_fnc_selectionNameToNumber);
		
		// If the current damage is 0 and we've bandaged then re-apply damage to the hitpoint
		if ((_damageVal == 0) && (_className == "Bandage")) then
		{
			[_target, _selectionName] remoteExecCall ["RS_fnc_PFH_ServerDamageDistribution", 2, false];
			
			if (_debug) then
			{
				diag_log format ["[Prevent Full Heal] [INFO] Preventing full heal for %1", _target];
			};
		};
	};
};