/*
	fn_HelicopterInsertion_PlayerFastRope.sqf

	Description:
		Handles fast rope for given unit
*/

params
[
	"_vehicle",
	"_index",
	["_unit", player]
];

sleep _index;

[_unit, _vehicle] call ace_fastroping_fnc_fastRope;