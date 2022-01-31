/**
	@namespace SAEF_AS
	@class AutomatedSpawning
	@method SAEF_AS_fnc_ConfigCore3DENValidation
	@file fn_ConfigCore3DENValidation.sqf
	@summary Validates all the core modules

	@TODO: check params / Return
**/

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
	"_informationArray",
	"_collectedTags"
];

_validArray = [];
_informationArray = [];
_collectedTags = [];

{
	_x params ["_logic"];

	if ((typeOf _logic) == "SAEF_ModuleSpawnAreaConfigCore") then
	{
		(_logic get3DENAttribute "SAEF_ModuleSpawnAreaConfigCore_Tag") params 
		[
			["_tag", "no_tag"]
		];

		_collectedTags pushBack _tag;

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

// Validate the spawn area and hunter killer modules if we have any collected tags
if (!(_collectedTags isEqualTo [])) then
{
	{
		_x params ["_logic"];

		if ((typeOf _logic) in ["SAEF_ModuleSpawnArea", "SAEF_ModuleSpawnHunterKiller", "SAEF_ModuleSpawnHunterKillerPosition"]) then
		{
			(_logic get3DENAttribute (format ["%1_Tag", (typeOf _logic)])) params 
			[
				["_tag", "no_tag"]
			];

			if (!(_tag in _collectedTags)) then
			{
				_validArray pushBack false;
				_informationArray = _informationArray 
					+ [1, (format ["Module [%1 : %2] has a tag [%3] that is not configured by a core module!", (typeOf _logic), _logic, _tag])];
			};
		};
	} forEach _systems;
};

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