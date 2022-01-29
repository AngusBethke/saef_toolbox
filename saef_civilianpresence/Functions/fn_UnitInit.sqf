/**
	@namespace RS_CP
	@class CivilianPresence
	@method RS_CP_fnc_UnitInit
	@file fn_UnitInit.sqf
	@summary Handles post Civi creation scripts

	
	@param unit _unit

**/
/*
	fn_UnitInit.sqf
	Description: Handles post Civi creation scripts
	Parameters:	
		_unit	- object
*/

params
[
	"_unit"
];

// Blacklist this unit from acex headless
_unit setVariable ["acex_headless_blacklist", true];

// Execute any defined custom scripts
_scripts = missionNamespace getVariable "SAEF_CivilianPresence_UnitInitScripts";

if (!isNil "_scripts") then 
{
	{
		_script = _x;
		[_unit] execVM _script;
	} forEach _scripts;
};