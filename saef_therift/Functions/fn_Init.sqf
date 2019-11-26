/*
	fn_Init.sqf
	Description: Initialise
	Author: Angus Bethke a.k.a. Rabid Squirrel
*/

// SP Debug
if (hasInterface && isServer) then
{
	missionNamespace setVariable ["RS_Rift_RunRiftRadio", true, true];
	missionNamespace setVariable ["RS_Rift_RadioRunServerSync", true, true];
};

// Server
if (!hasInterface && isServer) then
{
	missionNamespace setVariable ["RS_Rift_RunRiftRadio", true, true];
	missionNamespace setVariable ["RS_Rift_RadioRunServerSync", true, true];
};

// Player
if (hasInterface) then
{
	player setVariable ["RS_Rift_RunRiftRadio", true, true];
	player setVariable ["RS_Rift_Snowfall_Run", true, true];
};	