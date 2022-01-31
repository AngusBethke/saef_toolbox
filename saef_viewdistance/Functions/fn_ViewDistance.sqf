/**
	@namespace SAEF_VD
	@class ViewDistance
	@method SAEF_VD_fnc_ViewDistance
	@file fn_ViewDistance.sqf
	@summary Handles View Distance and the settings for all connected clients and the server

	@usage ```[] call SAEF_VD_fnc_ViewDistance;```
**/

/*
	fn_ViewDistance.sqf

	Description: 
		Handles View Distance and the settings for all connected clients and the server

	How to Call: 
		[] call SAEF_VD_fnc_ViewDistance;
*/

params
[
	["_type", "UNKNOWN"],
	["_defaultServerVD", 1200],
	["_defaultPlayerVD", 1200],
	["_defaultAircraftVD", 5000],
	["_defaultShadowVD", 50],
	["_defaultFixedCeiling", 150]
];

private
[
	"_scriptTag"
];
_scriptTag = "SAEF_VD_fnc_ViewDistance";

switch toUpper(_type) do
{
	case "SERVER" :
	{
		// Set the View Distance
		setViewDistance _defaultServerVD;
		setObjectViewDistance [_defaultServerVD, _defaultShadowVD];
		
		// Set the variables for Server View Distance
		missionNamespace setVariable ["Server_ViewDistance", _defaultServerVD, true];
		missionNamespace setVariable ["Server_ObjectViewDistance", [_defaultServerVD, _defaultShadowVD], true];
		
		// Set the variables for Player View Distance
		missionNamespace setVariable ["Infantry_ViewDistance", _defaultPlayerVD, true];
		missionNamespace setVariable ["Infantry_ObjectViewDistance", [_defaultPlayerVD, _defaultShadowVD], true];
		
		// Set the variables for Aircraft View Distance
		missionNamespace setVariable ["Aircraft_ViewDistance", _defaultAircraftVD, true];
		missionNamespace setVariable ["Aircraft_ObjectViewDistance", [_defaultAircraftVD, _defaultShadowVD], true];

		// Set the fixed ceiling variable
		missionNamespace setVariable ["SAEF_ViewDistance_FixedCeiling", _defaultFixedCeiling, true];
		
		[_scriptTag, 0, (format ["Set View Distance to: %1", _defaultServerVD])] call RS_fnc_LoggingHelper;
		[_scriptTag, 0, (format ["Set Object View Distance to: %1", [_defaultServerVD, _defaultShadowVD]])] call RS_fnc_LoggingHelper;
	};
	case "PLAYER" :
	{
		setViewDistance (missionNamespace getVariable ["Infantry_ViewDistance", _defaultPlayerVD]);
		setObjectViewDistance (missionNamespace getVariable ["Infantry_ObjectViewDistance", [_defaultPlayerVD, _defaultShadowVD]]);
		
		[_scriptTag, 0, (format ["Set View Distance to: %1", (missionNamespace getVariable ["Infantry_ViewDistance", _defaultPlayerVD])])] call RS_fnc_LoggingHelper;
		[_scriptTag, 0, (format ["Set Object View Distance to: %1", (missionNamespace getVariable ["Infantry_ObjectViewDistance", [_defaultPlayerVD, _defaultShadowVD]])])] call RS_fnc_LoggingHelper;
	};
	default
	{
		setViewDistance (missionNamespace getVariable ["Server_ViewDistance", _defaultServerVD]);
		setObjectViewDistance (missionNamespace getVariable ["Server_ObjectViewDistance", [_defaultServerVD, _defaultShadowVD]]);
		
		[_scriptTag, 0, (format ["Set View Distance to: %1", (missionNamespace getVariable ["Infantry_ViewDistance", _defaultPlayerVD])])] call RS_fnc_LoggingHelper;
		[_scriptTag, 0, (format ["Set Object View Distance to: %1", (missionNamespace getVariable ["Infantry_ObjectViewDistance", [_defaultPlayerVD, _defaultShadowVD]])])] call RS_fnc_LoggingHelper;
	};
};