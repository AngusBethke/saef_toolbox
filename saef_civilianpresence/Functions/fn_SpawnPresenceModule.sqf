#include "\A3\Modules_F_Tacops\Ambient\CivilianPresence\defines.inc"

/*
	fn_SpawnPresenceModule.sqf
	Description: Handles creation of the Civilian Presence, Waypoints, and Safe Points
	Parameters:	
		_location		- location
		_debug 			- bool (possibly int enum)
		_createdCode 	- string
		_deletedCode 	- string
		_useAgents 		- bool (possibly int enum)
		_usePanicMode 	- bool (possibly int enum)
*/

params
[
	"_location",
	"_debug",
	"_createdCode",
	"_deletedCode",
	"_useAgents",
	"_usePanicMode",
	"_whiteList",
	"_unitTypes",
	"_locations"
];

private
[
	 "_unitCount"
	,"_type"
	,"_pos"
	,"_supportedLocations"
	,"_group"
	,"_buildings"
	,"_bPosArray"
	,"_safeBuildings"
	,"_spwnPosObjects"
	,"_safePosObjetcs"
	,"_maxUnitCount"
	,"_customLoc"
	,"_heightArray"
	,"_maxHeight"
	,"_minHeight"
	,"_meanHeight"
	,"_trigHeight"
	,"_safeBuildNum"
	,"_sizeLocDerived"
	,"_trigger"
	,"_townVariable"
	,"_onActStatement"
	,"_onDeactStatement"
];

_unitCount = 0;

// Get some information about the location
_type = type _location;
_pos = position _location;

_supportedLocations = missionNamespace getVariable ["SAEF_CivilianPresence_SupportedLocationTypes", ["NameCity", "NameCityCapital", "NameVillage"]];

// Exit if the type of location isn't catered for
if (!(_type in _supportedLocations)) exitWith 
{
	["RS Civilian Presence", 3, (format ["Location %1 is of type: %2, which is not one of the supported locations: %3", (text _location), _type, _supportedLocations])] call RS_fnc_LoggingHelper;
};

([_pos, _locations, _supportedLocations] call RS_CP_fnc_GetPositionInfo) params
[
	"_posArray"
	,"_distArray"
	,"_minDist"
	,"_sizeLoc"
	,"_size"
];

if (_debug) then
{
	["RS Civilian Presence", 4, (format ["Size Arrays: %1 %2", _sizeLoc, _size])] call RS_fnc_LoggingHelper;
};

// Create Group
_group = createGroup sideLogic;

_buildings = [];
_bPosArray = [];
_safeBuildings = [];
_spwnPosObjects = [];
_safePosObjetcs = [];

// Max unit count
_maxUnitCount = _location getVariable ["SAEF_CivilianPresence_MaxUnitCount", (missionNamespace getVariable ["SAEF_CivilianPresence_MaxUnitCount" ,24])];

if (_debug) then
{
	["RS Civilian Presence", 4, (format ["MaxUnitCount: %1", _maxUnitCount])] call RS_fnc_LoggingHelper;
};

// Derive Unit Count Based on Number of Buildings
_customLoc = _location getVariable "SAEF_CivilianPresence_CustomSpawnPositions";
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
		_bPosArray = _bPosArray + [getPosATL _x];
	} forEach _buildings;
}
else
{
	if (_debug) then
	{
		["RS Civilian Presence", 4, (format ["Custom Locations: %1", _customLoc])] call RS_fnc_LoggingHelper;
	};
	
	_bPosArray = _customLoc;
};

if (_debug) then
{
	["RS Civilian Presence", 4, (format ["Building Positions: %1", _bPosArray])] call RS_fnc_LoggingHelper;
};

if (_bPosArray isEqualTo []) exitWith 
{
	["RS Civilian Presence", 2, (format ["Civilian Presence Module cannot be created with no building positions in the area: %1", text _location])] call RS_fnc_LoggingHelper;
};

{
	// Set Spawn Point
	_logic = [_x, _group] call RS_CP_fnc_SpawnPositionModule;
	_spwnPosObjects = _spwnPosObjects + [_logic];
	
	// Set Waypoint
	_logic = [_x, _group, 0, true, 3, true] call RS_CP_fnc_SpawnSafePointModule;
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
	["RS Civilian Presence", 4, (format ["Height Array: %1", _heightArray])] call RS_fnc_LoggingHelper;
};

if (_heightArray isEqualTo []) exitWith 
{
	["RS Civilian Presence", 2, (format ["Civilian Presence Module cannot be created with no returned heights for buidlings in the area: %1", text _location])] call RS_fnc_LoggingHelper;
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
	_logic = [_x, _group, 5, true, 1, true] call RS_CP_fnc_SpawnSafePointModule;
	_safePosObjetcs = _safePosObjetcs + [_logic];
} forEach _safeBuildings;

