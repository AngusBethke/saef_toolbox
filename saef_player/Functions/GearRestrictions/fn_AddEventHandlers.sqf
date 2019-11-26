/*
	Function Set: GearRestriction
	fn_AddEventHandlers.sqf
	Description: Adds event handler to player for Gear Restriction
	Author: Angus Bethke (a.k.a Rabid Squirrel)
*/

player addEventHandler ["take", 
{
	[] call RS_GR_fnc_RestrictionHandler;
}];