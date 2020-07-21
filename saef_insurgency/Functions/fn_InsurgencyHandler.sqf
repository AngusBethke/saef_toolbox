/*
	fn_InsurgencyHandler.sqf
	Description: Controls creation of insurgency zones and preps unit spawners
	How to Call: [true, false] call RS_INS_fnc_InsurgencyHandler;
*/

params
[
	"_enableIEDs",
	"_enableChcs"
];

_locations = [] call RSAO_fnc_ListLocations;

{
	[_x, _enableIEDs] spawn RS_INS_fnc_CreateInsurgencyPoint;
} forEach _locations;