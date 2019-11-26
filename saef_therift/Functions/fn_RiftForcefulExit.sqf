/*
	fn_RiftForcefulExit.sqf
	Description: Handles forceful exit from the rift
	[] spawn RS_Rift_fnc_RiftForcefulExit;
*/

if (!hasInterface) exitWith {};

private
[
	"_unit"
	,"_rift"
];

_rift = "OUTSIDE";
_unit = player;

titleCut ["","WHITE OUT", 1];
_unit allowDamage false;
sleep 1;

// Hold player vision
titleCut ["", "WHITE FADED", 999];
playSound "emp_boom";

// Switch Post Process Effects
[_unit, _rift] spawn RS_Rift_fnc_PostProcessEffectsHandler;

// Hide/Show Objects
[_unit, _rift] call RS_Rift_fnc_ObjectHideHandler;

// Hold a sec
sleep 3;

// Let everything know that the player is now in this state of the rift
_unit setVariable ["RS_Rift_CurrentRiftState", _rift, true];
_unit setVariable ["RS_Rift_Object", false, true];
_unit setCaptive true;

{
	if (_x != _unit) then
	{
		//[_unit, false] remoteExecCall ["hideObject", _x, false];
		[_unit, "SHOW"] remoteExec ["RS_Rift_fnc_FlickerObject", _x, false];
	};
} forEach allPlayers;

// Return player vision
sleep 3;

// Start stand-up animation
player switchMove "Acts_UnconsciousStandUp_part1";

// Remove Effects
sleep 2;
titleCut ["", "WHITE IN", 2];

// Play the rest of the animations
sleep 41.86;
player switchMove "Acts_UnconsciousStandUp_part2";
sleep 2.73;
player switchMove "AmovPercMstpSlowWpstDnon";
sleep 0.5;

// Re-enable player damage
_unit allowDamage true;