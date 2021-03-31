/*
	fn_DynamicGarrisonHandler.sqf

	Description:
		Handles distribution of Dynamic Garrison to the group members

	How to call:
		[
			_group
		] spawn RS_DS_fnc_DynamicGarrisonHandler;
*/

if (missionNamespace getVariable ["SAEF_DynaSpawn_ExtendedLogging", false]) then
{
	["DynaSpawn", 4, (format ["[DynamicGarrisonHandler] <IN> | Parameters: %1", _this])] call RS_fnc_LoggingHelper;
};

params
[
	"_group"
];

{
	_x params ["_unit"];
	[_unit] spawn RS_DS_fnc_DynamicGarrison;
	sleep 0.1;
} forEach (units _group);

// Wait until the group is dead or all of the units have completed their dynamic garrison
waitUntil {
	sleep 10;
	(
		(({alive _x} count units _group) == 0) 
		|| (({_x getVariable ["RS_DS_DynamicGarrison_Finished", false]} count units _group) == (count units _group))
	)
};

// If there are any units still alive we convert them to hunter killers
if (({alive _x} count units _group) > 0) then
{
	[_group, 4000, false, []] spawn RS_DS_fnc_HunterKiller;
};

if (missionNamespace getVariable ["SAEF_DynaSpawn_ExtendedLogging", false]) then
{
	["DynaSpawn", 4, (format ["[DynamicGarrisonHandler] <OUT> | Parameters: %1", _this])] call RS_fnc_LoggingHelper;
};