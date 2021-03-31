/*
	fn_AddGearItem.sqf

	Description:
		Adds the given gear item to the unit with optional randomisation inclusion, will also filter out any unowned DLC

	How to Call:
		[
			_unit,					// The unit to apply the gear item to
			_type,					// The type of gear item
			_gearItem,				// The classname of the item
			_randomisationTag		// (Optional) The tag used to add to and source gear from the randomisation pool
		] call RS_LD_fnc_AddGearItem;
*/

params
[
	"_unit",
	"_type",
	"_gearItem",
	["_randomisationTag", ""]
];

private
[
	"_scriptTag",
	"_error"
];

_scriptTag = "Loadout: AddGearItem";
_error = false;

if (_randomisationTag != "") then
{
	["SAEF_LoadoutQueue", [_gearItem, _randomisationTag], "RS_LD_fnc_AddToRandomisationPool"] remoteExecCall ["RS_MQ_fnc_MessageEnqueue", 2, false];

	private
	[
		"_randomGearPool",
		"_alteredGearPool"
	];

	_randomGearPool = missionNamespace getVariable [(format ["SAEF_Loadout_%1", _randomisationTag]), [_gearItem]];
	_alteredGearPool = [_randomGearPool] call RS_LD_fnc_FilterGearPool;

	if (_alteredGearPool isEqualTo []) exitWith
	{
		[_scriptTag, 1, (format ["Could not find gear items in config file %1 or you do not own the DLC required for them", _randomGearPool])] call RS_fnc_LoggingHelper;
		_error = true;
	};

	// Grab item from the filtered gear pool
	_gearItem = selectRandom _alteredGearPool;
};

if (_error) exitWith {};

switch toUpper(_type) do
{
	case "UNIFORM" :
	{
		_unit forceAddUniform _gearItem;

		if ((uniform _unit) != _gearItem) then
		{
			[_scriptTag, 1, (format ["Failed to add [%1] of with given classname [%2] to unit [%3]", _type, _gearItem, _unit])] call RS_fnc_LoggingHelper;
		};
	};

	case "VEST" :
	{
		_unit addVest _gearItem;

		if ((vest _unit) != _gearItem) then
		{
			[_scriptTag, 1, (format ["Failed to add [%1] of with given classname [%2] to unit [%3]", _type, _gearItem, _unit])] call RS_fnc_LoggingHelper;
		};
	};

	case "BACKPACK" :
	{
		_unit addBackpack _gearItem;

		if ((backpack _unit) != _gearItem) then
		{
			[_scriptTag, 1, (format ["Failed to add [%1] of with given classname [%2] to unit [%3]", _type, _gearItem, _unit])] call RS_fnc_LoggingHelper;
		};
	};

	case "GOGGLES" :
	{
		_unit addGoggles _gearItem;

		if ((goggles _unit) != _gearItem) then
		{
			[_scriptTag, 1, (format ["Failed to add [%1] of with given classname [%2] to unit [%3]", _type, _gearItem, _unit])] call RS_fnc_LoggingHelper;
		};
	};

	case "HEADGEAR" :
	{
		_unit addHeadgear _gearItem;

		if ((headgear _unit) != _gearItem) then
		{
			[_scriptTag, 1, (format ["Failed to add [%1] of with given classname [%2] to unit [%3]", _type, _gearItem, _unit])] call RS_fnc_LoggingHelper;
		};
	};
	
	default 
	{
		[_scriptTag, 1, (format ["Unrecognised type [%1] of container!", _type])] call RS_fnc_LoggingHelper;
	};
};