/*
	fn_RnR_AddToInitQueue.sqf

	Description:
		Adds the given parameters to our queue variable for later initialisation
*/

params
[
	"_vehString",
	"_objString",
	"_vehType"
];

// Add to the initialisation queue for player collection
private
[
	"_initQueue"
];

_initQueue = missionNamespace getVariable ["SAEF_RnR_InitQueue", []];
_initQueue pushBack [_vehString, _objString];
missionNamespace setVariable ["SAEF_RnR_InitQueue", _initQueue, true];

// Create the vehicle setup
private
[
	"_variable"
];

_variable = (format ["SAEF_RnR_Vehicle_%1", _vehString]);
missionNamespace setVariable [_variable, _this, true];