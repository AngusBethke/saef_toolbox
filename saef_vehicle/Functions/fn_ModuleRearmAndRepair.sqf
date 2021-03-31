/*
	fn_ModuleRearmAndRepair.sqf

	Description:
		Handles module functionality for rearming and repairing
*/

if (!isServer) exitWith {};

if (is3DEN) exitWith {};

private
[
	"_scriptTag"
];
_scriptTag = "SAEF_VEH_fnc_ModuleRearmAndRepair";

params
[
	 ["_logic", objNull, [objNull]]
	,["_units", [], [[]]]
	,["_activated", true, [true]]
	,["_fromQueue", false, [false]]
];

// Recursive call to make sure all of these are processed in the queue
if (!_fromQueue) exitWith
{
	private
	[
		"_params"
	];

	_params = _this;
	_params set [3, true];

	["SAEF_RnR_ModuleQueue", _params, "SAEF_VEH_fnc_ModuleRearmAndRepair"] call RS_MQ_fnc_MessageEnqueue;
};

// If our module is active then we execute
if (_activated) then 
{
	// Check Logic Objects that are nearby or sync'd
	private
	[
		"_syncedObjects"
	];

	_syncedObjects = (synchronizedObjects _logic);

	if (_syncedObjects isEqualTo []) exitWith
	{
		[_scriptTag, 1, (format ["Cannot create configuration with no synchronised entities!"])] call RS_fnc_LoggingHelper;
	};

	// Fetch information from sync'd objects
	private
	[
		"_failed"
		,"_configArray"
	];
	
	_failed = false;
	_configArray = [];

	{
		_x params ["_syncedObject"];

		_childSyncedObjects = (synchronizedObjects _syncedObject);

		if (_childSyncedObjects isEqualTo []) exitWith
		{
			_failed = true;
			[_scriptTag, 1, (format ["Synchronised object [%1: %2] has no child synchronised objects!", _syncedObject, (typeOf _syncedObject)])] call RS_fnc_LoggingHelper;
		};

		private
		[
			"_objects"
		];

		_objects = [];
		{
			_x params ["_object"];
			_objects pushBackUnique _object;
		} forEach _childSyncedObjects;

		switch (typeOf _syncedObject) do
		{
			case "SAEF_ModuleRearmAndRepairVehicle":
			{
				_configArray pushBack ["vehicles", _objects];
			};
			case "SAEF_ModuleRearmAndRepairObject":
			{
				_configArray pushBack ["objects", _objects];
			};
			default {};
		};
	} forEach _syncedObjects;

	if (_failed) exitWith
	{
		[_scriptTag, 1, (format ["Synchronised object processing failed!"])] call RS_fnc_LoggingHelper;
	};

	// Validation step
	private
	[
		"_valid",
		"_newConfigArray"
	];

	_valid = true;
	_newConfigArray = [["", []],["", []]];

	{
		_x params
		[
			"_configName"
			,"_objects"
		];

		switch _configName do
		{
			case "vehicles":
			{
				{
					_x params ["_object"];

					// If our classname is not a man, this needs to be pulled out
					if (!(((typeOf _object) isKindOf ["Helicopter", configFile >> "CfgVehicles"]) 
						|| ((typeOf _object) isKindOf ["Plane", configFile >> "CfgVehicles"])
						|| ((typeOf _object) isKindOf ["Ship", configFile >> "CfgVehicles"])
						|| ((typeOf _object) isKindOf ["LandVehicle", configFile >> "CfgVehicles"]))) then
					{
						_objects = _objects - [_object];
					};
				} forEach _objects;

				if (_objects isEqualTo []) then
				{
					_valid = false;
					[_scriptTag, 1, (format ["Vehicle classname validation removed all classnames!"])] call RS_fnc_LoggingHelper;
				}
				else
				{
					_newConfigArray set [0, [_configName, _objects]];
				};
			};
			case "objects":
			{
				{
					_x params ["_object"];

					// If our classname is not a man, this needs to be pulled out
					if (!(((typeOf _object) isKindOf ["Helicopter", configFile >> "CfgVehicles"]) 
						|| ((typeOf _object) isKindOf ["Plane", configFile >> "CfgVehicles"])
						|| ((typeOf _object) isKindOf ["Ship", configFile >> "CfgVehicles"])
						|| ((typeOf _object) isKindOf ["LandVehicle", configFile >> "CfgVehicles"])
						|| ((typeOf _object) isKindOf ["Static", configFile >> "CfgVehicles"]))) then
					{
						_objects = _objects - [_object];
					};
				} forEach _objects;

				if (_objects isEqualTo []) then
				{
					_valid = false;
					[_scriptTag, 1, (format ["Object classname validation removed all classnames!"])] call RS_fnc_LoggingHelper;
				}
				else
				{
					_newConfigArray set [1, [_configName, _objects]];
				};
			};
			default {};
		};

		if (!_valid) exitWith {};
	} forEach _configArray;

	if (!_valid) exitWith
	{
		[_scriptTag, 1, (format ["Validation for synchronised objects failed!"])] call RS_fnc_LoggingHelper;
	};

	private
	[
		"_vehicle",
		"_object"
	];

	_newConfigArray params
	[
		"_vehicles",
		"_objects"
	];

	_vehicle = (_vehicles select 1) select 0;
	_object = (_objects select 1) select 0;

	// Get ourselves a safe vehicle varname
	private
	[
		"_vehString",
		"_objString",
		"_vehVarNameSeed",
		"_notFound",
		"_control"
	];

	_vehString = "";
	_vehVarNameSeed = "saef_vehicle";
	_notFound = true;
	_control = 1;

	while {_notFound} do
	{
		private
		[
			"_newVarName",
			"_found"
		];

		_newVarName = (format ["%1_%2", _vehVarNameSeed, _control]);
		_found = false;

		{
			if ((vehicleVarName _x) == _newVarName) then
			{
				_found = true;
			};
		} forEach vehicles;

		if (!_found) exitWith
		{
			_notFound = false;
			_vehString = _newVarName;
		};

		_control = _control + 1;
	};

	// Once we have our vehicle var name, we can set it
	_objString = (format ["%1_pad", _vehString]);

	// Re-set the vehicle varname
	[_vehicle, _vehString] call SAEF_VEH_fnc_RnR_GlobalRename;
	[_object, _objString] call SAEF_VEH_fnc_RnR_GlobalRename;

	private
	[
		"_allowedClassnames",
		"_additionalScripts"
	];

	// Load our variables from the module
	_allowedClassnames = _logic getVariable ["AllowedClassnames", ""];

	if (_allowedClassnames != "") then
	{
		private
		[
			"_classLockVariable"
		];

		// Get rid of any spaces
		_allowedClassnames = (_allowedClassnames splitString " ") joinString "";

		// Set the class lock variable
		_classLockVariable = (format ["SAEF_RnR_Vehicle_%1_ClassLock", _vehString]);
		missionNamespace setVariable [_classLockVariable, (_allowedClassnames splitString ","), true];
	};

	_additionalScripts = _logic getVariable ["AdditionalScripts", ""];

	if (_additionalScripts != "") then
	{
		private
		[
			"_parsedAdditionalScripts",
			"_additionalScriptsVariable"
		];

		// Parse out our array from string
		_parsedAdditionalScripts = (call compile _additionalScripts);

		// Set the additional scripts variable
		_additionalScriptsVariable = (format ["SAEF_RnR_Vehicle_%1_AdditionalScripts", _vehString]);
		missionNamespace setVariable [_additionalScriptsVariable, _parsedAdditionalScripts, true];
	};

	// Run the Handler
	[_vehString, _objString] call SAEF_VEH_fnc_RnR_Setup;

	// Cleanup all the sync'd modules
	{
		deleteVehicle _x;
	} forEach _syncedObjects;
};

// We are going to cleanup the module at this point
deleteVehicle _logic;

// Return Function Success
true