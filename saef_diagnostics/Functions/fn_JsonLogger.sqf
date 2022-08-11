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

/*
	-------------
	-- LOGITEM --
	-------------

	Logs a single item in Json Format
*/
if (toUpper(_type) == "LOGITEM") exitWith
{
	diag_log text (format ["[SAEF] [JSON] {%1}", (["CreateJsonItem", _params] call SAEF_LOG_fnc_JsonLogger)]);
};

/*
	--------------
	-- LOGITEMS --
	--------------

	Logs an array of items in Json Format
*/
if (toUpper(_type) == "LOGITEMS") exitWith
{
	private
	[
		"_items"
	];

	_items = "";

	{
		_items = _items + (["CreateJsonItem", _x] call SAEF_LOG_fnc_JsonLogger);

		if (_forEachIndex < ((count _params) - 1)) then
		{
			_items = _items + ",";
		};
	} foreach _params;

	diag_log text (format ["[SAEF] [JSON] {%1}", _items]);
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
		"_value"
	];

	private
	[
		"_item"
	];

	_item = (format ["""%1"":""%2""", _name, _value]);

	// Return the json item
	_item
};

// Log warning if type is not recognised
["SAEF_LOG_fnc_JsonLogger", 2, (format ["Unrecognised type [%1], nothing is being executed!", _type])] call RS_fnc_LoggingHelper;