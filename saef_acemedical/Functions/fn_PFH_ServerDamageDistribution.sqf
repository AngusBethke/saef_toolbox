/**
	@namespace RS
	@class PreventFullHeal
	@method RS_fnc_PFH_ServerDamageDistribution
	@file fn_PFH_ServerDamageDistribution.sqf
	@summary Tells the server to call a client and prevent healing from occuring. The reason I am doing this is because client to client communication appears to be unreliable.
	@param object _target
	@param any _selectionName
**/

/*
	fn_PFH_ServerDamageDistribution.sqf
	Description: Tells the server to call a client and prevent healing from occuring.
		The reason I am doing this is because client to client communication appears to 
		be unreliable.
	Author: Angus Bethke (a.k.a. Rabid Squirrel)
*/

private
[
	"_debug",
	"_target",
	"_selectionName"
];

_debug = (missionNamespace getVariable "PFH_Debug");
_target = _this select 0;
_selectionName = _this select 1;

[_target, _selectionName] remoteExecCall ["RS_fnc_PFH_ApplyDamage", _target, false];

if (_debug) then
{
	["Prevent Full Heal", 3, (format ["Preventing full heal for %1", _target])] call RS_fnc_LoggingHelper;
};