if (_spwnPosObjects isEqualTo []) exitWith 
{
	["RS Civilian Presence", 2, (format ["Civilian Presence Module cannot be created with no linked spawn spots: %1", text _location])] call RS_fnc_LoggingHelper;
};

if (_safePosObjetcs isEqualTo []) exitWith 
{
	["RS Civilian Presence", 2, (format ["Civilian Presence Module cannot be created with no linked safe spots: %1", text _location])] call RS_fnc_LoggingHelper;
};

// Create the Logic
_logic = _group createUnit ["Logic",_pos,[],0,"NONE"]; // RS_CP_ModuleCivilianPresence
_sanAreaName = (((text _location) splitString " ") joinString "");
_logicName = (format ["logic%1", _sanAreaName]);

// Set the Logic's Parameters
_sizeLocDerived = (_sizeLoc select 0);
_logic setVariable ["size", _size, true];
_logic setVariable ["#area", [[_sizeLocDerived, _sizeLocDerived, 0], _sizeLocDerived/2, _sizeLocDerived/2, 0, false, -1], true]; 
_logic setVariable ["#debug", _debug, true];
_logic setVariable ["#onCreated", _createdCode, true];
_logic setVariable ["#onDeleted", _deletedCode, true]; 
_logic setVariable ["#unitCount", _unitCount, true]; 
_logic setVariable ["#useAgents", _useAgents, true]; 
_logic setVariable ["#usePanicMode", _usePanicMode, true];
_logic setVariable ["ModuleCivilianPresenceUnit_F", _spwnPosObjects, true]; 
_logic setVariable ["ModuleCivilianPresenceSafeSpot_F", _safePosObjetcs, true];
_logic setVariable ["SAEF_CivilianPresenceLogicName", _logicName, true];

if (!(_unitTypes isEqualTo [])) then
{
	_logic setVariable ["#unitTypes", _unitTypes, true];
};

// Set up the triggers
_trigger = createTrigger ["EmptyDetector", [(_pos select 0), (_pos select 1), _meanHeight]];
_trigger setTriggerArea [(_sizeLoc select 0), (_sizeLoc select 1), 0, false, _trigHeight];
_trigger setTriggerActivation ["ANYPLAYER", "PRESENT", true];
_trigger setTriggerInterval 10;

if (_debug) then
{
	// Visual Area Representation
	_marker = createMarker [format ["marker_%1_%2", (text _location), _sizeLocDerived], [(_pos select 0), (_pos select 1), _meanHeight]];
	_marker setMarkerShape "ELLIPSE";
	_marker setMarkerSize [_sizeLocDerived, _sizeLocDerived];
	_marker setMarkerBrush "Border";
	
	["RS Civilian Presence", 4, (format ["Created Visual Marker: %1", _marker])] call RS_fnc_LoggingHelper;
};

_townVariable = (format ["SAEF_CivilianPresence_%1", _sanAreaName]);
missionNamespace setVariable [_townVariable, true, true];

_onActStatement = format["if (!isServer) exitWith {}; [['%1', true], 'RS_CP_fnc_CoreInit', 'call', (missionNamespace getVariable ['SAEF_CivilianPresence_ExecutionLocality', 'HC1'])] call RS_fnc_ExecScriptHandler;", _logicName];
_onDeactStatement = format["if (!isServer) exitWith {}; ['%1'] call RS_CP_fnc_CoreDeactivation;", _logicName];
if (_debug) then
{
	_onActStatement = _onActStatement + "hint '[RS Civilian Presence] [INFO] Civilian Presence Spawn Triggered';";
	_onDeactStatement = _onDeactStatement + "hint '[RS Civilian Presence] [INFO] Civilian Presence De-spawn Triggered';";
};

_trigger setTriggerStatements [(format ["((this) && (missionNamespace getVariable ['SAEF_CivilianPresence_Enabled', false]) && (missionNamespace getVariable ['SAEF_CivilianPresence_RunOnServer', false]) && (missionNamespace getVariable ['%1', false]))", _townVariable]), _onActStatement, _onDeactStatement];
_trigger synchronizeObjectsAdd [_logic];

["RS Civilian Presence", 0, (format ["Civilian Presence Module created for %1 at %2 and can be enabled or disabled with variable: %3", text _location, _pos, _townVariable])] call RS_fnc_LoggingHelper;

if (_debug) then
{
	["RS Civilian Presence", 4, (format ["Trigger Spawn Height: %1 | Trigger Area Height set to: %2", _meanHeight, _trigHeight])] call RS_fnc_LoggingHelper;
	["RS Civilian Presence", 4, (format ["Civilian Presence Module linked safe spots: %1", _logic getVariable "ModuleCivilianPresenceSafeSpot_F"])] call RS_fnc_LoggingHelper;
	["RS Civilian Presence", 4, (format ["Civilian Presence Module linked spawn points: %1", _logic getVariable "ModuleCivilianPresenceUnit_F"])] call RS_fnc_LoggingHelper;
};

/*
	END
*/