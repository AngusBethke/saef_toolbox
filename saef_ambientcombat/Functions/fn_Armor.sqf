/*
	fn_Armor.sqf

	Description:
		Handles armor methods and functionality for the ambient combat toolset
*/

params
[
	"_type",
	["_params", []]
];

private
[
	"_scriptTag"
];

_scriptTag = "SAEF Ambient Combat - Armor";

/*
	----------
	-- INIT --
	----------

	Handles initialisation of the function set
*/
if (toUpper(_type) == "INIT") exitWith
{
	[_scriptTag, 2, (format ["[%1] Method not yet implemeneted!", _type])] call RS_fnc_LoggingHelper;
};

// Log warning if type is not recognised
[_scriptTag, 2, (format ["Unrecognised type [%1], nothing is being executed!", _type])] call RS_fnc_LoggingHelper;