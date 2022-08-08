/*
	fn_Sounds.sqf

	Description:
		Returns random sound from requested sound types
*/

params
[
	"_type"
];

if (toUpper(_type) == "BAG") exitWith
{
	private
	[
		"_sound"
	];

	_sound = (selectRandom ["SAEF_LRRP_Bag_1", "SAEF_LRRP_Bag_2", "SAEF_LRRP_Bag_3", "SAEF_LRRP_Bag_4", "SAEF_LRRP_Bag_5"]);

	// Return the sound
	_sound
};

if (toUpper(_type) == "BAG3D") exitWith
{
	private
	[
		"_sounds",
		"_sound"
	];

	_sounds =
	[
		"saef_lrrp\Sounds\bag_1.ogg", 
		"saef_lrrp\Sounds\bag_2.ogg", 
		"saef_lrrp\Sounds\bag_3.ogg", 
		"saef_lrrp\Sounds\bag_4.ogg", 
		"saef_lrrp\Sounds\bag_5.ogg"
	];

	_sound = (selectRandom _sounds);

	// Return the sound
	_sound
};

// Log warning if type is not recognised
["SAEF_LRRP_fnc_Sounds", 2, (format ["Unrecognised type [%1], nothing is being executed!", _type])] call RS_fnc_LoggingHelper;