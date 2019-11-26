// Gain access to variables
#include "\z\ace\addons\medical\script_component.hpp"

/*
	fn_PFH_ApplyDamage.sqf
	Description: Re-applies damage... Barring some things: we stop bleeding if necessary and we don't re-apply pain
	Author: Angus Bethke (a.k.a. Rabid Squirrel)
*/

private
[
	"_debug",
	"_target",
	"_selectionName",
	"_hasPain",
	"_isBleeding",
	"_openWounds",
	"_bandagedWounds",
	"_internalWounds"
];

// Set Variables
_debug = (missionNamespace getVariable "PFH_Debug");
_target = _this select 0;
_selectionName = _this select 1;

// Check if the target is in pain and bleeding (this is so that we don't accidentally fix stuff that's still broken)
_hasPain = _target getVariable QGVAR(hasPain);
_isBleeding = _target getVariable QGVAR(isBleeding);

// Pain
_pain = _target getVariable QGVAR(pain);

// Wounds and Injuries
_openWounds = _target getVariable QGVAR(openWounds);

if (_debug) then
{
	diag_log format [("[Prevent Full Heal] [INFO] Re-apply damage for %1" 
						+ " | Is the target in pain? %2" 
						+ " | Is the target bleeding? %3"
						+ " | What is the Pain Level? %4"
						+ " | Are there open wounds? %5"), 
						_target, _hasPain, _isBleeding, _pain, _openWounds];
};

// Re-apply the Damage
[_target, 1, _selectionName, "bullet"] call ace_medical_fnc_addDamageToUnit;

// Apply status effects for basic medical status
_target setVariable [QGVAR(isBleeding), _isBleeding, true];
_target setVariable [QGVAR(hasPain), _hasPain, true];

// Pain
_target setVariable [QGVAR(pain), _pain, true];

// Wounds and Injuries
if !(_isBleeding) then
{
	_target setVariable [QGVAR(openWounds), [], true];
};

/*
_bandagedWounds = _target setVariable [QGVAR(bandagedWounds), [], true];
_internalWounds = _target setVariable [QGVAR(internalWounds), [], true];
*/

/*
	END
*/