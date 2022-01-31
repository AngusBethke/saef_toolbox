/**
	@namespace RS_CP
	@class CivilianPresence
	@method RS_CP_fnc_CoreInit
	@file fn_CoreInit.sqf
	@summary Handles the civilian Presence initialisation

	@param string _moduleString
	@param bool _activated
    
	@note Originally Developed by Bohemia interactive
**/
#include "\A3\modules_F_Tacops\Ambient\CivilianPresence\defines.inc"

/*
	fn_CoreInit.sqf
	Description: Handles the civilian Presence initialisation

	Originally Developed by Bohemia interactive
*/

params
[
    ["_moduleString", "", [""]],
    ["_activated", true, [true]]
];

private
[
	"_module"	
];

{
	if ((_x getVariable ["SAEF_CivilianPresenceLogicName", ""]) == _moduleString) then
    {
        _module = _x;
    };
} forEach (entities "Logic");

if (isNil "_module") exitWith
{
    ["RS Civilian Presence", 1, (format ["Civilian Presence %1 terminated. Logic entity given doesn't exist...", _moduleString])] call RS_fnc_loggingHelper;
};

if (is3DEN) exitwith {};

["RS Civilian Presence", 3, (format ["Civilian Presence %1 initialised...", _module])] call RS_fnc_loggingHelper;

// Get unit and safespot modules in area
private _modulesUnit = [_module, "ModuleCivilianPresenceUnit_F"] call RS_CP_fnc_CoreGetobjects;
private _modulesSafeSpots = [_module, "ModuleCivilianPresenceSafeSpot_F"] call RS_CP_fnc_CoreGetobjects;

// Check setup validity
if (count _modulesUnit == 0 || count _modulesSafeSpots == 0) exitwith 
{
    ["RS Civilian Presence", 1, (format ["Civilian Presence %1 terminated. There neeeds to be at least 1 spawnpoint and 1 position module.", _module])] call RS_fnc_loggingHelper;
};

// flag module activity
_module setVariable ["#active", _activated];

// Check if continuous spawning thread is running and start it, if not
private _unitHandlingRunning = _module getVariable ["#unitHandlingRunning", false];
if (_activated && !_unitHandlingRunning) then 
{
    _module setVariable ["#unitHandlingRunning", true];
    
    [_module] spawn RS_CP_fnc_CoreHandleUnits;
};

// Block sub-sequent executions
if (_module getVariable ["#initialized", false]) exitwith {};
_module setVariable ["#initialized", true];

// Register module specific functions
[
    "\A3\modules_F_Tacops\Ambient\CivilianPresence\Functions\",
    "bis_fnc_cp_",
    [
        "debug",
        "getQueueDelay",
        "main",
        "addThreat",
        "getSafespot"
    ]
]
call bis_fnc_loadFunctions;

_module setVariable ["#modulesUnit", _modulesUnit];
_module setVariable ["#modulesSafeSpots", _modulesSafeSpots];

{
    private _safespot = _x;
    private _safespotPos = getPos _safespot;
    _safespotPos set [2, 0];
    
    if (_safespot getVariable ["#useBuilding", false]) then 
	{
        _building = nearestBuilding _safespotPos;
        
        if (_building distance2D _safespotPos > 50) then 
		{
            _building = objNull
        };
        
        if (!isNull _building && { count (_building buildingPos -1) > 0 }) then
        {
            _safespot setVariable ["#positions", (_building buildingPos -1) call BIS_fnc_arrayShuffle];
        } 
		else 
		{
            _safespot setVariable ["#positions", [_safespotPos]];
        };
    } 
	else 
	{
        _safespot setVariable ["#positions", [_safespotPos]];
    };
} forEach _modulesSafeSpots;

// try set unit types override from the variable
if (!((missionnamespace getVariable ["SAEF_CivilianPresence_UnitTypes", []]) isEqualto [])) then 
{
    _module setVariable ["#unitTypesOverride", (missionnamespace getVariable ["SAEF_CivilianPresence_UnitTypes", []])];
};

// Prepare unit types
private _cfgUnittypes = configFile >> "Cfgvehicles" >> "ModulecivilianPresence_F" >> "UnitTypes" >> worldName;
if (isNull _cfgUnittypes) then 
{
    _cfgUnittypes = configFile >> "Cfgvehicles" >> "ModulecivilianPresence_F" >> "UnitTypes" >> "Other"
};
_module setVariable ["#unitTypes", getArray _cfgUnittypes];

// Will let the handler spawn the units

// Debug
if (_module getVariable ["#debug", false]) then 
{
    private _paramsDraw3D = missionnamespace getVariable ["bis_fnc_ModuleCivilianPresence_paramsDraw3D", []];
    private _handle = addMissionEventHandler ["Draw3D", {
        ["debug"] call bis_fnc_cp_debug;
    }];
    _paramsDraw3D set [_handle, _module];
    bis_fnc_modulecivilianPresence_paramsDraw3D = _paramsDraw3D;
};