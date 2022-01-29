/**
	@namespace SAEF_Detection
	@class Detection
	@method SAEF_Detection_fnc_Burst
	@file fn_Burst.sqf
	@summary Handles burst detection - this occurs when a player fires their weapon
	
	@param unit _unit
	
	@note Original Author: Fritz
	@note Modified by: Angus Bethke
**/
/*
	fn_Burst.sqf
	Description: Handles burst detection - this occurs when a player fires their weapon
	Original Author: Fritz
	Modified by: Angus Bethke
	
	How to Call:
		[] spawn SAEF_Detection_fnc_Burst;
*/

missionNamespace setVariable ["SAEF_Burst_Over", false, false];	

// Make the player detectable
player setCaptive false;
player setVariable ["SAEF_Player_Detected", true, true];

if (player getVariable ["SAEF_Detection_Debug", false]) then
{
	hint "[SAEF] [Detection] You are detected";
};

sleep 60;

// Make the player hidden
player setCaptive true;
player setVariable ["SAEF_Player_Detected", false, true];

if (player getVariable ["SAEF_Detection_Debug", false]) then
{
	hint "[SAEF] [Detection] You are hidden";
};

missionNamespace setVariable ["SAEF_Burst_Over", true, false];		

/*
	END
*/