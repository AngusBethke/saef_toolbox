# SAEF View Distance Toolset
Provides some functions for adjusting view distance. **Note:** this has a module component, if you'd like to see how that works check out [this tutorial](https://youtu.be/CSM4_Rmvo2w) video.

## Functions
```
[
  _defaultServerVD,		// (Optional) The default view distance for the server
  _defaultPlayerVD,		// (Optional) The default view distance for the player
  _defaultAircraftVD,		// (Optional) The default view distance for the aircraft
  _defaultShadowVD,		// (Optional) The default shadow view distance for everyone
  _defaultFixedCeiling	// (Optional) The capped ceiling for max view distance based on height
] call SAEF_VD_fnc_Init;
```
