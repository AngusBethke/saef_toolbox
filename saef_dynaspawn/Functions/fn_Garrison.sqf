/**
	@namespace RS_DS
	@class DynaSpawn
	@method RS_DS_fnc_Garrison
	@file fn_Garrison.sqf
	@summary Garrisons Units in Building Positions in a given radius

	@param array _pos
	@param int _rad
	@param group _group
	
**/
/* 
	fn_Garrison.sqf
	Author: Angus Bethke
	Description: 
		Garrisons Units in Building Positions in a given radius
*/

params
[
	"_pos",
	"_rad",
	"_group"
];

if (missionNamespace getVariable ["SAEF_DynaSpawn_ExtendedLogging", false]) then
{
	["DynaSpawn", 4, (format ["[Garrison] <IN> | Parameters: %1", _this])] call RS_fnc_LoggingHelper;
};

private
[
	"_groupUnits",
	"_vehicles"
];

_groupUnits = units _group;

// Get in the gunner position of any nearby vehicles
_vehicles = _pos nearEntities[["Car", "Tank", "StaticWeapon"], _rad];
{
	_x params ["_vehicle"];

	if (!(_vehicle getVariable ["RS_DS_ExcludeFromGarrison", false])) then
	{
		_gunnerPositions = fullCrew [_vehicle, "gunner", true];
		
		{
			_object = _x select 0;
			if (isNull _object) then
			{
				(_groupUnits select 0) moveInGunner _vehicle;
				(_groupUnits select 0) action ["getInGunner", _vehicle];
				_groupUnits = _groupUnits - [(_groupUnits select 0)];
			};
		} forEach _gunnerPositions;
	};
} forEach _vehicles;

// Spool up the dynamic garrison handler for the group
if (missionNamespace getVariable ["SAEF_DynaSpawn_DynamicGarrison", false]) then
{
	[_group] spawn RS_DS_fnc_DynamicGarrisonHandler;
};

if (missionNamespace getVariable ["SAEF_DynaSpawn_ExtendedLogging", false]) then
{
	["DynaSpawn", 4, (format ["[Garrison] <OUT> | Parameters: %1", _this])] call RS_fnc_LoggingHelper;
};

/*
	END
*/