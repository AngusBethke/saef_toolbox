/*
	fn_RnR_ActionRearm.sqf

	Description: 
		Adds action to refuel and rearm the given vehicle within 5m distance from given object

	How to Call: 
		[
			_vehString,				// The vehicle string name
			_objString,				// The repair object string name
			_vehType,				// The type of vehicle
			_additionalScripts		// (Optional) Any additional scripts
		] call SAEF_VEH_fnc_RnR_ActionRearm;
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

_logName = "SAEF RnR: Action - Rearm";

if (isNil _vehString) exitWith
{
	[_logName, 2, (format ["Vehicle [%1] does not exist!", _vehString])] call RS_fnc_LoggingHelper;
};

if (isNil _objString) exitWith
{
	[_logName, 2, (format ["Object [%1] does not exist!", _objString])] call RS_fnc_LoggingHelper;
};

private
[
	"_vehicle",
	"_object",
	"_name",
	"_text"
];

_vehicle = (call compile _vehString);
_object = (call compile _objString);

_name = format["RepairVehicle_%1", (vehicleVarName _vehicle)];
_text = format ["Repair %1", getText (configFile >> "CfgVehicles" >> _vehType >> "displayName")];

// Add the action
private
[
	"_action"
];

_action = 
[
	_name,  
	_text, 
	"",
	{
		params ["_target", "_player", "_params"];
		
		_params spawn SAEF_VEH_fnc_RnR_Rearm;
	},
	{
		params ["_target", "_player", "_params"];

		_params params
		[
			"_vehicle",
			"_object",
			"_vehType",
			"_additionalScripts"
		];
		
		(((_vehicle distance _object) < 5) && !(isEngineOn _vehicle))
	},
	{},
	[_vehicle, _object, _vehType, _additionalScripts], 
	[0,0,0], 
	3
] call ace_interact_menu_fnc_createAction;

// Map the action to the given object
[_vehicle, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;

[_logName, 0, (format ["Registering action [%1] for rearming vehicle [%2]", _name, _vehString])] call RS_fnc_LoggingHelper;