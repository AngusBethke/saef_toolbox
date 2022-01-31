/**
	@namespace SAEF_Detection
	@class Detection
	@method SAEF_Detection_fnc_EventHandler
	@file fn_Burst.sqf
	@summary Initialises the Event Handler for Detection
	
	@param side _detSide The side(s) of those you want to detect you
	@param ?bool _envIflc Whether or not the environment influences detection (optional)
	@param ?int _standVar The standing radius of detection (optional)
	@param ?int _crouchVar The crouching radius of detection (optional)
	@param ?int _proneVar The proning radius of detection (optional)
	@param ?code _condition Code Code that can be used to interrupt processing

	@note Original Author: Fritz
	@note Modified by: Angus Bethke
**/
/*
	fn_EventHandler.sqf
	Description: Initialises the Event Handler for Detection
	Original Author: Fritz
	Modified by: Angus Bethke
	
	How to Call:
		[
			[EAST],	// The side(s) of those you want to detect you
			true,	// Whether or not the environment influences detection (optional)
			30,		// The standing radius of detection (optional)
			10,		// The crouching radius of detection (optional)
			2,		// The proning radius of detection (optional)
			{true}	// Code that can be used to interrupt processing
		] call SAEF_Detection_fnc_EventHandler;
*/

params
[
	"_detSide"
	,["_envIflc", false]
	,["_standVar", 30]
	,["_crouchVar", 10]
	,["_proneVar", 2]
	,["_conditionCode", {true}]
];

// A variable only visible to the computer it has been defined on
conditionCode = _conditionCode;

// If the player fires their weapon, we need to force their detection
player addEventHandler [
	"fired", 
	{
		_conditionCode = conditionCode;
		if (player getVariable ["SAEF_Detection_Run", false]) then
		{
			_check = [player] call _conditionCode;
			if (_check) then
			{
				if (player getVariable ["SAEF_Burst_Over", true]) then 
				{
					[] spawn SAEF_Detection_fnc_Burst;
				};
			};
		};
	}
];

/*
	END
*/