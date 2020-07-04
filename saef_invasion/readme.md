### Invasion Toolkit
The purpose of this set of functions is to enable a WW2 centric Airborne drop with a couple of customisable features.

#### Below you will find an example script file for initialisation of the functions in your mission
```
/*
	Invasion_Start.sqf
	
	Description: 
		Starts all scripts for the Invasion
*/

waitUntil{
	sleep 1; 
	(missionNamespace getVariable ["Inv_Started", false])
};

// Server side scripts
if (isServer) then
{
	// Variable declerations - these are necessary for spawning the right things during the mission
	_friendlyAI = missionNamespace getVariable ["RS_FriendlyAI", []];
	_friendlyAISide = missionNamespace getVariable ["RS_FriendlySide", INDEPENDENT];
	_friendlyAISpawn = missionNamespace getVariable ["RS_SupportSpawn", ""];
	
	missionNamespace setVariable ["RS_INV_DefaultFriendlyAI", _friendlyAI, true];	// Friendly AI that will be spawned
	missionNamespace setVariable ["RS_INV_FriendlySide", _friendlyAISide, true];	// Friendly AI side
	missionNamespace setVariable ["RS_INV_DefaultFriendlyAI_Spawn", _friendlyAISpawn, true];	// Default spawn marker for friendly AI
	
	_enemyAISide = missionNamespace getVariable ["RS_EnemySide", WEST];
	
	missionNamespace getVariable ["RS_INV_EnemySide", _enemyAISide, true];	// Enemy AI Side
	
	// Planes
	missionNamespace setVariable ["RS_INV_JumpPlaneClassname", "LIB_C47_Skytrain", true];	// Classname for the drop plan
	missionNamespace setVariable ["RS_INV_PlaneSeatCount", 4, true];	// Number of seats for players in each plane
	missionNamespace setVariable ["RS_INV_PlaneSpawnPositionArray", [], true];	// Spawn positions for the player planes
	missionNamespace setVariable ["RS_INV_AmbientAirDrop_Start", "", true];	// Start marker for ambient air drops
	missionNamespace setVariable ["RS_INV_AmbientAirDrop_End", "", true];	// End marker for ambient air drops
	missionNamespace setVariable ["RS_INV_AmbientAirDrop_Drop", "", true];	// Drop marker for ambient air drops
	
	// Client Stuff
	missionNamespace setVariable ["RS_INV_Flak_Run", true, true];	// Whether or not to include flak for the jump
	missionNamespace setVariable ["RS_INV_MisDropItems_Run", true, true];	// Whether or not to drop an item for the added "misdrop" effect
	missionNamespace setVariable ["RS_INV_Client_Screen_Text", "June 6th, 1944", true];	// Flavor text to cover movement between spawn and the planes

	// The AA Guns
	_gunArray = 
	[
		[(markerPos "AntiAirGun_Spawn_1"), "<CLASSNAME>"],
		[(markerPos "AntiAirGun_Spawn_2"), "<CLASSNAME>"],
		[(markerPos "AntiAirGun_Spawn_3"), "<CLASSNAME>"],
		[(markerPos "AntiAirGun_Spawn_4"), "<CLASSNAME>"]
	];
	
	_gunFireVariable = "RS_MissionPhase";
	
	// Kick off the invasion
	[] call RS_INV_fnc_Server_Invasion;
	
	// Run the Ambient Airdrop and other misc scripts
	if (!(isNil "HC2")) then
	{
		// Try run on the 2nd headless client if it's there
		[[], "RS_INV_fnc_Server_AmbientAirDrop", "spawn", "HC2"] call RS_fnc_ExecScriptHandler;
		[[_gunPositionArray, _gunFireVariable], "RS_INV_fnc_Server_AAGuns", "spawn", "HC2"] call RS_fnc_ExecScriptHandler;
	}
	else
	{
		// Otherwise run on the 1st headless client or the server
		[[], "RS_INV_fnc_Server_AmbientAirDrop"] call RS_fnc_ExecScriptHandler;
		[[_gunPositionArray, _gunFireVariable], "RS_INV_fnc_Server_AAGuns"] call RS_fnc_ExecScriptHandler;
	};
};

// Client side scripts
if (hasInterface) then
{
	// Add drop actions to some objects
	_objects = [];
	{
		[_x] call RS_INV_fnc_Client_AddDropAction;
	} forEach _objects;
	
	// The server initialised kick-off for the clients
	[] spawn RS_INV_fnc_Client_Invasion;
};

/*
	END
*/
```