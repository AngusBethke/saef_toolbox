# Respawn Handlers
## Wave Respawn
```
_classSpecificPenalties =
[
	[
		"B_medic_F",		// The class to apply the penalty to
		0.5			// The penalty factor 1 = 100%, 0.5 = 50%, 2 = 200% etc
	]
];

[
	300,					// Optional: The minimum time for respawn
	1200,					// Optional: The maximum time for respawn
	30,					// Optional: The time the respawn is held open for
	5,					// Optional: The amount of players required to force the respawn
	30,					// Optional: The base penalty time applied to players for dying
	_classSpecificPenalties			// Optional: An array with penalty indicators to multiply penalties for certain classes
] call RS_fnc_Handler_WaveRespawn;
```

Effectively the way it works is there is a base respawn time (in this case 300 seconds / 5 minutes) which is an input variable, it serves as the baseline for the amount of time you can spend in spectator (without the required amount of players for a wave respawn). There is a max time (in this case it is 1200 seconds / 20 minutes and is only relevant in the case of penalties). Hold time (in this case 30 seconds) which is how long the spawn stays open for when triggered. The player limit (in this case 5) this is how many dead players are required to circumvent the minimum respawn time. The penalty time (in this case 30 seconds) this is the penalty applied to players for dying, this stacks on top of the base respawn time and cannot be circumvented (i.e. if 5 players die, and there is a penalty time set, then they will have to wait out that penalty time before they are able to respawn). Lastly an array with class specific penalties, here you can increase the penalty factor for specific classes (i.e. if a medic dies, it will apply a multiplier to his penalty to increase the penalty time), in the example above if the medic dies his penalty time will be 45 seconds instead of just 30 seconds that gets added to the overall penalty. This means that if more people die, the wait time will be longer (if you choose to apply a penalty for death). You can set the penalty to 0 if you would like to turn that off and simply utilise the wave functionality as it stands.

## Timed Respawn
```
[
	600,		// Optional: The time between respawn waves
	30		// Optional: The time the respawn is held open for
] call RS_fnc_Handler_TimedRespawn;
```

This is your standard time based respawn mechanism, it has no special mechanism, simply opens the respawn after the provided timeout.

## Admin Functions 
(Available via the ACE Self Interaction Menu)

You are now able to forcefully respawn individual players from the ace admin menu, this is useful if someone gets arma'd or you want to let a late joiner in without impacting the rest of the spawning system.
You are able to view respawn information via that menu as well, and if you are using the built in handlers (wave respawn and timed respawn), it will tell you how much time is left until the respawn will be active again.

(Local Debug Helper)
```
[] call RS_fnc_ForceRespawnSelf;
```
Will force respawn just you as an individual, which can be useful if you need to access Zeus or admin tools or something and you don't want to respawn everyone.

# Respawn Parameters
## Spectator Configuration
```
_var_SAEF_Respawn_InitDelay = 10;
_var_SAEF_Respawn_SpectatorParams = 
[
	[], 	// Sides that can be spectated (empty is all)
	false,	// Whether AI can be viewed by the spectator
	false,	// Allow free camera
	false,	// Allow 3rd person camera
	true,	// Whether to show focus info stats widget
	true,	// Whether to show camera buttons
	true, 	// Whether to show controls helper
	true,	// Whether to show header
	false	// Whether to show entities/locations list
];

missionNamespace setVariable ["SAEF_Respawn_InitDelay", _var_SAEF_Respawn_InitDelay, true];
missionNamespace setVariable ["SAEF_Respawn_SpectatorParams", _var_SAEF_Respawn_SpectatorParams, true];
```

You are now able to control the configuration of the spectator settings (entirely optional) via means of the above missionNamespace variables. The initialisation delay can be used to delay the start of the spectator (if you like to run something else directly on player death). The Spectator params are as described. The function of each parameter is commented above.
