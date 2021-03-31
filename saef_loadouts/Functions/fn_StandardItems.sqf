/*
	fn_StandardItems.sqf

	Description:
		Adds the standard items that we commonly include in loadouts

	How to Call:
		[
			_unit,				// The unit we're applying the loadout to
			_excludeWatch,		// (Optional) Whether or not to exclude the watch
			_excludeMap,		// (Optional) Whether or not to exclude the map
			_excludeCompass,	// (Optional) Whether or not to exclude the compass
			_excludeGPS,		// (Optional) Whether or not to exclude the gps
			_excludeRadio		// (Optional) Whether or not to exclude the radio
		] call RS_LD_fnc_StandardItems;
*/

params
[
	"_unit",
	["_excludeWatch", false],
	["_excludeMap", false],
	["_excludeCompass", false],
	["_excludeGPS", false],
	["_excludeRadio", false]
];

// Add items to Uniform
[_unit, "Uniform", ["ACE_EarPlugs", 1]] call RS_LD_fnc_TryAddItems;
[_unit, "Uniform", ["ACE_MapTools", 1]] call RS_LD_fnc_TryAddItems;
[_unit, "Uniform", ["ACE_Flashlight_MX991", 1]] call RS_LD_fnc_TryAddItems;

// Add basic items
removeAllAssignedItems _unit;
if (!_excludeWatch) then
{
	_unit linkItem "ItemWatch";
};

if (!_excludeMap) then
{
	_unit linkItem "ItemMap";
};

if (!_excludeCompass) then
{
	_unit linkItem "ItemCompass";
};

if (!_excludeGPS) then
{
	_unit linkItem "ItemGPS";
};

if (!_excludeRadio) then
{
	_unit linkItem "tf_anprc152";
};

// Set the speaker
_unit setSpeaker "ace_novoice";