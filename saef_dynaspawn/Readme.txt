/*	
	Functions: 
		fn_DynaSpawn.sqf, 
		fn_SpawnerGroup.sqf, 
		fn_HunterKiller.sqf, 
		fn_InitDS.sqf, 
		fn_UnitValidation.sqf, 
		fn_PositionValidation.sqf, 
		fn_Garrison.sqf,
		fn_ParaInsertion.sqf
	Author: Angus Bethke
	Version: 1.0
	Required Mod(s): CBA
	Last Modified: 01-11-2019							
*/

==============
 INSTALLATION
==============

1. Copy "DynaSpawn" Folder to "Toolbox" Directory
2. In your mission's 'description.ext' file, paste this line of code:
	class CfgFunctions
	{
		#include "Toolbox\DynaSpawn\_Functions.hpp"
	};
3. Installation Complete

=============
 INFORMATION
=============
This Function grabs variables from the declaration 
		
What Each Variable Does:
------------------------
Variable 1		-- Pass a position, can be an Array or a marker										
	Format: [x, y, z] or "mark1" - Array or Marker Name
	
Variable 2		-- Type string should be here														
	Format: "PAT", "DEF", "CA", "HK", "NON" or "GAR" - String
	
Variable 3		-- Units should be here																
	Format: "Vehicle Classname" or ["Unit_Classname_1", "Unit_Classname_2"] - Classname or Array of Classnames
	
Variable 4		-- Side of the Units you are spawning.												
	Format: WEST, EAST, or INDEPENDENT - Side
	
Variable 5		-- Define the Area in Which the AI Patrol, Defend, Hunt for Players, or Garrison	
	Format: 50 (Max 4000) - Integer
	
Variable 6		-- Define the Second Position that is used if 'Type' is set to "CA", or "GAR"		
	Format: [x, y, z] or "mark2" - Array or Marker Name
	
Variable 7		-- Boolean Value, Removes Weapon Attachments from spawned unit's weapons.			
	Format: true, false - Boolean
	
Variable 8		-- Parachute Insertion array [vehicle, spawn position, direction]					
	Format: ["vehicle", [0,0,0], 0] - Array (Optional and you may supply an empty array)
	
Variable 9		-- Group may be created outside of dyna spawn and passed in							
	Format: Group object (an A3 group).

Additional Variable Information:
--------------------------------
Variable 2
PAT	= Patrol
DEF	= Defend
CA 	= Counter Attack
HK	= Hunter Killer
NON	= None
GAR	= Garrison

!-- IMPORTANT NOTE: Text is not Case Sensitive, but the Marker Names are --!

Examples:
---------

Creates an Infantry Patrol of 2 Soldiers to Patrol a 50 Meter Perimeter around the Marker, SIDE: West
	_group = createGroup [WEST, true];
	["Marker1", "PAT", ["B_Soldier_F", "B_Soldier_F"], WEST, 50, "", false, [], _group] spawn DS_fnc_DynaSpawn;
	
Creates an Infantry Squad of 4 Soldiers to Garrison a 10 Meter Area around the Marker, SIDE: West
	_group = createGroup [WEST, true];
	["Marker1", "GAR", ["B_Soldier_F", "B_Soldier_F", "B_Soldier_F", "B_Soldier_F"], WEST, 10, "Marker2", false, [], _group] spawn DS_fnc_DynaSpawn;
	
Creates an Infantry Squad of 4 Soldiers to Hunt the nearest Player in a 1km Area around them, SIDE: East
	_group = createGroup [EAST, true];
	["Marker1", "HK", ["O_Soldier_F", "O_Soldier_F", "O_Soldier_F", "O_Soldier_F"], EAST, 1000, "", false, [], _group] spawn DS_fnc_DynaSpawn;

===========
 CHANGELOG
===========

Changelog v1.0
--------------------
Changed: Shifted DynaSpawn into the toolbox, changed function directory and how it's initialised
Changed: Primary function to allow for the function to be called with "spawn" while still allowing control over the group (you will need to create the group and pass it in). This should improve performance on each function call
Added: Parachute Insertion
Removed: Ability to supply a group classname for spawns

Changelog Beta v0.95
--------------------
Bug Fix: Fixed Error thrown when Vehicles were spawned due to missing spawn direction

Changelog Beta v0.9
--------------------
Changed: Refactored Garrison Spawn Script, should mostly stop enemies being garrisoned on top of one another
Changed: Logging Strings for better Readability
Added: DynaSpawnFunctions.hpp file for easy installation

Changelog Beta v0.8
--------------------
Changed: Full Function Restructure, Legacy Support for Faction Arrays has been removed.
Added: Garrison Function

Changelog Beta v0.5
--------------------
Added: HunterKiller Function - Spawned AI will Hunt Down the Nearest Player within a radius until they Die, or they lose the Player.
Added: AAF Vehicles
Added: US and USMC Faction and Vehicles to the Spawn Options

Changelog Alpha v0.4
--------------------
Changed: Converted to a Function - Should improve performance
Changed: Remove Weapon Attachments - Now Removes Handgun Attachments as Well

Changelog Alpha v0.3
--------------------
Added: Building Blocks for US and USMC Factions
Changed: Script Refinements - Removal of Dependencies of External Scripts for Thermal and Weapon Attachments

Changelog Alpha v0.2
--------------------
Added: Guerilla Factions
Changed: Script Refinements

Changelog Alpha v0.1
--------------------
Initial Release - First Movement from InfantrySpawner.sqf to a more Refined Script