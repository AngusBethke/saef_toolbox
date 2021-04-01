# SAEF Automated Spawning
This toolset provides a set of modules and functions that can be used to handle AI processing in a structured multi-headless environment. For a comprehensive look at the modules and how they function you can use [this](https://youtu.be/e4E91dtoe9U) tutorial video. When it comes to utilising this toolset via scripting please see the below.

## CBA Settings
1. Hint Information to Zeus (SAEF_AutomatedSpawning_ZeusHint) - hints information about spawns to Zeus, but can also be annoying when used outside of a debug environment.
2. Enable Extended Logging (SAEF_AutomatedSpawning_ExtendedLogging) - enables extended logging for automated spawning, useful for debugging.

## Setup
### Markers
Markers will need to be placed using the tag that corresponds to the below specified configuration. These markers will also need the location size tag in order to be consumed correctly. Using the below configuration, we can place "empty" markers down with the following variable names: 
1. rus_area_sml_1 - Will create a small area for the configuration that matches the "rus_area" tag.
2. rus_area_med_1 - Will create a medium area for the configuration that matches the "rus_area" tag.
3. rus_area_lrg_1 - Will create a large area for the configuration that matches the "rus_area" tag.
This will generate this sites and the required handlers, and is all that needs to be done (in mission) for the spawn system to work.

### Required Configuration
Configuration is required for the automated spawn system, if you follow the above linked tutorial you will find that the following configuration can be exported, which is arguably easier, however this can be hand written and will still work fine. This configuration must be executed in server locality, in other words from "initServer.sqf" or similar.
```
// ----- Exported SAEF Spawn Area Configuration Information ----- // 
private 
[
	"_areaTags",
	"_var_rus_area_config",
	"_var_rus_area_units",
	"_var_rus_area_side",
	"_var_rus_area_lightvehicles",
	"_var_rus_area_heavyvehicles",
	"_var_rus_area_paravehicles"
];

// Tag Config 
_areaTags = 
[
	[
		"rus_area",		// The tag for the area
		"Russian Forces",	// Descriptive name for the tag (used by the Zeus modules)
		"rus_area_config"	// The config variable pointer for this tag
		,[			// The overrides array
			[
				"rus_area_sml_3"		// Marker that is being overwritten
				,"rus_area_sml_3_config"	// The config pointer for this marker override
			]
		]
	]
];

missionNamespace setVariable ["SAEF_AreaMarkerTags", _areaTags, true];

// Russian Forces Area Config 
_var_rus_area_config = 
[
	false,                          // Block the Patrol Portion of the Area
	false,                          // Block the Garrison Portion of the Area
	"rus_area_units",               // Variable pointer to array of units for spawning
	"rus_area_side",                // Variable pointer to side of units for spawning
	"rus_area_lightvehicles",       // Variable pointer to array of light vehicles for spawning
	"rus_area_heavyvehicles",       // Variable pointer to array of heavy vehicles for spawning
	"rus_area_paravehicles",        // Variable pointer to array of paradrop vehicles for spawning
	{                               // Optional: Code block for extra validation passed to GetClosestPlayer
		params
		[
			"_player"
		];
		
		_condition = ((getPosATL _player) select 2) < 250;
		
		// Return value
		_condition
	},
	[],                             // Optional: Array of scripts run against the spawned group
	{true},                         // Optional: Code block for extra validation passed to the Message Queue
	true                            // Optional: Whether or not to include the default ending detector
];
missionNamespace setVariable ["rus_area_config", _var_rus_area_config, true];

// rus_area_sml_3 Area Config 
_var_rus_area_sml_3_config = 
[
	true,                           // Block the Patrol Portion of the Area
	false,                          // Block the Garrison Portion of the Area
	"rus_area_units",               // Variable pointer to array of units for spawning
	"rus_area_side",                // Variable pointer to side of units for spawning
	"rus_area_lightvehicles",       // Variable pointer to array of light vehicles for spawning
	"rus_area_heavyvehicles",       // Variable pointer to array of heavy vehicles for spawning
	"rus_area_paravehicles",        // Variable pointer to array of paradrop vehicles for spawning
	{                               // Optional: Code block for extra validation passed to GetClosestPlayer
		params
		[
			"_player"
		];
		
		_condition = ((getPosATL _player) select 2) < 250;
		
		// Return value
		_condition
	},
	[],                             // Optional: Array of scripts run against the spawned group
	{true},                         // Optional: Code block for extra validation passed to the Message Queue
	true                            // Optional: Whether or not to include the default ending detector
];
missionNamespace setVariable ["rus_area_sml_3_config", _var_rus_area_sml_3_config, true];

// Russian Forces rus_area_units Config 
_var_rus_area_units = 
[
	"rhs_vdv_sergeant",
	"rhs_vdv_efreitor",
	"rhs_vdv_arifleman",
	"rhs_vdv_machinegunner_assistant",
	"rhs_vdv_LAT",
	"rhs_vdv_grenadier",
	"rhs_vdv_marksman",
	"rhs_vdv_medic",
	"rhs_vdv_engineer",
	"rhs_vdv_grenadier_rpg",
	"rhs_vdv_at"
];
missionNamespace setVariable ["rus_area_units", _var_rus_area_units, true];

// Russian Forces rus_area_side Config 
_var_rus_area_side = EAST;
missionNamespace setVariable ["rus_area_side", _var_rus_area_side, true];

// Russian Forces rus_area_lightvehicles Config 
_var_rus_area_lightvehicles = 
[
	"rhs_tigr_sts_3camo_vdv",
	"rhs_tigr_sts_vdv",
	"rhsgref_BRDM2_HQ_vdv",
	"rhsgref_BRDM2_vdv",
	"rhs_btr60_vdv"
];
missionNamespace setVariable ["rus_area_lightvehicles", _var_rus_area_lightvehicles, true];

// Russian Forces rus_area_heavyvehicles Config 
_var_rus_area_heavyvehicles = 
[
	"rhs_btr80a_vdv",
	"rhs_bmd4ma_vdv",
	"rhs_bmp2k_vdv",
	"rhs_sprut_vdv",
	"rhs_t72be_tv",
	"rhs_t90sab_tv"
];
missionNamespace setVariable ["rus_area_heavyvehicles", _var_rus_area_heavyvehicles, true];

// Russian Forces rus_area_paravehicles Config 
_var_rus_area_paravehicles = 
[
	"RHS_Mi8T_vdv"
];
missionNamespace setVariable ["rus_area_paravehicles", _var_rus_area_paravehicles, true];

// ----- End of Exported SAEF Spawn Area Configuration Information ----- //
```

### Optional Configuration
This optional configuration allows you to override the base parameters for the automated spawn system, this is more of a "super user" tool, but can be used if you need to alter certain parameters like the base activation range if you're operating in a dense urban environment.
```
private
[
  "_var_SAEF_AreaSpawner_MaxActivationRange",
  "_var_SAEF_AreaSpawner_Large_Params",
  "_var_SAEF_AreaSpawner_Large_BlockPatrol",
  "_var_SAEF_AreaSpawner_Large_BlockGarrison",
  "_var_SAEF_AreaSpawner_Medium_Params",
  "_var_SAEF_AreaSpawner_Medium_BlockPatrol",
  "_var_SAEF_AreaSpawner_Medium_BlockGarrison",
  "_var_SAEF_AreaSpawner_Small_Params",
  "_var_SAEF_AreaSpawner_Small_BlockPatrol",
  "_var_SAEF_AreaSpawner_Small_BlockGarrison"
];

_var_SAEF_AreaSpawner_MaxActivationRange = 800;
missionNamespace setVariable ["SAEF_AreaSpawner_MaxActivationRange", _var_SAEF_AreaSpawner_MaxActivationRange, true];

_var_SAEF_AreaSpawner_Large_Params =
[
	 12		// Base AI Count
	,60		// Base Area Size
	,175		// Base Activation Range
];
missionNamespace setVariable ["SAEF_AreaSpawner_Large_Params", _var_SAEF_AreaSpawner_Large_Params, true];

_var_SAEF_AreaSpawner_Large_BlockPatrol = true;
missionNamespace setVariable ["SAEF_AreaSpawner_Large_BlockPatrol", _var_SAEF_AreaSpawner_Large_BlockPatrol, true];

_var_SAEF_AreaSpawner_Large_BlockGarrison = false;
missionNamespace setVariable ["SAEF_AreaSpawner_Large_BlockGarrison", _var_SAEF_AreaSpawner_Large_BlockGarrison, true];

_var_SAEF_AreaSpawner_Medium_Params =
[
	 6		// Base AI Count
	,50		// Base Area Size
	,175		// Base Activation Range
];
missionNamespace setVariable ["SAEF_AreaSpawner_Medium_Params", _var_SAEF_AreaSpawner_Medium_Params, true];

_var_SAEF_AreaSpawner_Medium_BlockPatrol = true;
missionNamespace setVariable ["SAEF_AreaSpawner_Medium_BlockPatrol", _var_SAEF_AreaSpawner_Medium_BlockPatrol, true];

_var_SAEF_AreaSpawner_Medium_BlockGarrison = false;
missionNamespace setVariable ["SAEF_AreaSpawner_Medium_BlockGarrison", _var_SAEF_AreaSpawner_Medium_BlockGarrison, true];

_var_SAEF_AreaSpawner_Small_Params =
[
	 4		// Base AI Count
	,40		// Base Area Size
	,175		// Base Activation Range
];
missionNamespace setVariable ["SAEF_AreaSpawner_Small_Params", _var_SAEF_AreaSpawner_Small_Params, true];

_var_SAEF_AreaSpawner_Small_BlockPatrol = true;
missionNamespace setVariable ["SAEF_AreaSpawner_Small_BlockPatrol", _var_SAEF_AreaSpawner_Small_BlockPatrol, true];

_var_SAEF_AreaSpawner_Small_BlockGarrison = false;
missionNamespace setVariable ["SAEF_AreaSpawner_Small_BlockGarrison", _var_SAEF_AreaSpawner_Small_BlockGarrison, true];
```
