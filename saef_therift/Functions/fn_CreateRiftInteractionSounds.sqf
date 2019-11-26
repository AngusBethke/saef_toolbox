/*
	fn_CreateRiftInteractionSounds.sqf
	Description: Creates sounds for the rift interaction point
	[_object] spawn RS_Rift_fnc_CreateRiftInteractionSounds;
*/

private
[
	 "_object"
	,"_variable"
	,"_soundPath"
	,"_sound"
	,"_songLength"
];

_object = _this select 0;
_variable = _this select 1;

if (isNil "_variable") then
{
	_variable = "RS_Rift_RunInteractionPointSounds";
};

_soundPath = [(str missionConfigFile), 0, -15] call BIS_fnc_trimString;
_sound = "Toolbox\TheRift\Sounds\emp_rift.ogg";

_songLength = 8;

while { missionNamespace getVariable [_variable, true] } do
{
	playSound3D [(_soundPath + _sound), _object, false, getPosASL _object, 4, 1, 100];
	
	sleep _songLength;
};