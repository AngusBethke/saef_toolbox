/*
	fn_ForcefulPardon.sqf
	Description: Alters default rating return value so that players do not need to be pardoned
*/

if (!hasInterface) exitWith {};

player addEventHandler ["HandleRating", {0}];