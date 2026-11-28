/*
	fn_MSO_AddActions.sqf

	Description:
		Adds ACE support actions to an object, based on what the mission variables setup for supports are.

	How to Call:
		[
			_object		// object
		] call SAEF_ASA_fnc_MSO_AddActions;
*/

params
[
	["_object", objNull]
];

// Exits script if the object requested doesn't exist
if (isNull _object) exitWith 
{
	["SAEF_ASA_fnc_MSO_AddActions", 1, (format ["Cannot add ACE Actions to an object that does not exist!"])] call RS_fnc_LoggingHelper;
};

/* Supports Region */
if (missionNamespace getVariable ["SAEF_ASA_Supports_Enabled", false]) then
{
	private
	[
		"_action",
		"_airSupportsParent"
	];

	// Support Actions Parent
	_action = ["SAEF_ASA_Supports","Player Supports","",{},
		{(missionNamespace getVariable ["SAEF_ASA_Supports_Enabled", false])},{},[], [0,0,0], 100] call ace_interact_menu_fnc_createAction;

	[_object, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
	_airSupportsParent = ["ACE_MainActions", "SAEF_ASA_Supports"];

	/* Air Supports Region */
	if (missionNamespace getVariable ["SAEF_ASA_AirSupport_Enabled", false]) then
	{
		// Air Support Info
		_action = ["SAEF_ASA_AirSupport_Status", "Air Support Status", "", {
			if (missionNamespace getVariable ["SAEF_ASA_AirSupport_Available", false]) then
			{
				hint "Air Support Available";
			}
			else
			{
				private
				[
					"_availableTime"
				];

				// Derive the Time Remaining for the supports
				_availableTime = [false, 0, "SAEF_ASA_AirSupport_Available_Time"] call SAEF_ASA_fnc_TimeUntilGivenTime;
				_availableTime params ["_min", "_sec"];
				
				if (_min > 0) then
				{
					hint format ["Air Support on Cool Down, Available in %1m %2s", _min, _sec];
				}
				else
				{
					hint format ["Air Support on Cool Down, Available in %1s", _sec];
				};
			};
		}, {!(missionNamespace getVariable ["SAEF_ASA_AirSupport_Finished", false])}, {}, [], [0,0,0], 100] call ace_interact_menu_fnc_createAction;

		[_object, 0, _airSupportsParent, _action] call ace_interact_menu_fnc_addActionToObject;

		_subfolderValidationCodeBlock = {
			(missionNamespace getVariable ["SAEF_ASA_AirSupport_Unlimited", false]) || (missionNamespace getVariable ["SAEF_ASA_AirSupport_Available", false])
		};

		_airSupportCodeBlock = {
			params ["_target", "_player", "_params"];
			_params = ["SAEF_ASA_AirSupport"] + _params;
			
			if (missionNamespace getVariable ["SAEF_ASA_AirSupport_Unlimited", false]) then
			{
				_params call SAEF_ASA_fnc_SupportHandler_Player;
			}
			else
			{
				if (missionNamespace getVariable ["SAEF_ASA_AirSupport_Available", false]) then
				{
					missionNamespace setVariable ["SAEF_ASA_AirSupport_Available", false, true];
					_params call SAEF_ASA_fnc_SupportHandler_Player;
				};
			};
		};

		_airSupportValidationCodeBlock = {
			(missionNamespace getVariable ["SAEF_ASA_AirSupport_Unlimited", false]) || (missionNamespace getVariable ["SAEF_ASA_AirSupport_Available", false])
		};
		
		// Code block to generate the sub folders
		[_object, "SAEF_ASA_Supports_AirSupport_List", "SAEF_ASA_AirSupport", _airSupportsParent, _subfolderValidationCodeBlock, _airSupportCodeBlock, _airSupportValidationCodeBlock] call SAEF_ASA_fnc_MSO_AddSubFolders;
	};
	/* End of Air Supports Region */
	
	/* Transport Supports Region */
	if (missionNamespace getVariable ["SAEF_ASA_TransportSupport_Enabled", false]) then
	{
		private
		[
			"_subfolderValidationCodeBlock",
			"_airSupportCodeBlock",
			"_airSupportValidationCodeBlock"
		];

		_subfolderValidationCodeBlock = {
			(missionNamespace getVariable ["SAEF_ASA_TransportSupport_Available", false])
		};

		_airSupportCodeBlock = {
			params ["_target", "_player", "_params"];
			_params = ["SAEF_ASA_TransportSupport"] + _params;
			
			if (missionNamespace getVariable ["SAEF_ASA_TransportSupport_Available", false]) then
			{
				missionNamespace setVariable ["SAEF_ASA_TransportSupport_Available", false, true];
				_params call SAEF_ASA_fnc_SupportHandler_Player;
			};
		};

		_airSupportValidationCodeBlock = {
			(missionNamespace getVariable ["SAEF_ASA_TransportSupport_Available", false])
		};
		
		// Code block to generate the sub folders
		[_object, "SAEF_ASA_Supports_TransportSupport_List", "SAEF_ASA_TransportSupport", _airSupportsParent, _subfolderValidationCodeBlock, _airSupportCodeBlock, _airSupportValidationCodeBlock] call SAEF_ASA_fnc_MSO_AddSubFolders;
	};
	/* End of Transport Supports Region */
};