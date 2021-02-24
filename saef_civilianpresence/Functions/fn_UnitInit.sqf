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