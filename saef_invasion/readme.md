### Invasion Toolkit
The purpose of this set of functions is to enable a WW2 centric Airborne drop with a couple of customisable features.

#### Below you will find an example script file for initialisation of the functions in your mission
```
/*
	Invasion_Start_Server.sqf
	
	Description: 
		Starts all scripts for the Invasion
		
	Note:
		This must be executed by the server
		
	To kick-off:
		missionNamespace setVariable ["Inv_Started", true, true];
*/

waitUntil{
	sleep 1; 
	(missionNamespace getVariable ["Inv_Started", false])
};

// Variable declerations - these are necessary for spawning the right things during the mission
_friendlyAI = missionNamespace getVariable ["RS_FriendlyUnits", []];
_friendlyAISide = missionNamespace getVariable ["RS_FriendlySide", INDEPENDENT];
_friendlyAISpawn = missionNamespace getVariable ["RS_FriendlySpawn", "fr_stage_spawn"];

missionNamespace setVariable ["RS_INV_DefaultFriendlyAI", _friendlyAI, true];	// Friendly AI that will be spawned
missionNamespace setVariable ["RS_INV_FriendlySide", _friendlyAISide, true];	// Friendly AI side
missionNamespace setVariable ["RS_INV_DefaultFriendlyAI_Spawn", _friendlyAISpawn, true];	// Default spawn marker for friendly AI

_enemyAISide = missionNamespace getVariable ["RS_EnemySide", WEST];

missionNamespace setVariable ["RS_INV_EnemySide", _enemyAISide, true];	// Enemy AI Side

// Planes
_planeSpawnPositionArray =
[
	[
		[((markerPos "airborne_start") select 0) - 1000, 	(((markerPos "airborne_start") select 1) + 50) - random(100), 	300],
		[((markerPos "airborne_end") select 0) - 1000, 		(((markerPos "airborne_end") select 1) + 50) - random(100), 	300],
		[((markerPos "airborne_drop") select 0) - 1000, 	(((markerPos "airborne_drop") select 1) - 500) - random(200), 	300],
		180
	],
	[
		[((markerPos "airborne_start") select 0) - 500, (((markerPos "airborne_start") select 1) + 50) - random(100), 	300],
		[((markerPos "airborne_end") select 0) - 500, 	(((markerPos "airborne_end") select 1) + 50) - random(100), 	300],
		[((markerPos "airborne_drop") select 0) - 500,	(((markerPos "airborne_drop") select 1) - 250) - random(200), 	300],
		180
	],
	[
		[((markerPos "airborne_start") select 0) + 50, 	(((markerPos "airborne_start") select 1) + 50) - random(100), 	300],
		[((markerPos "airborne_end") select 0) + 50, 		(((markerPos "airborne_end") select 1) + 50) - random(100), 	300],
		[((markerPos "airborne_drop") select 0) + 50, 	(((markerPos "airborne_drop") select 1) + 100) - random(200), 	300],
		180
	],
	[
		[((markerPos "airborne_start") select 0) + 500, (((markerPos "airborne_start") select 1) + 50) - random(100), 	300],
		[((markerPos "airborne_end") select 0) + 500, 	(((markerPos "airborne_end") select 1) + 50) - random(100), 	300],
		[((markerPos "airborne_drop") select 0) + 500, 	(((markerPos "airborne_drop") select 1) - 250) - random(200), 	300],
		180
	],
	[
		[((markerPos "airborne_start") select 0) + 1000, 	(((markerPos "airborne_start") select 1) + 50) - random(100), 	300],
		[((markerPos "airborne_end") select 0) + 1000, 		(((markerPos "airborne_end") select 1) + 50) - random(100), 	300],
		[((markerPos "airborne_drop") select 0) + 1000, 	(((markerPos "airborne_drop") select 1) - 500) - random(200), 	300],
		180
	]
];

missionNamespace setVariable ["RS_INV_JumpPlaneClassname", "LIB_C47_Skytrain", true];	// Classname for the drop plan
missionNamespace setVariable ["RS_INV_PlaneSeatCount", 4, true];	// Number of seats for players in each plane
missionNamespace setVariable ["RS_INV_PlaneSpawnPositionArray", _planeSpawnPositionArray, true];	// Spawn positions for the player planes
missionNamespace setVariable ["RS_INV_AmbientAirDrop_Start", "airborne_start", true];	// Start marker for ambient air drops
missionNamespace setVariable ["RS_INV_AmbientAirDrop_End", "airborne_end", true];	// End marker for ambient air drops
missionNamespace setVariable ["RS_INV_AmbientAirDrop_Drop", "airborne_drop", true];	// Drop marker for ambient air drops

// Client Stuff
missionNamespace setVariable ["RS_INV_Flak_Run", true, true];	// Whether or not to include flak for the jump
missionNamespace setVariable ["RS_INV_MisDropItems_Run", true, true];	// Whether or not to drop an item for the added "misdrop" effect
missionNamespace setVariable ["RS_INV_Client_Screen_Text", "June 6th, 1944", true];	// Flavor text to cover movement between spawn and the planes

// The AA Guns
_gunArray = 
[
	[(markerPos "AntiAirGun_Spawn_1"), (markerDir "AntiAirGun_Spawn_1"), "LIB_FlaK_30"],
	[(markerPos "AntiAirGun_Spawn_2"), (markerDir "AntiAirGun_Spawn_2"), "LIB_FlaK_38"],
	[(markerPos "AntiAirGun_Spawn_3"), (markerDir "AntiAirGun_Spawn_3"), "LIB_FlaK_30"],
	[(markerPos "AntiAirGun_Spawn_4"), (markerDir "AntiAirGun_Spawn_4"), "LIB_FlaK_38"],
	[(markerPos "SpotLight_Spawn_1"), (markerDir "SpotLight_Spawn_1"), "LIB_GER_SearchLight", false],
	[(markerPos "SpotLight_Spawn_2"), (markerDir "SpotLight_Spawn_2"), "LIB_GER_SearchLight", false],
	[(markerPos "SpotLight_Spawn_3"), (markerDir "SpotLight_Spawn_3"), "LIB_GER_SearchLight", false],
	[(markerPos "SpotLight_Spawn_4"), (markerDir "SpotLight_Spawn_4"), "LIB_GER_SearchLight", false]
];

_gunFireVariable = "RS_MissionPhase";

// Run the Ambient Airdrop and other misc scripts
if (!(isNil "HC2")) then
{
	// Try run on the 2nd headless client if it's there
	[[8, _gunFireVariable], "RS_INV_fnc_Server_AmbientAirDrop", "spawn", "HC2"] call RS_fnc_ExecScriptHandler;
	[[_gunArray, _gunFireVariable], "RS_INV_fnc_Server_AAGuns", "spawn", "HC2"] call RS_fnc_ExecScriptHandler;
}
else
{
	// Otherwise run on the 1st headless client or the server
	[[8, _gunFireVariable], "RS_INV_fnc_Server_AmbientAirDrop"] call RS_fnc_ExecScriptHandler;
	[[_gunArray, _gunFireVariable], "RS_INV_fnc_Server_AAGuns"] call RS_fnc_ExecScriptHandler;
};

// Wait a second for the other stuff to spawn
sleep 5;

// Kick off the invasion
[] spawn RS_INV_fnc_Server_Invasion;

sleep 30;

// Run second Ambient Airdrop
if (!(isNil "HC2")) then
{
	// Try run on the 2nd headless client if it's there
	[[8, _gunFireVariable], "RS_INV_fnc_Server_AmbientAirDrop", "spawn", "HC2"] call RS_fnc_ExecScriptHandler;
}
else
{
	// Otherwise run on the 1st headless client or the server
	[[8, _gunFireVariable], "RS_INV_fnc_Server_AmbientAirDrop"] call RS_fnc_ExecScriptHandler;
};

/*
	END
*/

/*
	Invasion_Start_Client.sqf
	
	Description: 
		Starts all scripts for the Invasion
		
	Note:
		This must be executed by the client
		
	To kick-off:
		missionNamespace setVariable ["Inv_Started", true, true];
*/

waitUntil{
	sleep 1; 
	(missionNamespace getVariable ["Inv_Started", false])
};

// Add drop actions to some objects
_objects = ["invasion_airdrop_radio_1"];
{
	if (!isNil _x) then
	{
		[(call compile _x)] call RS_INV_fnc_Client_AddDropAction;
	};
} forEach _objects;

// The server initialised kick-off for the clients
[] spawn RS_INV_fnc_Client_Invasion;

/*
	END
*/
```