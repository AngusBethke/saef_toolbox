# SAEF Loadouts Toolset
Adds a set of helper functions that are useful for creating loadouts, for practical usage see [this tutorial](https://youtu.be/EkO5hO07iVk) video.

## Functions
1. **Remove Existing Items** - this removes the existing items from a unit
```
[
	_unit				// The unit we're applying the loadout to
] call RS_LD_fnc_RemoveExistingItems;
```

2. **Add Gear Item** - this adds a gear item with optional randomisation pool usage
```
/*
	Types of Gear Items:
	- Uniform
	- Vest
	- Backpack
	- Goggles
	- Headgear
*/

[
	_unit,				// The unit to apply the gear item to
	"Uniform",			// The type of gear item
	"U_B_CTRG_Soldier_2_Arid_F",	// The classname of the item
	"Uniform"			// (Optional) The tag used to add to and source gear from the randomisation pool
] call RS_LD_fnc_AddGearItem;
```

3. **Standard Items** - this adds the standard items we use to your uniform
```
[
	_unit,				// The unit we're applying the loadout to
	false,				// (Optional) Whether or not to exclude the watch
	false,				// (Optional) Whether or not to exclude the map
	false,				// (Optional) Whether or not to exclude the compass
	false,				// (Optional) Whether or not to exclude the gps
	false				// (Optional) Whether or not to exclude the radio
] call RS_LD_fnc_StandardItems;
```

4. **Medical (Infantry)** - this adds the standard medical items to an infantryman
```
[
	_unit				// The unit we're applying the loadout to
] call RS_LD_fnc_MedicalInfantry;
```

5. **Medical (Medic)** - this adds the standard medical items to a medic
```
[
	_unit,				// The unit we're applying the loadout to
	false				// (Optional) Whether or not this is just a first aid slot (and not a full medic)
] call RS_LD_fnc_MedicalMedic;
```

6. **Try Add Items** - tries to add the specified number of items to the given inventory container, but reduces the number if necessary (logs appropriate messages when doing so)
```
/*
	Types of Containers:
	- Uniform
	- Vest
	- Backpack
*/

[
	  _unit,			// The unit to apply the gear item to 
	  "Backpack", 			// The type of container to add the gear items to
	  [
		    "ACE_packingBandage", 	// The item to add
		    20				// The number of items
	  ]
] call RS_LD_fnc_TryAddItems;
```

7. **Add Balanced Items** - takes the given items and tries to add them evenly into the inventory based on the given cap
```
[
	_unit,				// The unit to apply the gear item to
	"Vest",				// The type of container to add the gear items to
	[				// The items to add
	  	"30Rnd_65x39_caseless_black_mag", 
		"30Rnd_65x39_caseless_black_mag_Tracer"
	],
	8				// The max amount that can be added
] call RS_LD_fnc_AddBalancedItems;
```
