/*
	fn_EventHandler.sqf
	Description: Initialises the Event Handler for Detection
	Original Author: Fritz
	Modified by: Angus Bethke
	
	How to Call:
		[] call SAEF_Detection_fnc_EventHandler;
*/

// If the player fires their weapon, we need to force their detection
player addEventHandler [
	"fired", 
	{
		if (player getVariable ["SAEF_Detection_Run", false]) then
		{
			if (player getVariable ["SAEF_Burst_Over", true]) then 
			{
				[] spawn SAEF_Detection_fnc_Burst;
			};
		};
	}
];

/*
	END
*/