/**
	@namespace RS_DS
	@class DynaSpawn
	@method RS_DS_fnc_UnitValidation
	@file fn_UnitValidation.sqf
	@summary Determines whether the variable passed is a Valid Group or Vehicle
	
	@param any _var
	
	@return array Array (Valid - Boolean, Type - String)
**/

/*
	fn_UnitValidation.sqf
	Author: Angus Bethke
	Description: 
		Determines whether the variable passed is a Valid Group or Vehicle
*/

params
[
	"_var"
];

//Private Variables	
private
[
	"_type",
	"_valid"
];

_type = "";
_valid = false;

if ((typeName _var) isEqualTo "ARRAY") then
{
	_type = "INF";
	_valid = true;
	
	{
		if (!(_x isKindOf ["Man", configFile >> "CfgVehicles"])) then
		{
			_valid = false;
		};
	} forEach _var;
}
else
{
	if ((_var isKindOf ["LandVehicle", configFile >> "CfgVehicles"]) 
		|| (_var isKindOf ["Helicopter", configFile >> "CfgVehicles"])
		|| (_var isKindOf ["Plane", configFile >> "CfgVehicles"])
		|| (_var isKindOf ["Boat", configFile >> "CfgVehicles"])
		|| (_var isKindOf ["Man", configFile >> "CfgVehicles"])) then
	{
		_type = "VEH";
		_valid = true;
	};
};

/* Returns: Array (Valid - Boolean, Type - String) */
[_valid, _type]