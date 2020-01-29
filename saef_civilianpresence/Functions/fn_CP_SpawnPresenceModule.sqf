#include "\A3\Modules_F_Tacops\Ambient\CivilianPresence\defines.inc"

/*
	fn_CP_SpawnPresenceModule.sqf
	Description: Handles creation of the Civilian Presence, Waypoints, and Safe Points
	Parameters:	
		_location		- location
		_debug 			- bool (possibly int enum)
		_createdCode 	- string
		_deletedCode 	- string
		_useAgents 		- bool (possibly int enum)
		_usePanicMode 	- bool (possibly int enum)
*/

// Get some input variables
_location = _this select 0;
_debug = _this select 1;
_createdCode = _this select 2;
_deletedCode = _this select 3;
_useAgents = _this select 4;
_usePanicMode = _this select 5;
_whiteList = _this select 6;
_unitCount = 0;

// Get some information about the location
_type = type _location;
_pos = position _location;

_supportedLocations = missionNamespace getVariable ["RS_CivilianPresence_SupportedLocationTypes", ["NameCity", "NameCityCapital", "NameVillage"]];

// Exit if the type of location isn't catered for
if (!(_type in _supportedLocations)) exitWith 
{
	diag_log format ["[RS Civilian Presence] [INFO] Location is of type: %1, which is not one of the supported locations: %2", _type, _supportedLocations];
};

// Get All Locations on Map
_locations = [] call RS_LC_fnc_ListLocations;

if (_whiteList) then
{
	_locations = [] call RS_fnc_CP_GetWhiteListedLocations;
};

_posArray = [];
{
	_posArray = _posArray + [position _x];
} forEach _locations;

_posArray = _posArray - [_pos];

_distArray = [];
{
	_dist = _pos distance2D _x;
	_distArray = _distArray + [_dist];
} forEach _posArray;

_minDist = (selectMin _distArray)/2;

if (_minDist > 2000) then
{
	_minDist = 2000;
};

_sizeLoc = [_minDist, _minDist, 0]; // size _location;
_size = ((_sizeLoc select 0) + (_sizeLoc select 1)) / 2; 

if (_size > 2000) then
{
	_size = 2000;
};

if (_debug) then
{
	diag_log format ["[RS Civilian Presence] [DEBUG] Size Arrays: %1 %2", _sizeLoc, _size];
};

// Create Group
_group = createGroup sideLogic;

_buildings = [];
_bPosArray = [];
_safeBuildings = [];
_spwnPosObjects = [];
_safePosObjetcs = [];

// Max unit count
_maxUnitCount = _location getVariable "RS_CP_MaxUnitCount";
if (isNil "_maxUnitCount") then
{
	_maxUnitCount = 30;
};

if (_debug) then
{
	diag_log format ["[RS Civilian Presence] [DEBUG] MaxUnitCount: %1", _maxUnitCount];
};

// Derive Unit Count Based on Number of Buildings
_customLoc = _location getVariable "RS_CP_CustomSpawnPositions";
if (isNil "_customLoc") then
{
	_buildings = nearestObjects [_pos, ["building"], _size];

	{
		if ((_x buildingPos 0) isEqualTo [0,0,0]) then
		{
			_buildings = _buildings - [_x];
		};
	} forEach _buildings;

	if ((count _buildings) > _maxUnitCount) then
	{
		for "_i" from 1 to  ((count _buildings) - _maxUnitCount) do
		{
			_building = SelectRandom _buildings;
			_buildings = _buildings - [_building];
		};
	};
	
	{
		_bPosArray = _bPosArray + [getPosASL _x];
	} forEach _buildings;
}
else
{
	if (_debug) then
	{
		diag_log format ["[RS Civilian Presence] [DEBUG] Custom Locations: %1", _customLoc];
	};
	
	_bPosArray = _customLoc;
};

if (_debug) then
{
	diag_log format ["[RS Civilian Presence] [DEBUG] Building Positions: %1", _bPosArray];
};

{
	// Set Spawn Point
	_logic = [_x, _group] call RS_fnc_CP_SpawnPositionModule;
	_spwnPosObjects = _spwnPosObjects + [_logic];
	
	// Set Waypoint
	_logic = [_x, _group, 0, true, 3, true] call RS_fnc_CP_SpawnSafePointModule;
	_safePosObjetcs = _safePosObjetcs + [_logic];
	
	_unitCount = _unitCount + 1;
} forEach _bPosArray;

// Determine our max height (to figure out where to put the trigger, and how to size it)
_heightArray = [];
{
	_heightArray = _heightArray + [(_x select 2)];
}forEach _bPosArray;

if (_debug) then
{
	diag_log format ["[RS Civilian Presence] [DEBUG] Height Array: %1", _heightArray];
};

_maxHeight = selectMax _heightArray;
_minHeight = selectMin _heightArray;
_meanHeight = (_maxHeight + _minHeight) / 2;
_trigHeight = ((_maxHeight + 50) - (_minHeight - 50)) / 2;

