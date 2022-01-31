/**
	@namespace RS
	@class Admin
	@method RS_fnc_Admin_CreateRespawnPos
	@file fn_Admin_CreateRespawnPos.sqf
	@summary Adds Action to Player for Admin Utilities
	@param any _unit
**/

/*
	Name:			fn_Admin_CreateRespawnPos.sqf
	Description:	Adds Action to Player for Admin Utilities
*/

private
[
	"_unit",
	"_side",
	"_marker",
	"_msg"
];

// Variable Decleration
_unit = _this select 0;
_side = side _unit;
_marker = "";
_msg = "";

// Check callers side
switch (_side) do 
{
	case WEST : {
		_marker = "respawn_west";
	};
	case EAST : {
		_marker = "respawn_east";
	};
	case INDEPENDENT : {
		_marker = "respawn_guerrila";
	};
	case CIVILIAN : {
		_marker = "respawn_civilian";
	};
	default {
		_marker = "respawn";
	};
};

// Create marker and create appropriate message
if ((markerPos _marker) isEqualTo [0,0,0]) then
{
	createMarker [_marker, (getPos _unit)];
	_msg = format ["[ADMIN UTILITIES] [INFO] Creating Respawn Marker (%1) at given position %2", _marker, (getPos _unit)];
}
else
{
	_msg = format ["[ADMIN UTILITIES] [INFO] Respawn Marker (%1) Already Exists", _marker];
};

// Display and Log Message
hint _msg;
diag_log _msg;

missionNamespace setVariable ["Admin_RespawnMarkerExists", true, true];

/*
	END
*/