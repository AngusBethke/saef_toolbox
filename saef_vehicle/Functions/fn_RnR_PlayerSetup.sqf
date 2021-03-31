/*
	fn_RnR_PlayerSetup.sqf

	Description:
		Setups the Rearm and Repair functionality for a given vehicle for the player
*/

params
[
	"_vehString",
	"_objString"
];

private
[
	"_logName"
];

_logName = "SAEF RnR: Player Setup";

private
[
	"_classLock",
	"_classLockVariable",
	"_add"
];

_classLockVariable = (format ["SAEF_RnR_Vehicle_%1_ClassLock", _vehString]);
_classLock = missionNamespace getVariable [_classLockVariable, []];

_add = true;
if (!(_classLock isEqualTo [])) then
{
	_add = false;
	
	{
		_class = _x;
		if ((typeOf player) == _class) then
		{
			_add = true;
		};
	} forEach _classLock;
};

if (_add) then
{
	private
	[
		"_variable"
	];

	_variable = (format ["SAEF_RnR_Vehicle_%1", _vehString]);

	(missionNamespace getVariable [_variable, []]) params
	[
		["_tVehString", ""],
		["_tObjString", ""],
		["_tVehType", ""]
	];

	if ((_tVehString == "") || (_tObjString == "") || (_tVehType == "")) exitWith
	{
		// We cannot do anything with no saved variables
		[_logName, 1, (format ["Variable [%1] missing configuration [_tVehString: %2, _tObjString: %3, _tVehType: %4]", _variable, _tVehString, _tObjString, _tVehType])] call RS_fnc_LoggingHelper;
	};

	if (isNil _tObjString) exitWith
	{
		// We cannot do anything if the respawn position is gone
		[_logName, 1, (format ["Object [%1] must Exist!", _tObjString])] call RS_fnc_LoggingHelper;
	};

	// Source any additional scripts
	private
	[
		"_additionalScriptsVariable",
		"_additionalScripts"
	];

	_additionalScriptsVariable = (format ["SAEF_RnR_Vehicle_%1_AdditionalScripts", _vehString]);
	_additionalScripts = missionNamespace getVariable [_additionalScriptsVariable, []];
	
	// Setup the actions
	[_tVehString, _tObjString, _tVehType, _additionalScripts] call SAEF_VEH_fnc_RnR_ActionRearm;
	[_tVehString, _tObjString, _tVehType, _additionalScripts] call SAEF_VEH_fnc_RnR_ActionRespawn;
};