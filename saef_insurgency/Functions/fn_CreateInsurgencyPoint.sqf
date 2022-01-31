/**
	@namespace RS_INS
	@class Insurgency
	@method RS_INS_fnc_CreateInsurgencyPoint
	@file fn_CreateInsurgencyPoint.sqf
	@summary Code Executed from inside the InsurgencyHandler Triggers
	
	@param location _loc
	@param bool _enableIEDs
	
**/

/*
	fn_CreateInsurgencyPoint.sqf
	Description: Code Executed from inside the InsurgencyHandler Triggers
*/

params
[
	 "_loc"
	,"_enableIEDs"
];

if (((type _loc) != "NameCity") && ((type _loc) != "NameCityCapital") && ((type _loc) != "NameVillage")) exitWith {};

// Derive some information about the location
_pos = position _loc;
_sizeLoc = size _loc;
_size = selectMax _sizeLoc; 

// Get some information from Variables
_cnt = missionNamespace getVariable ["RS_Insurgency_UnitCount", 10];
_cls = missionNamespace getVariable ["RS_Insurgency_UnitClass", "C_man_1"];
_ldt = missionNamespace getVariable ["RS_Insurgency_UnitLoadout", "Loadouts\Civilian\AfricanCivilian.sqf"];

diag_log format ["[Ins_CreateInsurgencyPoint] [INFO] Starting wait for Player | Location: %1", (text _loc)];
_j = 1;

waitUntil {
	// Suspend
	sleep 5;
	
	// Log every 3 minutes
	if (_j == 36) then
	{
		_j = 1;
		diag_log format ["[Ins_CreateInsurgencyPoint] [INFO] Polling | Waiting for Player | Location: %1", (text _loc)];
	};
	_j = _j + 1;
	
	// Test if player is close by
	_closePlayer = [_pos, (_size + 300)] call RS_fnc_GetClosestPlayer;
	!(_closePlayer isEqualTo [0,0,0])
};

diag_log format ["[Ins_CreateInsurgencyPoint] [INFO] Wait for Player Finished | Location: %1", (text _loc)];

if (_enableIEDs) then
{
	[_pos, _size] call RS_INS_fnc_PlaceIeds;
};

[_pos, _size, _cnt, _cls, _ldt] call RS_INS_fnc_SpawnInsurgents;

sleep (600 + random(600));

[] call RS_INS_fnc_SwitchToInsurgent;

/*
	END
*/