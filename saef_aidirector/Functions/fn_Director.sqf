/*
	fn_Director.sqf

	Description:
		Handles the main direction component for the AI director, this is scoped on a "per area" basis

	Player Conditions:
		VeryGood
		Good
		Neutral
		Bad
		VeryBad

	Ammo Statuses:
		Green
		Yellow
		Orange
		Red
		Black
*/

params
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
	([] call SAEF_AID_fnc_GetPlayerConditions) params
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