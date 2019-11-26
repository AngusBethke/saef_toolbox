/*
	fn_FlickerObject.sqf
	Description: Flickers an object to visible or invisible
	[_object, "SHOW"] spawn RS_Rift_fnc_FlickerObject;
	or... [[_object, "SHOW"], RS_Rift_fnc_FlickerObject] remoteExec ["spawn", 0, false];
*/

private
[
	"_object",
	"_type"
];

if !(hasInterface) exitWith {};

_object = _this select 0;
_type = _this select 1;

// Make sure we don't accidentally do unnecessary stuffs
if ((toUpper(_type) == "HIDE") 
	&& ((player getVariable ["RS_Rift_CurrentRiftState", "OUTSIDE"]) == "INSIDE")) exitWith 
{
	diag_log format ["[RS_Rift_fnc_FlickerObject] [WARNING] Object %1 doesn't need to be hidden for this player because this player is inside the rift!", _object];
};

switch toUpper(_type) do
{
	case "SHOW":
	{
		for "_i" from 1 to 5 do
		{
			_object hideObject false;
			sleep (_i / 10);
			
			_object hideObject true;
			sleep (_i / 10);
		};
		
		_object hideObject false;
	};
	case "HIDE":
	{
		for "_i" from 1 to 5 do
		{
			_object hideObject true;
			sleep (_i / 10);
			
			_object hideObject false;
			sleep (_i / 10);
		};
		
		_object hideObject true;
	};
	default {};
};

