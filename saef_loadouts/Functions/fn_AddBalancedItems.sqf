/*
	fn_AddBalancedItems.sqf

	Description:
		Takes the given items and tries to add them evenly into the inventory based on the given cap

	How to Call:
		[
			_unit,					// The unit to apply the gear item to
			_type,					// The type of container to add the gear items to
			_items,					// The items to add
			_count,					// The max amount that can be added
		] call RS_LD_fnc_AddBalancedItems;
*/

params
[
	"_unit",
	"_type",
	"_items",
	"_count"
];

// Get all of our items into a paired array
private
[
	"_countItemPairs"
];

_countItemPairs = [];
{
	_x params ["_item"];

	private
	[
		"_newCount"
	];

	_newCount = ceil (_count / (count _items));
	if (_forEachIndex != 0) then
	{
		_newCount = floor (_count / (count _items));
	};

	_countItemPairs pushBack [_item, _newCount];
} forEach _items;

// Start adding these items
{
	[_unit, _type, _x] call RS_LD_fnc_TryAddItems;
} forEach _countItemPairs;