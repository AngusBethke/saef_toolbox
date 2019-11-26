/*
	Function: fn_UnitValidation.sqf
	Author: Angus Bethke
	Description: Determines whether the variable passed is a Valid Group or Vehicle
	Last Modified: 04-11-2019
*/

//Private Variables	
private
[
	"_var",
	"_type",
	"_valid"
];

_var = _this select 0;
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
		OR (_var isKindOf ["Helicopter", configFile >> "CfgVehicles"])
		OR (_var isKindOf ["Plane", configFile >> "CfgVehicles"])
		OR (_var isKindOf ["Boat", configFile >> "CfgVehicles"])) then
	{
		_type = "VEH";
		_valid = true;
	};
};

/* Returns: Array (Valid - Boolean, Type - String) */
[_valid, _type]