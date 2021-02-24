#SAEF Civilian Presence
##CBA Settings
SAEF Civilian presence has been updated to use CBA settings to function. These settings influence how Civilian presence initialises and can be useful in customising Civilian Presence to your needs.

###The settings 
(It is recommended you force these by default - they will be forced automatically by the export process):

- Debug Mode
```
force SAEF_CivilianPresence_Debug = true;
```
Debug mode creates a visual representation of the created areas on the map and displays 3d visual markers of AI and their respective waypoints, it is particularly useful when creating custom locations and tuning them to your specifications.

- Enabled
```
force SAEF_CivilianPresence_Enabled = true;
```
This determines whether or not civilian presence is enabled at all, by default this is false, so that it is not initialised unless the mission maker choose to use it.

- Use Agents
```
force SAEF_CivilianPresence_UseAgents = false;
```
This will create the civilians as agents (https://community.bistudio.com/wiki/createAgent) instead of units.

- Use Panic Mode
```
force SAEF_CivilianPresence_UsePanicMode = true;
```
This will switch up the AI animations when they are in threatening situations to make it seem like they are fleeing for their lives instead of jogging.

- Execution Locality
```
force SAEF_CivilianPresence_ExecutionLocality = "HC1";
```
This is a nifty tool, it allows you to specify on which instance of Arma (in a dedicated environment) you would like Civilian Presence to operate on. For those who use multiple headless clients with the ACEX naming convention, you will be able to mark on which client you want the civilians to run on to better overall performance. You can also specify the server if you so wish. Just note this will fallback to the server if the specified headless client is not currently running.

- Maximum AI per Location
```
force SAEF_CivilianPresence_MaxUnitCount = 24;
```
This defines the maximum amount of AI that can be spawned at any defined location, the system will cap this by itself if there are less buildings than this defined number.

- Maximum Total AI
```
force SAEF_CivilianPresence_MaxTotalUnitCount = 48;
```
This defines how many total concurrent running civilian presence AI there can be, it is effectively a cap, so that if multiple areas are triggered at the same time, the client running the AI is not swamped.

- Supported Location Types
```
force SAEF_CivilianPresence_SupportedLocationTypes_String = "NameCity,NameCityCapital,NameVillage";
```
These are the location types (https://community.bistudio.com/wiki/Location#Location_Types) supported by civilian presence, note the limitation here is that only these for types are supported: NameCity, NameCityCapital, NameVillage, and NameLocal. However you can filter and chop/change through these 4 as you like.

- Custom Locations
```
force SAEF_CivilianPresence_CustomLocations = "[['Highway 10',['NameVillage',[6270.4,15114,0],1000,1000],[]],['Highway 9',['NameVillage',[5199.07,14481.9,0],1000,1000],[]]]";
```
Custom locations can be useful in helping you define locations in an other wise empty area, specifically if you had built something directly in 3DEN and need it to be populated by Civilian Presence. The format is given below:
```
[
    [
        'Highway 10',                                           // The name of the location  
        [                                                       // Location array (https://community.bistudio.com/wiki/createLocation)
            'NameVillage',                                      // Location Type
            [6270.4,15114,0],                                   // Location Position
            1000,                                               // Size X
            1000                                                // Size Y
        ],
        [                                                       // Custom Location Variables - these can be ommitted for custom locations that utilise map assets (non-custom placed)
            ["SAEF_CivilianPresence_MaxUnitCount", 20],         // Max AI that can be spawned at that location
            ["SAEF_CivilianPresence_CustomSpawnPositions", [    // Custom positions for spawns (this is required by custom objects are not loaded yet in the pre-initialisation stage)
                    [6254.79,15050.5,3.87992]                   // It is recommended that the number of custom spawn locations match your max unit count
                ]
            ]
        ]
    ]
]
```

- Whitelisted Locations
```
force SAEF_CivilianPresence_Whitelist = "[[6270.4,15114,0],[5199.07,14481.9,0]]";
```
These are locations that will be whitelisted, this overwrites the default auto-population functionality and will instead force population areas to only those whitelisted areas. It chooses the nearest location to the point specified.

- Unit Types
```
force SAEF_CivilianPresence_UnitTypes_String = "C_Man_casual_1_F_afro,C_Man_casual_2_F_afro";
```
These are the unit types that Civilian presence will use when spawning civilians, you can alter this by fetching the classnames of the civilians you would like to spawn. It will fallback to the default world types if none are specified.