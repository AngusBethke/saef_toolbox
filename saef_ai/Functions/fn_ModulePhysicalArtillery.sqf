/*
	fn_ModulePhysicalArtillery.sqf

	Description:
		Handles module functionality for physical artillery
*/

if (!isServer) exitWith {};

if (is3DEN) exitWith {};

private
[
	"_scriptTag"
];
_scriptTag = "SAEF_AI_fnc_ModulePhysicalArtillery";

// Debug full parameter logging
[_scriptTag, 4, (format ["Debug Parameters: %1", _this])] call RS_fnc_LoggingHelper;

params
[
	 ["_logic", objNull, [objNull]]
	,["_units", [], [[]]]
	,["_activated", true, [true]]
];

// If our module is active then we execute
if (_activated) then 
{
	private
	[
		"_shellType"
		,"_rounds"
		,"_spread"
	];

	// Load our variables from the module
	_shellType = _logic getVariable ["ShellType", "explosive"]; 
	_rounds = _logic getVariable ["Rounds", 1]; 
	_spread = _logic getVariable ["Spread", 0];

	// Get our synchronised objects
	private
	[
		"_syncedObjects"
	];

	_syncedObjects = (synchronizedObjects _logic);

	if (_syncedObjects isEqualTo []) exitWith
	{
		[_scriptTag, 1, (format ["No objects synchronised to this module!"])] call RS_fnc_LoggingHelper;
	};

	// Get the vehicles from those synchronised objects
	private
	[
		"_vehicles"
	];

	_vehicles = [];
	{
		_x params ["_vehicle"];

		if ((typeOf _vehicle) isKindOf ["LandVehicle", configFile >> "CfgVehicles"]) then
		{
			_vehicles pushBackUnique (vehicle _vehicle);
		};
	} forEach _syncedObjects;

	if (_vehicles isEqualTo []) exitWith
	{
		[_scriptTag, 1, (format ["No vehicles synchronised to this module!"])] call RS_fnc_LoggingHelper;
	};

	// Get the position of the module
	private
	[
		"_position"
	];

	_position = (position _logic);

	[_vehicles, [_position], _rounds, _shellType, _spread] spawn SAEF_AI_fnc_PhysicalArtillery;
};

// We are going to cleanup the module at this point
deleteVehicle _logic;

// Return Function Success
true