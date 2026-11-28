/*
	fn_MSO_AddSubFolders.sqf

	Description:
		Adds ACE support sub folder actions

	How to Call:
		[
			"_supportVariable",
			"_givenSubfolderName",
			"_airSupportsParent",
			"_subfolderValidationCodeBlock",
			"_airSupportCodeBlock",
			"_airSupportValidationCodeBlock"
		] call SAEF_ASA_fnc_MSO_AddSubFolders;
*/

params
[
	"_object",
	"_supportVariable",
	"_givenSubfolderName",
	"_airSupportsParent",
	"_subfolderValidationCodeBlock",
	"_airSupportCodeBlock",
	"_airSupportValidationCodeBlock"
];

private
[
	"_airSupportsList"
];

// Air Supports ACE Actions for all listed supports
_airSupportsList = missionNamespace getVariable [_supportVariable, []]; 

// Outer Array for Supports Sub Folder
{
	private
	[
		"_j",
		"_currentAirSupportsParent"
	];

	_j = _forEachIndex;
	_x params
	[
		"_subFolder",
		"_airSupports",
		["_image", ""]
	];
	
	_subfolderName = _givenSubfolderName;
	_currentAirSupportsParent = _airSupportsParent;
	
	// If we dont want it in the root folder
	if (toUpper(_subFolder) != "ROOT") then
	{
		private
		[
			"_action"
		];

		// Set the name of the subfolder
		_subfolderName = format["%1_%2", _subfolderName, _j];
		
		if (missionNamespace getVariable ["SAEF_ASA_ExtendedLogging", false]) then
		{
			["SAEF_ASA_fnc_MSO_AddActions", 4, (format ["Sub Folder Name [%1] Description [%2]", _subfolderName, _subFolder])] call RS_fnc_LoggingHelper;
		};
		
		// Add the Subfolder to Air Supports
		_action = [_subfolderName, _subFolder, _image, {}, _subfolderValidationCodeBlock, {}, [], [0,0,0], 100] call ace_interact_menu_fnc_createAction;

		[_object, 0, _airSupportsParent, _action] call ace_interact_menu_fnc_addActionToObject;
		
		// Set the new action parent for each support
		_currentAirSupportsParent = _airSupportsParent + [_subfolderName];
		
		if (missionNamespace getVariable ["SAEF_ASA_ExtendedLogging", false]) then
		{
			["SAEF_ASA_fnc_MSO_AddActions", 4, (format ["Adding action to object [%1] with air support parent [%2]", _object, _airSupportsParent])] call RS_fnc_LoggingHelper;
		};
	};
	
	// Inner Array for Each Air Support
	{
		private
		[
			"_i",
			"_name",
			"_action"
		];

		_i = _forEachIndex;
		_name = format["%1_%2", _subfolderName, _i];
		_x params
		[
			"_description",
			"_plane",
			["_scripts", []],
			["_loadout", ""],
			["_image", ""],
			["_customCallsigns", ""]
		];
		
		if (missionNamespace getVariable ["SAEF_ASA_ExtendedLogging", false]) then
		{
			["SAEF_ASA_fnc_MSO_AddActions", 4, (format ["Name [%1] Description [%2]", _name, _description])] call RS_fnc_LoggingHelper;
		};
		
		_action = [_name, _description, _image, _airSupportCodeBlock, _airSupportValidationCodeBlock, {}, [_plane, _scripts, _loadout, _customCallsigns], [0,0,0], 100] call ace_interact_menu_fnc_createAction;

		[_object, 0, _currentAirSupportsParent, _action] call ace_interact_menu_fnc_addActionToObject;

		if (missionNamespace getVariable ["SAEF_ASA_ExtendedLogging", false]) then
		{
			["SAEF_ASA_fnc_MSO_AddActions", 4, (format ["Adding action to object [%1] with current air support parent [%2]", _object, _currentAirSupportsParent])] call RS_fnc_LoggingHelper;
		};

	} forEach _airSupports;

} forEach _airSupportsList;