# SAEF AI Toolset
## Physical Artillery
This function coordinates an artillery strike on the given position using the specified AI artillery crew. **Note:** This functionality exists in the form of a module (SAEF > Artillery - Physical) now.
```
// Example
[
	[arty_1],		// Vehicles that are firing at these positions
	[350,475,0],		// Positions being fired at
	4,			// Number of rounds fired per position
	"explosive",		// (Optional) Type of shell to fire in the salvo ["explosive", "smoke", "flare"]
	0			// (Optional) The spread in meters for the artillery target
] spawn SAEF_AI_fnc_PhysicalArtillery;
```
