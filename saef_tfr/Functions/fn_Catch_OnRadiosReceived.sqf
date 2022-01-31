/**
	@namespace RS_TFR
	@class TFR
	@method RS_TFR_fnc_Catch_OnRadiosReceived
	@file fn_Catch_OnRadiosReceived.sqf
	@summary Registers a new TFAR event handler to catch when the radio assignment has finished (this is so that we can override the radios if needed)

	@usage ```[] call RS_TFR_fnc_Catch_OnRadiosReceived;```
**/

/*
	fn_Catch_OnRadiosReceived.sqf
	
	Description:
		Registers a new TFAR event handler to catch when the radio assignment has finished (this is so that we can override the radios if needed)
		
	How to Call:
		[] call RS_TFR_fnc_Catch_OnRadiosReceived;
*/

if (!hasInterface) exitWith {};

if (!isNil "TFAR_fnc_addEventHandler") then
{
	["RS_Intercept_OnRadiosReceived", "OnRadiosReceived", {
		params ["_player","_radios"];
		
		// Log that it has happened
		[
			"RS_TFR_fnc_Catch_OnRadiosReceived", 
			0, 
			(format ["Player [%1] is finished processing their TFAR radio settings", _player])
		] call RS_fnc_LoggingHelper;
		
		// Set a variable to mark that this has been completed 
		// We should probably nil this once we've done whatever we need to do
		_player setVariable ["RS_TFR_RadiosReceived", true, true];
	}, player] call TFAR_fnc_addEventHandler;
};

/*
	END
*/