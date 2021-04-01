# DynaSpawn

## CBA Settings
1. Add Units to Zeus (SAEF_DynaSpawn_AddToZeus) - whether or not to add spawned units to Zeus
2. Enable Dynamic Garrison (SAEF_DynaSpawn_DynamicGarrison) - whether or not to enable a unit level function that allows the AI to "un-garrison" when players are very close.
3. Enable Extended Logging (SAEF_DynaSpawn_ExtendedLogging) - enables extended logging, useful for debugging.

## Usage
- Creates an Infantry Patrol of 2 Soldiers at "Marker1" to Patrol a 50 Meter Perimeter around "Marker1", SIDE: West
```
// Using spawn
_group = createGroup [WEST, true];
["Marker1", "PAT", ["B_Soldier_F", "B_Soldier_F"], WEST, 50, "", false, [], _group] spawn DS_fnc_DynaSpawn;

// Using call
_group = ["Marker1", "PAT", ["B_Soldier_F", "B_Soldier_F"], WEST, 50] spawn DS_fnc_DynaSpawn;
```

- Creates an Infantry Squad of 4 Soldiers at "Marker1" to Garrison a 10 Meter Area around "Marker2", SIDE: West
```
// Using spawn
_group = createGroup [WEST, true];
["Marker1", "GAR", ["B_Soldier_F", "B_Soldier_F", "B_Soldier_F", "B_Soldier_F"], WEST, 10, "Marker2", false, [], _group] spawn DS_fnc_DynaSpawn;

// Using call
_group = ["Marker1", "GAR", ["B_Soldier_F", "B_Soldier_F", "B_Soldier_F", "B_Soldier_F"], WEST, 10, "Marker2"] spawn DS_fnc_DynaSpawn;
```

- Creates an Infantry Squad of 4 Soldiers at "Marker1" to Hunt the nearest Player in a 1km Area around them, SIDE: East
```
// Using spawn
_group = createGroup [EAST, true];
["Marker1", "HK", ["O_Soldier_F", "O_Soldier_F", "O_Soldier_F", "O_Soldier_F"], EAST, 1000, "", false, [], _group] spawn DS_fnc_DynaSpawn;

// Using call 
_group = ["Marker1", "HK", ["O_Soldier_F", "O_Soldier_F", "O_Soldier_F", "O_Soldier_F"], EAST, 1000] spawn DS_fnc_DynaSpawn;
```

## Parameters
- Spawn Position (String: Marker, Array: Position)

Passed Spawn Position, can be a Marker or a Position Array

- Type (String: Types defined below)

Type should be, Format: "PAT", "DEF", "CA", "HK", "NON" or "GAR"
```
PAT	= Patrol
DEF	= Defend
CA 	= Counter Attack
HK	= Hunter Killer
NON	= None
GAR	= Garrison
```

- Faction (String: Classname, Array: String classnames)

Faction should be a Custom Unit Array or Group Name, or Vehicle

- Faction Side (Side: https://community.bistudio.com/wiki/side)

Side of the Units you are spawning, Format: WEST, EAST, or INDEPENDENT
	
- Area of Operation (Integer: Max - 4000, Min - 5)

Define the area size in which the AI Defend, Patrol or Garrison
	
- Second Position (Optional - String: Marker, Array: Position)

Passed Secondary Position (Used by Counter Attack or Garrison)
	
- Remove Weapon Attachments (Optional - Boolean: true,false)

Removes WeaponAttachments from spawned unit's weapons

- Paraspawn (Optional - Array: Format as specified below)
```
[
	"_vehicle",	// The classname of the vehicle to spawn
	"_spawnPos",	// Position array (or [] if you'd like the spawn position to be auto-determined)
	"_azi"		// The direction for the vehicle to spawn facing (will be overridden if the supplied parameter is [])
]
```

- Group (Optional - Group: https://community.bistudio.com/wiki/group)	

You can pass the group in if you'd like to be able to call the function with spawn and still make changes to the group afterwards

- Give Handle (Optional - Boolean: true,false)

Request that the spawner script handle be passed back - will not have any effect in a "scheduled" environment, this will alter the return parameters using call from just the group to an array of group and script handle.
