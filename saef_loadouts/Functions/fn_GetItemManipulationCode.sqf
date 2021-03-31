/*
	fn_GetItemManipulationCode.sqf

	Description:
		Will grab the item manipulation code
*/

params
[
	"_type"
];

private
[
	"_scriptTag",
	"_error",
	"_checkCode",
	"_addCode"
];

_scriptTag = "Loadout: GetItemManipulationCode";
_error = false;
_checkCode = {};
_addCode = {};

switch toUpper(_type) do
{
	case "UNIFORM" :
	{
		_checkCode = 
		{
			params
			[
				"_unit",
				"_item",
				"_count"
			];

			(_unit canAddItemToUniform [_item, _count])
		};

		_addCode = 
		{
			params
			[
				"_unit",
				"_item"
			];

			_unit addItemToUniform _item;
		};
	};

	case "VEST" :
	{
		_checkCode = 
		{
			params
			[
				"_unit",
				"_item",
				"_count"
			];

			(_unit canAddItemToVest [_item, _count])
		};

		_addCode = 
		{
			params
			[
				"_unit",
				"_item"
			];

			_unit addItemToVest _item;
		};
	};

	case "BACKPACK" :
	{
		_checkCode = 
		{
			params
			[
				"_unit",
				"_item",
				"_count"
			];

			(_unit canAddItemToBackpack [_item, _count])
		};

		_addCode = 
		{
			params
			[
				"_unit",
				"_item"
			];

			_unit addItemToBackpack _item;
		};
	};

	default 
	{
		[_scriptTag, 1, (format ["Unrecognised type [%1] of container!", _type])] call RS_fnc_LoggingHelper;
		_error = true;
	};
};

// Return the code blocks
[_error, _checkCode, _addCode]