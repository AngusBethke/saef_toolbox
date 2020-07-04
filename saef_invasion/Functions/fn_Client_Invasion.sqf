/* 
	fn_Client_Invasion.sqf.sqf
	
	Description: 
		Handles the clientside portion of the invasion process
		
	How to Call:
		[] spawn RS_INV_fnc_Client_Invasion;
		
	Called by:
		fn_Init_ServerInvasion.sqf
*/

// Kick any non-players out of this
if !(hasInterface) exitWith {};

// Wait until the invasion process has started
waitUntil {
	sleep 1;
	(missionNamespace getVariable ["RS_INV_Invasion_Started", false])
};

// Gracefully cover up the movement
[] spawn RS_INV_fnc_Client_Screen;
sleep 2.5;

// Move the player into the plane
["plane", player] call RS_INV_fnc_Client_MoveIn;

/*
	END
*/