# SAEF Admin Toolset
## Add Mission Action
This function allows you to add actions to the ace admin action tree for use in your missions, useful for scripts you would like to execute quickly without having to access the debug console.
```
// Example

[
	[],                                         // Array: These are the script parameters
	"Scripts\Mission\EndMission.sqf",           // String: This is script to execute
	"End Mission",                              // String: This is the pretty name of the action
	true                                        // Boolean: Whether or not to execute this script on the server
] call RS_fnc_Admin_AddMissionAction;
```
