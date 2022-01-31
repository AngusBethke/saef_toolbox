/**
	@namespace SAEF_AS
	@class AutomatedSpawning
	@method SAEF_AS_fnc_ConfigCoreValidation
	@file fn_ConfigCoreValidation.sqf
	@summary Validates the core module
	@param any _logic
	@param any _tag
**/

/* 
	fn_ConfigCoreValidation.sqf

	Description: 
		Validates the core module

	How to Call: 
		[
			_logic		// The module to validate
		] call SAEF_AS_fnc_ConfigCoreValidation;
*/

params
[
	"_logic",
	"_tag"
];

// Check Logic Objects that are nearby or sync'd
private
[
	"_syncedObjects",
	"_infoArray",
	"_newConfigArray"
];

_syncedObjects = [_logic] call SAEF_AS_fnc_GetSynchronizedObjects;

_infoArray = [];
_newConfigArray = [["", []],["", []],["", []],["", []]];

if (_syncedObjects isEqualTo []) exitWith
{
	_infoArray pushBack [1, (format ["Cannot create configuration with no synchronised entities!"])];
	[_newConfigArray, false, _infoArray]
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

	private
	[
		"_childSyncedObjects"
	];

	_childSyncedObjects = [_syncedObject] call SAEF_AS_fnc_GetSynchronizedObjects;

	if (_childSyncedObjects isEqualTo []) exitWith
	{
		_failed = true;
		_infoArray pushBack [1, (format ["Synchronised object [%1: %2] has no child synchronised objects!", _syncedObject, (typeOf _syncedObject)])];
	};

	private
	[
		"_classnames"
	];

	_classnames = [];
	{
		_x params ["_object"];
		_classnames pushBack (typeOf (vehicle _object));

		// After we've gotten the classname we need to pull this object out of the array
		_childSyncedObjects = _childSyncedObjects - [_object];

		// If this isn't 3DEN then we need to delete these units
		if (!is3DEN) then
		{
			// If this is a vehicle we need to delete the crew
			{
				_x params ["_crew"];

				if (_crew != _object) then
				{
					deleteVehicle _crew;
				};
			} forEach crew _object;

			// Cleanup the object
			deleteVehicle _object;
		};

	} forEach _childSyncedObjects;

	switch (typeOf _syncedObject) do
	{
		case "SAEF_ModuleSpawnAreaConfigUnits":
		{
			_configArray pushBack [(format ["%1_units", _tag]), _classnames];
		};
		case "SAEF_ModuleSpawnAreaConfigLightVehicles":
		{
			_configArray pushBack [(format ["%1_lightvehicles", _tag]), _classnames];
		};
		case "SAEF_ModuleSpawnAreaConfigHeavyVehicles":
		{
			_configArray pushBack [(format ["%1_heavyvehicles", _tag]), _classnames];
		};
		case "SAEF_ModuleSpawnAreaConfigParaVehicles":
		{
			_configArray pushBack [(format ["%1_paravehicles", _tag]), _classnames];
		};
		default {};
	};
} forEach _syncedObjects;

private
[
	"_valid"
];

_valid = true;

// Exit out if synchronised object collection failed
if (_failed) exitWith
{
	_infoArray pushBack [1, (format ["Synchronised object processing failed!"])];
	[_newConfigArray, false, _infoArray]
};

{
	_x params
	[
		"_configName"
		,"_classnames"
	];

	switch _configName do
	{
		case (format ["%1_units", _tag]):
		{
			{
				_x params ["_classname"];

				// If our classname is not a man, this needs to be pulled out
				if (!(_classname isKindOf ["Man", configFile >> "CfgVehicles"])) then
				{
					_classnames = _classnames - [_classname];
				};
			} forEach _classnames;

			if (_classnames isEqualTo []) then
			{
				_valid = false;
				_infoArray pushBack [1, (format ["Unit classname validation removed all classnames (ensure at least one unit of type 'man' is synchronised)!"])];
			}
			else
			{
				_newConfigArray set [0, [_configName, _classnames]];
			};
		};
		case (format ["%1_lightvehicles", _tag]):
		{
			{
				_x params ["_classname"];

				// If our classname is not a vehicle, this needs to be pulled out
				if (!(_classname isKindOf ["LandVehicle", configFile >> "CfgVehicles"])) then
				{
					_classnames = _classnames - [_classname];
				};
			} forEach _classnames;

			if (_classnames isEqualTo []) then
			{
				_valid = false;
				_infoArray pushBack [1, (format ["Light vehicle classname validation removed all classnames (ensure at least one unit of type 'land vehicle' is synchronised)!"])];
			}
			else
			{
				_newConfigArray set [1, [_configName, _classnames]];
			};
		};
		case (format ["%1_heavyvehicles", _tag]):
		{
			{
				_x params ["_classname"];

				// If our classname is not a vehicle, this needs to be pulled out
				if (!(_classname isKindOf ["LandVehicle", configFile >> "CfgVehicles"])) then
				{
					_classnames = _classnames - [_classname];
				};
			} forEach _classnames;

			if (_classnames isEqualTo []) then
			{
				_valid = false;
				_infoArray pushBack [1, (format ["Heavy vehicle classname validation removed all classnames (ensure at least one unit of type 'land vehicle' is synchronised)!"])];
			}
			else
			{
				_newConfigArray set [2, [_configName, _classnames]];
			};
		};
		case (format ["%1_paravehicles", _tag]):
		{
			{
				_x params ["_classname"];

				// If our classname is not a plane or helicopter, this needs to be pulled out
				if (!((_classname isKindOf ["Helicopter", configFile >> "CfgVehicles"]) || (_classname isKindOf ["Plane", configFile >> "CfgVehicles"]))) then
				{
					_classnames = _classnames - [_classname];
				};
			} forEach _classnames;

			if (_classnames isEqualTo []) then
			{
				_valid = false;
				_infoArray pushBack [1, (format ["Paradrop vehicle classname validation removed all classnames (ensure at least one unit of type 'helicopter' or 'plane' is synchronised)!"])];
			}
			else
			{
				_newConfigArray set [3, [_configName, _classnames]];
			};
		};
		default {};
	};

	if (!_valid) exitWith {};
} forEach _configArray;

// Double check validation for our new configuration
{
	_x params
	[
		"_configName", 
		"_classnames"
	];

	if (_configName == "") then
	{
		_valid = false;

		private
		[
			"_typeOfConfig"
		];

		_typeOfConfig = "";

		switch _forEachIndex do
		{
			case 0 :
			{
				_typeOfConfig = "Unit";
			};
			case 1 :
			{
				_typeOfConfig = "Light Vehicle";
			};
			case 2 :
			{
				_typeOfConfig = "Heavy Vehicle";
			};
			case 3 :
			{
				_typeOfConfig = "Paradrop Vehicle";
			};
			default {};
		};

		_infoArray pushBack [1, (format ["%1 configuration module is missing!", _typeOfConfig])];
	};
} forEach _newConfigArray;

// Exit out if our validation failed
if (!_valid) exitWith
{
	_infoArray pushBack [1, (format ["Validation for synchronised objects failed!"])];
	[_newConfigArray, false, _infoArray]
};

// Return our configuration
[_newConfigArray, true, _infoArray]