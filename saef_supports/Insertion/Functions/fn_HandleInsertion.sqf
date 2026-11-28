/*
	fn_HandleInsertion.sqf

	Description:
		Handles the process of the paradrop

	[_location, _type] spawn SAEF_ASA_INS_fnc_HandleInsertion;
*/

params
[
	"_location",
	"_type",
	["_additionalParams", []],
	["_vehicleStart", [0,0,0]]
];

private
[
	"_vehicle",
	"_activeVar",
	"_activeVar_Vehicle",
	"_vehicleVar_Location"
];

_activeVar = format ["SAEF_ASA_INS_%1_CurrentlyActive", toUpper(_type)];
_activeVar_Vehicle = format ["SAEF_ASA_INS_%1_CurrentlyActive_Plane", toUpper(_type)];
_vehicleVar_Location = "SAEF_ASA_INS_Vehicle_Location";

// We're only going to create a vehicle if there isn't one currently active
if (!(missionNamespace getVariable [_activeVar, false])) then
{
	// Publish vehicle creation message to queue
	["SAEF_ASA_INS_Queue", [_location, _type, _vehicleStart], "SAEF_ASA_INS_fnc_SpawnVehicle"] call RS_MQ_fnc_MessageEnqueue;

	private
	[
		"_control"
	];

	_control = 0;
	waitUntil {
		sleep 0.1;

		_vehicle = missionNamespace getVariable [_activeVar_Vehicle, objNull];
		_control = _control + 1;

		((_vehicle != objNull) || (_control >= 100))
	};
};

sleep 5;

_vehicle = missionNamespace getVariable [_activeVar_Vehicle, objNull];

if ((_vehicle == objNull) || (isNull _vehicle)) exitWith
{
	["SAEF Handle Insertion", 1, format ["Vehicle is NULL! Params: %1", _this]] call RS_fnc_LoggingHelper;
};

if (toUpper(_type) == "PARA") then
{
	if ((_vehicle getVariable [_vehicleVar_Location, objNull]) != _location) exitWith
	{
		hint "Paradrop is already taking place for another location. Please try again later.";
	};
};

switch toUpper(_type) do
{
	case "PARA": 
	{
		[_vehicle, _type, _additionalParams] spawn SAEF_ASA_INS_fnc_HandleParadrop_Player;
	};

	case "CARGO": 
	{
		[_vehicle, _type, _additionalParams] spawn SAEF_ASA_INS_fnc_HandleParadrop_Cargo;
	};

	default 
	{
		["SAEF Handle Insertion", 1, format ["Unrecognised type: %1", _type]] call RS_fnc_LoggingHelper;
	};
};