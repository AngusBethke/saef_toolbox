# SAEF Vehicle Toolset
Provides useful functions for interacting with vehicles. **Note:** this has a module component, if you would like to see how that works take a look at [this tutorial](https://youtu.be/CSM4_Rmvo2w) video.

## Functions
### Rearm and Repair
1. Setup - this sets up the Rearm and Repair functionality for a given vehicle (should be called from server locality)
```
// Example
[
  "nCar_1",         // (String) Variable name of the vehicle to setup the functionality force
  "nCar_1_pad"      // (String) Variable name of the object where the vehicle can be repaired, respawned or rearmed
] call SAEF_VEH_fnc_RnR_Setup;
```
