/*	
	Function: fn_InitDS.sqf
	Author: Angus Bethke
	Last Modified: 15-11-2019
	Description: Holds init declerations for Dyna Spawn.
*/

if !(isServer) exitWith {};

missionNamespace setVariable ["RS_DS_Debug", [true, "[Dyna Spawn Version [1.0]]"], true];