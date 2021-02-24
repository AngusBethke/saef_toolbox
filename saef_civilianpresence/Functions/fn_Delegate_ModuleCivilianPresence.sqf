#include "\A3\Modules_F_Tacops\Ambient\CivilianPresence\defines.inc"

/*
	fn_Delegate_ModuleCivilianPresence.sqf
	Description: Handles the Civilian Presence module functionality

	Originally Developed by Bohemia Interactive
*/

private _mode = param [0,"",[""]];
private _input = param [1,[],[[]]];
private _module = _input param [0,objNull,[objNull]];

switch _mode do
{
	// Default object init
	case "init":
	{
		if (is3DEN) exitWith {};

		// Get unit and safespot modules in area
		private _modulesUnit = ["getObjects",[_module,"ModuleCivilianPresenceUnit_F"]] call RS_CP_fnc_Delegate_ModuleCivilianPresence;
		private _modulesSafeSpots = ["getObjects",[_module,"ModuleCivilianPresenceSafeSpot_F"]] call RS_CP_fnc_Delegate_ModuleCivilianPresence;

		// Check setup validity
		if (count _modulesUnit == 0 || count _modulesSafeSpots == 0) exitWith
		{
			["RS Civilian Presence", 3, (format ["Civilian Presence %1 terminated. There neeeds to be at least 1 spawnpoint and 1 position module.", _module])] call RS_fnc_LoggingHelper;
		};

		private _activated = _input param [1,true,[true]];

		// Flag module activity
		_module setVariable ["#active",_activated];

		// Check if continuous spawning thread is running and start it, if not
		private _unitHandlingRunning = _module getVariable ["#unitHandlingRunning",false];
		if (_activated && !_unitHandlingRunning) then
		{
			_module setVariable ["#unitHandlingRunning",true];

			["handleUnits",[_module]] spawn RS_CP_fnc_Delegate_ModuleCivilianPresence;
		};

		// Block sub-sequent executions
		if (_module getVariable ["#initialized",false]) exitWith {};
		_module setVariable ["#initialized",true];

		// Register module specific functions
		[
			"\A3\Modules_F_Tacops\Ambient\CivilianPresence\Functions\",
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

		_module setVariable ["#modulesUnit",_modulesUnit];
		_module setVariable ["#modulesSafeSpots",_modulesSafeSpots];

		{
			private _safespot = _x;
			private _safespotPos = getPos _safespot; _safespotPos set [2,0];

			if (_safespot getVariable ["#useBuilding",false]) then
			{
				_building = nearestBuilding _safespotPos;

				if (_building distance2D _safespotPos > 50) then {_building = objNull};

				if (!isNull _building && {count (_building buildingPos -1) > 0}) then
				{
					_safespot setVariable ["#positions",(_building buildingPos -1) call BIS_fnc_arrayShuffle];
				}
				else
				{
					_safespot setVariable ["#positions",[_safespotPos]];
				};
			}
			else
			{
				_safespot setVariable ["#positions",[_safespotPos]];
			};
		}
		forEach _modulesSafeSpots;

		// Try set unit types override from the variable
		if (!((missionNamespace getVariable ["SAEF_CivilianPresence_UnitTypes", []]) isEqualTo [])) then
		{
			_module setVariable ["#unitTypesOverride", (missionNamespace getVariable ["SAEF_CivilianPresence_UnitTypes", []])];
		};

		// Prepare unit types
		private _cfgUnitTypes = configFile >> "CfgVehicles" >> "ModuleCivilianPresence_F" >> "UnitTypes" >> worldName;
		if (isNull _cfgUnitTypes) then { _cfgUnitTypes = configFile >> "CfgVehicles" >> "ModuleCivilianPresence_F" >> "UnitTypes" >> "Other" };
		_module setVariable ["#unitTypes", getArray _cfgUnitTypes];

		private _units = [];
		{
			private _unit = ["createUnit",[_module,getPos _x]] call RS_CP_fnc_Delegate_ModuleCivilianPresence;

			if (!isNull _unit) then {_units pushBack _unit};
		}
		forEach _modulesUnit;
		_module setVariable ["#units",_units];

		// Debug
		if (_module getVariable ["#debug",false]) then
		{
			private _paramsDraw3D = missionNamespace getVariable ["bis_fnc_moduleCivilianPresence_paramsDraw3D",[]];
			private _handle = addMissionEventHandler ["Draw3D",{["debug"] call bis_fnc_cp_debug;}];
			_paramsDraw3D set [_handle,_module];
			bis_fnc_moduleCivilianPresence_paramsDraw3D = _paramsDraw3D;
		};
	};

	case "handleUnits":
	{
		// Monitor number of agents and spawn / delete some as needed
		_module spawn
		{
			private _module = _this;

			// Make sure initialization is finished
			waitUntil
			{
				!isNil{_module getVariable "#units"}
			};

			private _units = _module getVariable ["#units",[]];
			private _maxUnits = _module getVariable ["#unitCount",0];
			private _active = false;

			while
			{
				_active = _module getVariable ["#active",false];
				_units = _units select {!isNull _x && {alive _x}};

				(_active && _maxUnits > 0) || (!_active && count _units > 0)
			}
			do
			{
				if (_active) then
				{
					if (((count _units) < _maxUnits) && ([CIVILIAN, (missionNamespace getVariable ["SAEF_CivilianPresence_MaxTotalUnitCount", 48])] call RS_CP_fnc_CheckAgainstTotalRunningAi)) then
					{
						private _unit = ["createUnit",[_module]] call RS_CP_fnc_Delegate_ModuleCivilianPresence;
						if (!isNull _unit) then {_units pushBack _unit};
					};
				}
				else
				{
					private _unit = selectRandom _units;
					private _deleted = ["deleteUnit",[_module,_unit]] call RS_CP_fnc_Delegate_ModuleCivilianPresence;

					if (_deleted) then
					{
						_units = _units - [_unit];
					};
				};

				// Compact & store units array
				_units = _units select {!isNull _x && {alive _x}};
				_module setVariable ["#units",_units];

				sleep 10;
			};

			// Mark the unit handling as terminated
			_module setVariable ["#unitHandlingRunning",false];
		};
	};

	case "deleteUnit":
	{
		private _unit = _input param [1,objNull,[objNull]]; if (isNull _unit) exitWith {false};
		private _seenBy = allPlayers select {_x distance _unit < 50 || {(_x distance _unit < 150 && {([_x,"VIEW",_unit] checkVisibility [eyePos _x, eyePos _unit]) > 0.5})}};

		private _canDelete = count _seenBy == 0;

		if (_canDelete) then
		{
			_unit call (_module getVariable ["#onDeleted",{}]);
			deleteVehicle _unit;
		};

		_canDelete
	};

	case "createUnit":
	{
		private _pos = _input param [1,[],[[]]];

		// Randomize position
		if (count _pos == 0) then
		{
			_pos = getPos selectRandom (_module getVariable ["#modulesUnit",[]]);
		};

		private _posASL = (AGLToASL _pos) vectorAdd [0,0,1.5];


		// Check if any player can see the point of creation
		private _seenBy = allPlayers select {_x distance _pos < 50 || {(_x distance _pos < 150 && {([_x,"VIEW"] checkVisibility [eyePos _x, _posASL]) > 0.5})}};

		// Terminate if any player can see the position
		if (count _seenBy > 0) exitWith {objNull};

		private _class = format["CivilianPresence_%1", selectRandom (_module getVariable ["#unitTypes",[]])];

		private _unit = if (_module getVariable ["#useAgents",true]) then
		{
			createAgent [_class, _pos, [], 0, "NONE"];
		}
		else
		{
			(createGroup civilian) createUnit [_class, _pos, [], 0, "NONE"];
		};

		// Make backlink to the core module
		_unit setVariable ["#core",_module];

		_unit setBehaviour "CARELESS";
		_unit spawn (_module getVariable ["#onCreated",{}]);
		_unit execFSM "A3\Modules_F_Tacops\Ambient\CivilianPresence\FSM\behavior.fsm";

		private _customClass = selectRandom (_module getVariable ["#unitTypesOverride", [""]]);
		[_unit, _customClass] spawn 
		{
			params
			[
				"_unit",
				"_customClass"
			];
			
			if (_customClass != "") then
			{
				_unit setUnitLoadout (getUnitLoadout (configFile >> "CfgVehicles" >> _customClass));

				([_unit, _customClass] call RS_CP_fnc_GetCompatibleFacesFromConfig) params ["_face", "_voice"];
				[_unit, _face, _voice] remoteExecCall ["BIS_fnc_setIdentity", 0, true];
			};
		};

		_unit
	};

	case "getObjects":
	{
		private _objectType = _input param [1,"",[""]];	if (_objectType == "") exitWith {[]};

		private _objects = _module getVariable _objectType;

		if (isNil{_objects}) then
		{
			private _area = _module getVariable ["#area",[]];

			if (count _area == 0) then
			{
				_area = [getPos _module];
				_area append (_module getVariable ["objectarea",[]]);

				_module setVariable ["#area",_area];
			};

			_objects = (entities [[_objectType], []]) inAreaArray _area;
		};

		_module setVariable [_objectType,_objects];

		_objects
	};
};