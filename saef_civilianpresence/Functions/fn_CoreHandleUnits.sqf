/**
	@namespace RS_CP
	@class CivilianPresence
	@method RS_CP_fnc_CoreHandleUnits
	@file fn_CoreHandleUnits.sqf
	@summary Monitor number of units and spawn / delete some as needed

	@param object _module
    
	@note Originally Developed by Bohemia interactive
**/

#include "\A3\modules_F_Tacops\Ambient\CivilianPresence\defines.inc"

/*
	fn_CoreHandleUnits.sqf
	Description: Monitor number of units and spawn / delete some as needed

	Originally Developed by Bohemia interactive
*/

params
[
    ["_module", objNull, [objNull]]
];

["RS Civilian Presence", 3, (format ["Civilian Presence %1 handle units initialised...", _module])] call RS_fnc_loggingHelper;

private _units = _module getVariable ["#units", []];
private _maxunits = _module getVariable ["#unitCount", 0];
private _active = false;

while
{
    _active = _module getVariable ["#active", false];
    _units = _units select {
        !isNull _x && {
            alive _x
        }
    };
    
    (_active && _maxunits > 0) || (!_active && count _units > 0)
}
do
{
    if (_active) then 
	{
        if (((count _units) < _maxunits) && ([civilian, (missionnamespace getVariable ["SAEF_CivilianPresence_MaxTotalUnitcount", 48])] call RS_CP_fnc_CheckAgainsttotalRunningAi)) then 
		{
            private _unit = [_module] call RS_CP_fnc_CoreCreateUnit;
            if (!isNull _unit) then 
			{
                _units pushBack _unit
            };
        };
    } 
	else 
	{
        private _unit = selectRandom _units;
        private _deleted = [_module, _unit] call RS_CP_fnc_CoreDeleteUnit;
        
        if (_deleted) then 
		{
            _units = _units - [_unit];
        };
    };
    
    // Compact & store units array
    _units = _units select {
        !isNull _x && {
            alive _x
        }
    };
    _module setVariable ["#units", _units];
    
    sleep 10;
};

// Mark the unit handling as terminated
_module setVariable ["#unitHandlingRunning", false];