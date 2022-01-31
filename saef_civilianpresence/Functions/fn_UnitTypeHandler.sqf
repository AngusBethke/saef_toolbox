/**
	@namespace RS_CP
	@class CivilianPresence
	@method RS_CP_fnc_UnitTypeHandler
	@file fn_UnitTypeHandler.sqf
	@summary Updates the unit type continuosly so that they can be changed mid-mission if necessary
	
	@param unit _unit

**/
/*
	fn_UnitTypeHandler.sqf
	Description: Updates the unit type continuosly so that they can be changed mid-mission if necessary
*/

while {(missionNamespace getVariable ["SAEF_CivilianPresence_Run_UnitTypeHandler", false])} do
{
	_modules = entities "RS_CP_ModuleCivilianPresence";

	{
		_module = _x;
		_unitTypes = missionNamespace getVariable ["SAEF_CivilianPresence_UnitTypes", []];
		
		if (!(_unitTypes isEqualTo [])) then
		{
			_module setVariable ["#unitTypes", _unitTypes];
		};
	} forEach _modules;

	sleep 30;
};