/*
	fn_RiftSwitch.sqf
	Description: Handles function execution when switching through the rift
*/

if (!hasInterface) exitWith {};

private
[
	"_unit"
	,"_rift"
];

_rift = _this select 0;
_unit = _this select 1;

// If the unit that executed this is not the guy in the trigger, we must ignore this
if (_unit != player) exitWith {};

// If our player is already in this rift state, kick them out
if ((_unit getVariable ["RS_Rift_CurrentRiftState", "OUTSIDE"] == _rift) 
		|| (_unit getVariable ["RS_Rift_CurrentRiftState", "OUTSIDE"] == "TRANSITION")) exitWith {};

// Let everything know that the player is now in the transition state of the rift
_unit setVariable ["RS_Rift_CurrentRiftState", "TRANSITION", true];

// Cut player vision
titleCut ["","WHITE OUT", 2];
playSound "emp_phase";
_unit allowDamage false;
sleep 2;

// Hold player vision
titleCut ["", "WHITE FADED", 999];

// Switch Post Process Effects
[_unit, _rift] spawn RS_Rift_fnc_PostProcessEffectsHandler;

// Hide/Show Objects
[_unit, _rift] call RS_Rift_fnc_ObjectHideHandler;

// Hold a sec
sleep 3;

// Let everything know that the player is now in this state of the rift
_unit setVariable ["RS_Rift_CurrentRiftState", _rift, true];

// Start jamming the radios
if (_rift == "INSIDE") then
{
	[_unit, _rift] spawn RS_TFR_fnc_JamTfrRadios;
	[_unit] spawn RS_Rift_fnc_RiftDamageHandler;
	
	// Start Snowfall
	//[_unit, false] spawn RS_Rift_fnc_RiftSnowFall;
	
	_unit setVariable ["RS_Rift_Object", true, true];
	_unit setCaptive false;

	{
		if (_x != _unit) then
		{
			//[_unit, true] remoteExecCall ["hideObject", _x, false];
			[_unit, "HIDE"] remoteExec ["RS_Rift_fnc_FlickerObject", _x, false];
		};
	} forEach allPlayers;
}
else
{
	_unit setVariable ["RS_Rift_Object", false, true];
	_unit setCaptive true;

	{
		if (_x != _unit) then
		{
			//[_unit, false] remoteExecCall ["hideObject", _x, false];
			[_unit, "SHOW"] remoteExec ["RS_Rift_fnc_FlickerObject", _x, false];
		};
	} forEach allPlayers;
};

// Return player vision
sleep 2;
titleCut ["", "WHITE IN", 2];

sleep 2;
_unit allowDamage true;