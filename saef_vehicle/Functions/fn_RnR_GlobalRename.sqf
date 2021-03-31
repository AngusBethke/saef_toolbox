/*
	fn_RnR_GlobalRename.sqf

	Description:
		Handles global renaming of vehicle
*/

params
[
	"_vehicle",
	"_vehVarName",
	["_isGlobal", false]
];

_vehicle setVehicleVarName _vehVarName;
(call compile (format["%1 = _vehicle;", _vehVarName]));

// Recursive call that will globally execute this function if the parameter is not set
if (!_isGlobal) then
{
	[_vehicle, _vehVarName, true] remoteExecCall ["SAEF_VEH_fnc_RnR_GlobalRename", 0, true];
};