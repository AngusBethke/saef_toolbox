/**
	@namespace RS_ST
	@class StatTrack
	@method RS_ST_fnc_LogOnEnd
	@file fn_LogOnEnd.sqf
	@summary Event Handler for Logging StatTrack information onMissionEnd

**/


/*
	fn_LogOnEnd.sqf
	Description: Event Handler for Logging StatTrack information onMissionEnd
	Author: Angus Bethke (a.k.a. Rabid Squirrel)
*/

_endHandler = addMissionEventHandler ["Ended",{ [] call RS_ST_fnc_LogInfo }];

/*
	END
*/