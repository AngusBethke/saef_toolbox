/*
	fn_TryAddItems.sqf

	Description:
		Will try add items to specified container, will log readable message if it fails
*/

params
[
	"_unit",
	"_type",
	"_itemArray"
];

// Get our info out of the item array
_itemArray params
[
	"_item",
	"_count"
];

private
[
	"_scriptTag"
];

_scriptTag = "Loadout: TryAddItems";

// Get our code for testing the items
([_type] call RS_LD_fnc_GetItemManipulationCode) params
[
	"_error",
	"_checkCode",
	"_addCode"
];

// Bail out if we hit an error
if (_error) exitWith 
{
	// Return Failure
	false
};

// Check if we are able to add the items
private
[
	"_newCount"
];

_newCount = _count;
while { (_newCount > 0) } do
{
	private
	[
		"_canAddItem"
	];

	_canAddItem = [_unit, _item, _newCount] call _checkCode;

	// If we can add the item then jump out of the scope
	if (_canAddItem) exitWith {};
	
	_newCount = _newCount - 1;
};

// Add them if we can, otherwise log a resonable error message
if (_newCount > 0) exitWith
{
	for "_i" from 1 to _newCount do { [_unit, _item] call _addCode; };

	if (_newCount != _count) then
	{
		[_scriptTag, 2, (format ["Not enough space to add count [%1] of item [%2] to specified container [%3], adding [%4] item(s) instead.", _count, _item, _type, _newCount])] call RS_fnc_LoggingHelper;
	};

	// Return Success
	true
};

[_scriptTag, 1, (format ["Not enough space to add count [%1] of item [%2] to specified container [%3]!", _count, _item, _type])] call RS_fnc_LoggingHelper;

// Return Failure
false