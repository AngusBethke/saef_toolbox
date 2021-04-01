# SAEF Vehicle Toolset
Provides useful functions for interacting with vehicles

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
