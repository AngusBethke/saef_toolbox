/*
	fn_RnR_Setup.sqf

	Description:
		Setups the Rearm and Repair functionality for a given vehicle
*/

params
[
	"_vehString",
	"_objString"
];

private
[
	"_logName"
];

_logName = "SAEF RnR: Setup";

if (isNil _vehString) exitWith
{
	// Vehicle is required for initial setup
	[_logName, 1, (format ["Vehicle [%1] is required for initial setup!", _vehString])] call RS_fnc_LoggingHelper;
};

if (isNil _objString) exitWith
{
	// Object is required for initial setup
	[_logName, 1, (format ["Object [%1] is required for initial setup!", _objString])] call RS_fnc_LoggingHelper;
};

private
[
	"_vehicle",
	"_object"
];

_vehicle = (call compile _vehString);
_object = (call compile _objString);

// Run any addition scripts if needed
private
[
	"_additionalScriptsVariable",
	"_additionalScripts"
];

_additionalScriptsVariable = (format ["SAEF_RnR_Vehicle_%1_AdditionalScripts", _vehString]);
_additionalScripts = missionNamespace getVariable [_additionalScriptsVariable, []];

if (!(_additionalScripts isEqualTo [])) then
{
	{
		_x params
		[
			"_params",
			"_script"
		];

		// Add the vehicle object to our parameters
		_params = [_vehicle] + _params;
		
		// Execute the script
		_params execVM _script;
	} forEach _additionalScripts;
};

// Throw the initialisation into the queue
["SAEF_RnRQueue", [(vehicleVarName _vehicle), (vehicleVarName _object), (typeOf _vehicle)], "SAEF_VEH_fnc_RnR_AddToInitQueue"] call RS_MQ_fnc_MessageEnqueue;