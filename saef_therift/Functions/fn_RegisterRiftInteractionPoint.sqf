/**
	@namespace RS_Rift
	@class TheRift
	@method RS_Rift_fnc_RegisterRiftInteractionPoint
	@file fn_RegisterRiftInteractionPoint.sqf
	@summary Registers the rift interaction point for later use

	@param object _object
	@param string _type

	@usages ```	
	How to call:
		[_object, _type] call RS_Rift_fnc_RegisterRiftInteractionPoint;
	``` @endusages

**/

/*
	fn_RegisterRiftInteractionPoint.sqf

	Description:
		Registers the rift interaction point for later use

	How to call:
		[_object, _type] call RS_Rift_fnc_RegisterRiftInteractionPoint;
*/

if (!isServer) exitWith 
{
	["Rift", 1, "[RegisterRiftInteractionPoint] Rift interaction point registration can only be done on the server!"] call RS_fnc_LoggingHelper;
};

params
[
	"_object",
	"_type"
];

private
[
	"_riftInteractionPoints"
];

_riftInteractionPoints = missionNamespace getVariable ["RS_Rift_InteractionPoints", []];
_riftInteractionPoints pushBack [_object, _type];
missionNamespace setVariable ["RS_Rift_InteractionPoints", _riftInteractionPoints, true];