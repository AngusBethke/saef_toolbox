/*
	fn_View.sqf

	Description:
		Handles view functions
*/

// Common spectator defines
#include "\A3\Functions_F_Exp_A\EGSpectatorCommonDefines.inc"

params
[
	"_type",
	["_params", []]
];

/*
	-----------------
	-- GETVIEWMODE --
	-----------------

	Gets the preferred view mode
*/
if (toUpper(_type) == "GETVIEWMODE") exitWith
{
	// Return
	missionNamespace getVariable ["SAEF_SPTR_PreferredViewingMode", MODE_FPS]
};

/*
	-----------------
	-- SETVIEWMODE --
	-----------------

	Sets the preferred view mode
*/
if (toUpper(_type) == "SETVIEWMODE") exitWith
{
	_params params
	[
		"_viewMode"
	];

	// Set preferred viewing mode
	if (toUpper(_viewMode) == "MODE_FPS") exitWith
	{
		missionNamespace setVariable ["SAEF_SPTR_PreferredViewingMode", MODE_FPS, true];
	};
	
	if (toUpper(_viewMode) == "MODE_FOLLOW") exitWith
	{
		missionNamespace setVariable ["SAEF_SPTR_PreferredViewingMode", MODE_FOLLOW, true];
	};
};

/*
	--------------------
	-- GETSWITCHDELAY --
	--------------------

	Gets the delay time for view switch
*/
if (toUpper(_type) == "GETSWITCHDELAY") exitWith
{
	// Return
	missionNamespace getVariable ["SAEF_SPTR_ViewSwitchDelay", 60]
};

/*
	--------------------
	-- SETSWITCHDELAY --
	--------------------

	Sets the delay time for view switch
*/
if (toUpper(_type) == "SETSWITCHDELAY") exitWith
{
	_params params
	[
		"_delay"
	];

	missionNamespace setVariable ["SAEF_SPTR_ViewSwitchDelay", _delay, true];
};

["SAEF_SPTR_fnc_View", 2, (format ["Unrecognised type [%1], nothing is being executed!", _type])] call RS_fnc_LoggingHelper;