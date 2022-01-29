/**
	@namespace RS_Rift
	@class TheRift
	@method RS_Rift_fnc_RegisterRiftControlObject
	@file fn_RegisterRiftControlObject.sqf
	@summary Registers the rift interaction point for later use

	@param object _object
	@param string _type

	@usages ```	
	How to call:
		[_object, _type] call RS_Rift_fnc_RegisterRiftControlObject;
	``` @endusages

**/

/*
	fn_RegisterRiftControlObject.sqf

	Description:
		Registers the rift interaction point for later use

	How to call:
		[_object, _type] call RS_Rift_fnc_RegisterRiftControlObject;
*/

if (!isServer) exitWith 
{
	["Rift: Register Control Object", 1, "Registration can only be done on the server!"] call RS_fnc_LoggingHelper;
};

params
[
	"_object",
	"_type"
];

private
[
	"_variable"
];

switch toUpper(_type) do 
{
	case "REGISTER":
	{
		_variable = "RS_Rift_ControlObjects";
	};
	case "DISABLE":
	{
		_variable = "RS_Rift_ControlObjects_Disabled";
	};
	default 
	{
		_variable = "ERROR";
	};
};

if (_variable == "ERROR") exitWith
{
	["Rift: Register Control Object", 1, (format ["Unrecognised type [%1]!", _type])] call RS_fnc_LoggingHelper;
};

private
[
	"_riftInteractionPoints"
];

_riftInteractionPoints = missionNamespace getVariable [_variable, []];
_riftInteractionPoints pushBack _object;
missionNamespace setVariable [_variable, _riftInteractionPoints, true];