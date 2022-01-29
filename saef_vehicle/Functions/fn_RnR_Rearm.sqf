/**
	@namespace SAEF_VEH
	@class RearmAndRepair
	@method SAEF_VEH_fnc_fnc_RnR_Rearm
	@file fn_RnR_Rearm.sqf
	@summary Rearms the given vehicle

	@param vehicle _vehicle
	@param object _object
	@param string _vehType
	@param ?array _additionalScripts

**/

/*
	fn_RnR_Rearm.sqf

	Description: 
		Rearms the given vehicle
*/

params
[
	"_vehicle",
	"_object",
	"_vehType",
	["_additionalScripts", []]
];

hint format ["Vehicle: Refuel, Repair and Rearm Started"];

private
[
	"_control",
	"_count"
];

_control = 30;
_count = 1;

while {!(isEngineOn _vehicle) && (_count < _control)} do
{
	sleep 1;
	_count = _count + 1;
};

if (_count >= _control) then
{
	_vehicle setFuel 1;
	_vehicle setDamage 0;
	_vehicle setVehicleAmmoDef 1;

	// Run any addition scripts if needed
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

	hint format ["Vehicle: Refuel, Repair and Rearm Completed"];
}
else
{
	hint format ["Vehicle: Refuel, Repair and Rearm Cancelled"];
};