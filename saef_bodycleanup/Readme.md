# SAEF Body Cleanup Toolset
## Usage
SAEF body cleanup cleans up dead bodies given the supplied parameters, see example below:
```
[
  20,   // (Optional) The limit to number of bodies before cleanup starts 
  120,  // (Optional) The time in seconds before cleanup takes place 
  500   // (Optional) Distance in meters (from any player) that determines whether or not AI should be instantly cleaned up
] spawn RS_BC_fnc_DeadBodyCleanUpPersitent;
```
