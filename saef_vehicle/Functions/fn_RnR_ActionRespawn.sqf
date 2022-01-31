/**
	@namespace SAEF_VEH
	@class RearmAndRepair
	@method SAEF_VEH_fnc_RnR_ActionRespawn
	@file fn_RnR_ActionRespawn.sqf
	@summary Adds action to respawn given vehicle within 5m distance from given object

	@param string _vehString
	@param string _objString
	@param string _vehType
	@param array _additionalScripts

	@usages ```
	How to Call: 
		[
			_vehString,				// The vehicle string name
			_objString,				// The repair object string name
			_vehType,				// The type of vehicle
			_additionalScripts		// (Optional) Any additional scripts
		] call SAEF_VEH_fnc_RnR_ActionRespawn;
	``` @endusages

**/

/*
	fn_RnR_ActionRespawn.sqf

	Description: 
		Adds action to respawn given vehicle within 5m distance from given object

	How to Call: 
		[
			_vehString,				// The vehicle string name
			_objString,				// The repair object string name
			_vehType,				// The type of vehicle
			_additionalScripts		// (Optional) Any additional scripts
		] call SAEF_VEH_fnc_RnR_ActionRespawn;
*/

params
[
	"_vehString",
	"_objString",
	"_vehType",
	["_additionalScripts", []]
];

private
[
	"_logName"
];

_logName = "SAEF RnR: Action - Respawn";

if (isNil _objString) exitWith
{
	[_logName, 2, (format ["Object [%1] does not exist!", _objString])] call RS_fnc_LoggingHelper;
};

private
[
	"_object",
	"_name",
	"_text",
	"_action"
];

_object = (call compile _objString);

_name = format["RespawnVehicle_%1", _vehString];
_text = format ["Respawn %1", getText (configFile >> "CfgVehicles" >> _vehType >> "displayName")];

// Remove the Action
[player, 1, ["ACE_SelfActions", _name]] call ace_interact_menu_fnc_removeActionFromObject;

// Respawn Action
_action = 
[
	_name, 
	_text, 
	"",
	{
		params ["_target", "_player", "_params"];
		
		_params spawn SAEF_VEH_fnc_RnR_Respawn;
	},
	{
		params ["_target", "_player", "_params"];
		_params params
		[
			"_vehString",
			"_object",
			"_vehType",
			"_additionalScripts"
		];
		
		((player distance _object) < 7.5)
	},
	{}, 
	[_vehString, _object, _vehType, _additionalScripts]
] call ace_interact_menu_fnc_createAction;

// Map the Action to the Player
[player, 1, ["ACE_SelfActions"], _action, true] call ace_interact_menu_fnc_addActionToObject;

[_logName, 0, (format ["Registering action [%1] for respawning vehicle [%2]", _name, _vehString])] call RS_fnc_LoggingHelper;