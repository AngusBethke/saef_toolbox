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

/*
	------------------------
	-- SET_NVG_BRIGHTNESS --
	------------------------

	Sets the nvg brightness values

	["SET_NVG_BRIGHTNESS", [1, 0.5]] call SAEF_SPTR_fnc_View;
*/
if (toUpper(_type) == "SET_NVG_BRIGHTNESS") exitWith
{
	missionNamespace setVariable ["SAEF_SPTR_NVG_Brightness", _params, true];
};

/*
	------------------------------
	-- SET_NVG_COLORCORRECTIONS --
	------------------------------

	Sets the nvg color corrections

	["SET_NVG_COLORCORRECTIONS", [true]] call SAEF_SPTR_fnc_View;
*/
if (toUpper(_type) == "SET_NVG_COLORCORRECTIONS") exitWith
{
	_params params
	[
		"_apply"
	];

	private
	[
		"_handle"
	];

	if (_apply) then
	{
		_handle = ppEffectCreate ["ColorCorrections", 2003];
		_handle ppEffectAdjust (missionNamespace getVariable ["SAEF_SPTR_NVG_Brightness", [1, 0.5]]) + [0, [0.0, 0.0, 0.0, 0.0], [1.3, 1.2, 0.0, 0.9], [6, 1, 1, 0.0]];
    	_handle ppEffectCommit 0;
		_handle ppEffectForceInNVG true;
		_handle ppEffectEnable true;

		player setVariable ["SAEF_SPTR_NVG_ColorCorrections", _handle, true];
	}
	else
	{
		_handle = player getVariable ["SAEF_SPTR_NVG_ColorCorrections", -1];

		if (_handle != -1) then
		{
			ppEffectDestroy _handle;
		};

		player setVariable ["SAEF_SPTR_NVG_ColorCorrections", nil, true];
	};
};

/*
	-------------
	-- USE_NVG --
	-------------

	Determines whether or not nvgs should be used
*/
if (toUpper(_type) == "USE_NVG") exitWith
{
	_params params
	[
		"_target"
	];

	// Returns true if the target is currently using night vision, or the target is in some other view mode and it is dark out
	(((currentVisionMode _target) == 1) || (((currentVisionMode _target) != 0) && (["IS_DARK_OUT"] call SAEF_SPTR_fnc_Time)))
};



["SAEF_SPTR_fnc_View", 2, (format ["Unrecognised type [%1], nothing is being executed!", _type])] call RS_fnc_LoggingHelper;