/**
	@namespace [?]
	@class [?]
	@file fn_AddEventHandlers.sqf
	@summary Adds event handler to player for Gear Restriction

	@note Not included in any Namespaces so may not be callable?

**/

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