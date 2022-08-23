/*
	fn_PlayerInTrigger.sqf

	Description:
		Determines if any player is in the area of given trigger

	[thisTrigger] call SAEF_PLYR_fnc_PlayerInTrigger;
*/

params
[
	"_trigger"
];

private
[
	"_playersInArea"
];

_playersInArea = ([] call RS_PLYR_fnc_GetTruePlayers) inAreaArray _trigger;

// Return any players in area
!(_playersInArea isEqualTo [])