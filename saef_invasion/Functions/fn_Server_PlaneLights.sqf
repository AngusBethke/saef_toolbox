/**
	@namespace RS_INV
	@class Invasion
	@method RS_INV_fnc_Server_PlaneLights
	@file fn_Server_PlaneLights.sqf
	@summary Sets the light of the plane based on given inputs
	
	@param object _plane
	@param string _type

	@usage ```[_plane, _type] call RS_INV_fnc_Server_PlaneLights;```
	
**/

/* 
	fn_Server_PlaneLights.sqf 
	
	Description:
		Sets the light of the plane based on given inputs
	
	How to Call:
		[
			_plane,
			_type
		] call RS_INV_fnc_Server_PlaneLights;
		
	Called by:
		fn_Server_PlayerAirDrop.sqf
		
*/

params
[
	"_plane",
	"_type"
];

switch toUpper(_type) do
{
	case "RED" : {
		["RS_INV_fnc_Server_PlaneLights", 3, (format ["Switching light to [%1] for _plane [%2]", _type, _plane])] call RS_fnc_LoggingHelper;
		[_plane] spawn LIB_fnc_turnInteriorLightStatement;
	};
	
	case "GREEN" : {
		["RS_INV_fnc_Server_PlaneLights", 3, (format ["Switching light to [%1] for _plane [%2]", _type, _plane])] call RS_fnc_LoggingHelper;
		[_plane, true] spawn LIB_fnc_changeLightStatement;
	};

	default {
		["RS_INV_fnc_Server_PlaneLights", 1, (format ["Unrecognised _type variable [%1] for _plane [%2]", _type, _plane])] call RS_fnc_LoggingHelper;
	};
};