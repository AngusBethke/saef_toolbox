/*
	fn_Director.sqf

	Description:
		Handles the main direction component for the AI director, this is scoped on a "per area" basis
*/

params
[
	"_type",
	["_params", []]
];

/*
	------------
	-- HANDLE --
	------------

	Handles the AI Director
*/
if (toUpper(_type) == "HANDLE") exitWith
{
	_params params
	[
		"_areaTag"
	];

	private
	[
		"_runDirectorVar"
	];

	_runDirectorVar = (format ["SAEF_Run_Director_%1", _areaTag]);
	missionNamespace setVariable [_runDirectorVar, true, true];

	while {(missionNamespace getVariable [_runDirectorVar, false])} do
	{
		// Get player conditions
		(["GetConditions"] call SAEF_AID_fnc_Player) params
		[
			"_livePlayers",
			"_generalCondition",
			"_ammoStatus"
		];

		

		// Re-evaluate every 30 seconds
		sleep 30;
	};

	// Get player groups
	private
	[
		""
	];
};

// Log warning if type is not recognised
["SAEF_AID_fnc_Director", 2, (format ["Unrecognised type [%1], nothing is being executed!", _type])] call RS_fnc_LoggingHelper;