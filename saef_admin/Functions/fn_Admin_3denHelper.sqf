/*
	fn_Admin_3denHelper.sqf
	Description: Is called onSave in the 3den editor this checks a number of basic settings and returns errors if there are any.
	How to Call: [] call RS_fnc_Admin_3denHelper;
*/

private
[
	"_errorStr"
];

// Get all of our eden entities
all3DENEntities params ["_objects","_groups","_triggers","_systems","_waypoints","_markers","_layers","_comments"];

// Declare our error string
_errorStr = "";

// Run the Mission Maker Helper
_errorStr = _errorStr + ([_objects, _markers, _systems] call RS_fnc_Admin_MissionMakerHelper);
	
// Run the Trigger Checker
_errorStr = _errorStr + ([_triggers] call RS_fnc_Admin_CheckTrigger);

// Evaluate our error string
if (_errorStr != "") then
{
	_errorStr = "Mission Saved<br/>Mission Errors Found! (This has also been logged to your .rpt file for your convenience)" + _errorStr;
	[_errorStr, 1] call BIS_fnc_3DENNotification;
};

/*
	END
*/