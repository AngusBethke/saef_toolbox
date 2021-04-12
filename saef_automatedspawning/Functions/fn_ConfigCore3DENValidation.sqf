/* 
	fn_ConfigCore3DENValidation.sqf

	Description: 
		Validates all the core modules

	How to Call: 
		[] call SAEF_AS_fnc_ConfigCore3DENValidation;
		[] execVM "fn_ConfigCore3DENValidation.sqf";
*/

// Get all of our eden entities
all3DENEntities params ["_objects","_groups","_triggers","_systems","_waypoints","_markers","_layers","_comments"];

private
[
	"_validArray",
	"_informationArray"
];

_validArray = [];
_informationArray = [];

{
	_x params ["_logic"];

	if ((typeOf _logic) == "SAEF_ModuleSpawnAreaConfigCore") then
	{
		(_logic get3DENAttribute "SAEF_ModuleSpawnAreaConfigCore_Tag") params 
		[
			["_tag", "no_tag"]
		];

		([_logic, _tag] call SAEF_AS_fnc_ConfigCoreValidation) params
		[
			"_configArray",
			"_valid",
			"_infoArray"
		];

		_validArray pushBack _valid;
		_informationArray = _informationArray + _infoArray;
	};
} forEach _systems;

if (false in _validArray) then
{
	private
	[
		"_errorStr"
	];

	_errorStr = "SAEF Spawn Configuration Errors:";

	{
		_x params
		[
			"_level",
			"_info"
		];

		if (_level == 1) then
		{
			_errorStr = _errorStr + "<br/>" + _info;
		};

		["ConfigCore3DENValidation", _level, _info] call RS_fnc_LoggingHelper;
	} forEach _informationArray;

	[_errorStr, 1] call BIS_fnc_3DENNotification;
};