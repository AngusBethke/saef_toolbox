# SAEF View Distance Toolset
Provides some functions for adjusting view distance. **Note:** this has a module component, if you'd like to see how that works check out [this tutorial](https://youtu.be/CSM4_Rmvo2w) video.

## Functions
```
[
  1200,     // (Optional) The default view distance for the server
  1200,     // (Optional) The default view distance for the player
  5000,     // (Optional) The default view distance for the aircraft
  50,       // (Optional) The default shadow view distance for everyone
  150       // (Optional) The capped ceiling for max view distance based on height
] call SAEF_VD_fnc_Init;
```
