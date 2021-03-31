/*
	fn_AddGroupToZeus.sqf
	Author: Angus Bethke
	Description: 
		Adds given group to zeus, should be executed in server locality
*/

params
[
	"_group"
];

{
	_x params ["_curator"];

	private
	[
		"_objects"
	];

	_objects = [] + (units _group);
	{
		_x params ["_unit"];
		_objects pushBackUnique (vehicle _unit);
	} forEach (units _group);

	_curator addCuratorEditableObjects [_objects, true];
} forEach allCurators;

// Returns nothing (can be spawned)