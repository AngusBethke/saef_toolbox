# SAEF Task Force Radio Toolset
Provides useful functions for interacting with Task Force Radio

## Functions:
1. Catch distribution event handler - registers a new TFAR event handler to catch when the radio assignment has finished (this is so that we can override the radios if needed).
```
[] call RS_TFR_fnc_Catch_OnRadiosReceived;
```
