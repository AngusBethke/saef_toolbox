/*
	fn_JsonLogger.sqf

	Description:
		Handles logging given items in JSON format
*/

params
[
	"_type",
	["_params", []]
];

// Set the script tag
private
[
	"_scriptTag"
];

_scriptTag = "SAEF JSON Logger";

/*
	-------------
	-- LOG --
	-------------

	Logs a string with title
*/
if (toUpper(_type) == "LOG") exitWith
{
	_params params
	[
		"_title",
		"_item"
	];

	diag_log text (format ["[%1] %2", _title, _item]);
};

/*
	-------------
	-- LOGITEM --
	-------------

	Logs a single item in Json Format
*/
if (toUpper(_type) == "LOGITEM") exitWith
{
	diag_log text (format ["[SAEF] [JSON] %1", (["BuildItem", _params] call SAEF_LOG_fnc_JsonLogger)]);
};

/*
	--------------
	-- LOGITEMS --
	--------------

	Logs an array of items in Json Format
*/
if (toUpper(_type) == "LOGITEMS") exitWith
{
	diag_log text (format ["[SAEF] [JSON] %1", (["BuildItems", _params] call SAEF_LOG_fnc_JsonLogger)]);
};

/*
	---------------
	-- BUILDITEM --
	---------------

	Builds a single item in Json Format
*/
if (toUpper(_type) == "BUILDITEM") exitWith
{
	// Return formatted item
	(format ["{%1}", (["CreateJsonItem", _params] call SAEF_LOG_fnc_JsonLogger)])
};

/*
	----------------
	-- BUILDITEMS --
	----------------

	Builds an array of items in Json Format
*/
if (toUpper(_type) == "BUILDITEMS") exitWith
{
	private
	[
		"_items",
		"_itemsToRemove"
	];

	_items = "";
	_itemsToRemove = [];

	{
		_x params
		[
			"_name",
			"_value"
		];

		if (isNil "_value") then
		{
			_itemsToRemove pushBack _x;
		};
	} forEach _params;

	_params = _params - _itemsToRemove;

	{
		_items = _items + (["CreateJsonItem", _x] call SAEF_LOG_fnc_JsonLogger);

		if (_forEachIndex < ((count _params) - 1)) then
		{
			_items = _items + ",";
		};
	} foreach _params;

	// Return the items
	(format ["{%1}", _items])
};

/*
	--------------------
	-- CREATEJSONITEM --
	--------------------

	Creates a single json item
*/
if (toUpper(_type) == "CREATEJSONITEM") exitWith
{
	_params params
	[
		"_name",
		"_value",
		["_valueIsPreFormatted", false]
	];

	private
	[
		"_item"
	];

	if (isNil "_value") exitWith {};

	if (_valueIsPreFormatted) then
	{
		_item = (format ["""%1"":%2", _name, (["Format", _value] call SAEF_LOG_fnc_JsonLogger)]);
	}
	else
	{
		_item = (format ["""%1"":""%2""", _name, (["Format", _value] call SAEF_LOG_fnc_JsonLogger)]);
	};

	// Return the json item
	_item
};

/*
	------------
	-- FORMAT --
	------------

	Formats string or array for JSON
*/
if (toUpper(_type) == "FORMAT") exitWith
{
	if ((typeName _params) != "ARRAY") exitWith 
	{
		_params
	};

	private
	[
		"_items"
	];

	_items = [];
	
	{
		_items pushBack (text (format ["%1", _x]));
	} forEach _params;

	// Return the json array
	_items
};

// Log warning if type is not recognised
[_scriptTag, 2, (format ["Unrecognised type [%1], nothing is being executed!", _type])] call RS_fnc_LoggingHelper;