if (_unitCount > _maxUnitCount) then
{
	_unitCount = _maxUnitCount;
};

// Get our Safe Buildings
_safeBuildNum = ceil (_unitCount / 5);
for "_i" from 0 to (_safeBuildNum - 1) do
{
	_building = selectRandom _bPosArray;
	_safeBuildings = _safeBuildings + [_building];
	_bPosArray = _bPosArray - [_building]
};

// Spawn our Safe Points
{
	_logic = [_x, _group, 5, true, 1, true] call RS_fnc_CP_SpawnSafePointModule;
	_safePosObjetcs = _safePosObjetcs + [_logic];
} forEach _safeBuildings;

if (_spwnPosObjects isEqualTo []) exitWith 
{
	diag_log format ["[RS Civilian Presence] [WARNING] Civilian Presence Module cannot be created with no linked spawn spots: %1", text _location];
};

if (_safePosObjetcs isEqualTo []) exitWith 
{
	diag_log format ["[RS Civilian Presence] [WARNING] Civilian Presence Module cannot be created with no linked safe spots: %1", text _location];
};

// Create the Logic
_logic = _group createUnit ["ModuleCivilianPresence_F",_pos,[],0,"NONE"]; 

// Set the Logic's Parameters
_sizeLocDerived = (_sizeLoc select 0);
_logic setVariable ["size", _size];
_logic setVariable ["#area", [[_sizeLocDerived, _sizeLocDerived, 0], _sizeLocDerived/2, _sizeLocDerived/2, 0, false, -1]]; 
_logic setVariable ["#debug", _debug];
_logic setVariable ["#onCreated", _createdCode];
_logic setVariable ["#onDeleted", _deletedCode]; 
_logic setVariable ["#unitCount", _unitCount]; 
_logic setVariable ["#useAgents", _useAgents]; 
_logic setVariable ["#usePanicMode", _usePanicMode];
_logic setVariable ["ModuleCivilianPresenceUnit_F", _spwnPosObjects]; 
_logic setVariable ["ModuleCivilianPresenceSafeSpot_F", _safePosObjetcs];

// Set up the triggers
_trigger = createTrigger ["EmptyDetector", [(_pos select 0), (_pos select 1), _meanHeight]];
_trigger setTriggerArea [(_sizeLoc select 0), (_sizeLoc select 1), 0, false, _trigHeight];
_trigger setTriggerActivation ["ANYPLAYER", "PRESENT", true];

if (_debug) then
{
	// Visual Area Representation
	_marker = createMarker [format ["marker_%1_%2", (text _location), _sizeLocDerived], [(_pos select 0), (_pos select 1), _meanHeight]];
	_marker setMarkerShape "ELLIPSE";
	_marker setMarkerSize [_sizeLocDerived, _sizeLocDerived];
	_marker setMarkerBrush "Border";
	
	diag_log format ["[RS Civilian Presence] [DEBUG] Created Visual Marker: %1", _marker];
};

if (_debug) then
{
	if (isServer) then
	{
		_trigger setTriggerStatements 
		[
			"((this) && (missionNamespace getVariable 'RS_CivilianPresence_Enabled') && (missionNamespace getVariable 'RS_CivilianPresence_RunOnServer'))", 
			"hint '[RS Civilian Presence] [INFO] Civilian Presence Spawn Triggered'", 
			"hint '[RS Civilian Presence] [INFO] Civilian Presence De-spawn Triggered'"
		];
	}
	else
	{
		_trigger setTriggerStatements 
		[
			"((this) && (missionNamespace getVariable 'RS_CivilianPresence_Enabled') && (missionNamespace getVariable 'RS_CivilianPresence_RunOnClient'))", 
			"hint '[RS Civilian Presence] [INFO] Civilian Presence Spawn Triggered'", 
			"hint '[RS Civilian Presence] [INFO] Civilian Presence De-spawn Triggered'"
		];
	};
}
else
{
	if (isServer) then
	{
		_trigger setTriggerStatements ["((this) && (missionNamespace getVariable 'RS_CivilianPresence_Enabled') && (missionNamespace getVariable 'RS_CivilianPresence_RunOnServer'))", "", ""];
	}
	else
	{
		_trigger setTriggerStatements ["((this) && (missionNamespace getVariable 'RS_CivilianPresence_Enabled') && (missionNamespace getVariable 'RS_CivilianPresence_RunOnClient'))", "", ""];
	};
};

_trigger synchronizeObjectsAdd [_logic];

if (_debug) then
{
	diag_log format ["[RS Civilian Presence] [DEBUG] Trigger Spawn Height: %1 | Trigger Area Height set to: %2", _meanHeight, _trigHeight];
	diag_log format ["[RS Civilian Presence] [DEBUG] Civilian Presence Module linked safe spots: %1", _logic getVariable "ModuleCivilianPresenceSafeSpot_F"];
	diag_log format ["[RS Civilian Presence] [DEBUG] Civilian Presence Module linked spawn points: %1", _logic getVariable "ModuleCivilianPresenceUnit_F"];
};

/*
	END
*/