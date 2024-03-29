/*
	fn_Infantry.sqf

	Description:
		Handles infantry methods and functionality for the ambient combat toolset
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

_scriptTag = "SAEF Ambient Combat - Infantry";

/*
	------------
	-- CREATE --
	------------

	Creates the unit and runs the anti-air function
*/
if (toUpper(_type) == "CREATE") exitWith
{
	_params params
	[
		"_marker",
		"_secondaryMarker",
		"_areaTag",
		"_runVariable"
	];

	(["GetConfigByTagOrMarker", [_areaTag]] call SAEF_AC_fnc_Helpers) params
	[
		"_blockPatrol",
		"_blockGarrison",
		"_units",
		"_side",
		"_lightVehicles",
		"_heavyVehicles",
		"_paraVehicles",
		"_playerValidation",
		"_groupScripts",
		"_queueValidation",
		"_defaultDetector",
		"_useAiDirector",
		"_aiDirectorParams",
		"_paraStartPosVariable"
	];
	
	private
	[
		"_groupCodeBlock",
		"_spawnParams"
	];

	_groupCodeBlock = {
		_x enableFatigue false;
	};

	_spawnParams = 
	[
		_marker, 
		"CA", 
		_units, 
		_side, 
		12, 
		_secondaryMarker, 
		50, 
		50, 
		_groupCodeBlock,
		false,
		"",
		{true},
		[],
		{true},
		true,
		[
			_runVariable,
			120
		]
	];

	["SAEF_SpawnerQueue", _spawnParams, "SAEF_AS_fnc_Spawner"] call RS_MQ_fnc_MessageEnqueue;
};

// Log warning if type is not recognised
[_scriptTag, 2, (format ["Unrecognised type [%1], nothing is being executed!", _type])] call RS_fnc_LoggingHelper;