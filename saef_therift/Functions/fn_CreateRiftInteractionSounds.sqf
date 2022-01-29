/**
	@namespace RS_Rift
	@class TheRift
	@method RS_Rift_fnc_CreateRiftInteractionSounds
	@file fn_CreateRiftInteractionSounds.sqf
	@summary Creates sounds for the rift interaction point

	@param object _object
	@param string _variable
	@param any _soundPath
	@param any _sound
	@param any _songLength

	@usages ```
		[_object] spawn RS_Rift_fnc_CreateRiftInteractionSounds;		
	```	@endusages
**/

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

_sound = "saef_therift\Sounds\emp\emp_rift.ogg";
_soundLength = 8;

while { missionNamespace getVariable [_variable, true] } do
{
	playSound3D [_sound, _object, false, getPosASL _object, 4, 1, 100];
	
	sleep _soundLength;
};
