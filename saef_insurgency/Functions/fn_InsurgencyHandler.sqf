/**
	@namespace RS_INS
	@class Insurgency
	@method RS_INS_fnc_InsurgencyHandler
	@file fn_InsurgencyHandler.sqf
	@summary Controls creation of insurgency zones and preps unit spawners
	
	@param bool _enableIEDs
	@param bool _enableChcs

	@todo _enableChcs is not in use?

	@usage ```[true, false] call RS_INS_fnc_InsurgencyHandler;```
	
**/
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