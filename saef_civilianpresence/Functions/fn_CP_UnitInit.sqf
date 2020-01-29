/*
	fn_CP_UnitInit.sqf
	Description: Handles post Civi creation scripts
	Parameters:	
		_unit	- object
*/

_unit = _this select 0;
_scripts = missionNamespace getVariable "RS_CP_UnitInitScripts";

if (!isNil "_scripts") then 
{
	{
		_script = _x;
		[_unit] execVM _script;
	} forEach _scripts;
};