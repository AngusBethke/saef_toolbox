/*
	fn_Loadout.sqf

	Description:
		Handles loadouts and the actions for those loadouts
*/

if (!hasInterface) exitWith {};

params
[
	"_type",
	["_params", []]
];

/*
	----------
	-- INIT --
	----------

	This method handles the initialisation of this function

	Calling:
		["INIT", [objNull]] call SAEF_LRRP_fnc_Loadout;
*/
if (toUpper(_type) == "INIT") exitWith
{
	_params params
	[
		"_commandTent"
	];

	// Setup the parent loadout action
	private
	[
		"_parentAction"
	];

	["SAEF_LRRP_fnc_Loadout", 3, "Adding loadout actions to command tent..."] call RS_fnc_LoggingHelper;

	_parentAction = ["SAEF_LRRP_Loadout", "Loadouts", "", {}, {true}, {}, [], [0,0,0], 100] call ace_interact_menu_fnc_createAction;
	[_commandTent, 0, ["ACE_MainActions"], _parentAction] call ace_interact_menu_fnc_addActionToObject;

	// Setup the child loadout actions
	{
		_x params
		[
			"_loadoutId",
			"_loadout",
			"_loadoutName",
			["_hasBergen", false],
			["_loadoutGearActions", []]
		];

		private
		[
			"_action"
		];

		["SAEF_LRRP_fnc_Loadout", 3, (format ["Adding loadout action [%1] to command tent...", _loadoutName])] call RS_fnc_LoggingHelper;

		_action = [(format ["SAEF_LRRP_Loadout_%1", _loadoutId]), _loadoutName, "",
			{
				params ["_target", "_player", "_params"];

				_params spawn SAEF_LRRP_fnc_Loadout;
			},
			{true}, {}, ["ApplyLoadout", [_loadoutId, _loadout, _hasBergen]], [0,0,0], 100
		] call ace_interact_menu_fnc_createAction;			

		[_commandTent, 0, ["ACE_MainActions", "SAEF_LRRP_Loadout"], _action] call ace_interact_menu_fnc_addActionToObject;
	} forEach (missionNamespace getVariable ["SAEF_LRRP_Loadouts", []]);

	// Setup the parent attachment action
	["SAEF_LRRP_fnc_Loadout", 3, "Adding attachment actions to command tent..."] call RS_fnc_LoggingHelper;

	_parentAction = ["SAEF_LRRP_Attachment", "Attachments", "", {}, 
		{
			((backpack player) in (missionNamespace getVariable ["SAEF_LRRP_AllowedBackpacks", []]))
		}, 
		{}, [], [0,0,0], 100] call ace_interact_menu_fnc_createAction;
	[_commandTent, 0, ["ACE_MainActions"], _parentAction] call ace_interact_menu_fnc_addActionToObject;

	// Setup the child attachment actions
	{
		_x params
		[
			"_attachmentManager",
			"_attachmentCategory",
			"_attachments"
		];

		private
		[
			"_childAction",
			"_childActionId"
		];

		_childActionId = (format ["SAEF_LRRP_Attachment_%1", _forEachIndex]);
		_childAction = [_childActionId, _attachmentCategory, "", {}, {true}, {}, [], [0,0,0], 100] call ace_interact_menu_fnc_createAction;
		[_commandTent, 0, ["ACE_MainActions", "SAEF_LRRP_Attachment"], _childAction] call ace_interact_menu_fnc_addActionToObject;

		{
			_x params
			[
				"_attachmentClassName",
				"_attachmentDisplayName"
			];

			private
			[
				"_action"
			];

			["SAEF_LRRP_fnc_Loadout", 3, (format ["Adding attachment action [%1] to command tent...", _attachmentDisplayName])] call RS_fnc_LoggingHelper;

			_action = [(format ["%1_%2", _childActionId, _forEachIndex]), _attachmentDisplayName, "",
				{
					params ["_target", "_player", "_params"];
					_params params ["_attachmentClassName", "_attachmentManager"];

					[player, _attachmentClassName, false] execVM _attachmentManager;
				},
				{true}, {}, [_attachmentClassName, _attachmentManager], [0,0,0], 100
			] call ace_interact_menu_fnc_createAction;			

			[_commandTent, 0, ["ACE_MainActions", "SAEF_LRRP_Attachment", _childActionId], _action] call ace_interact_menu_fnc_addActionToObject;
		} forEach _attachments;
	} forEach (missionNamespace getVariable ["SAEF_LRRP_Attachments", []]);
};

/*
	------------------
	-- APPLYLOADOUT --
	------------------

	Called by the ace actions created in the init method, this method handles the application of loadouts
*/
if (toUpper(_type) == "APPLYLOADOUT") exitWith
{
	_params params
	[
		"_loadoutId",
		"_loadout",
		"_hasBergen"
	];

	private
	[
		"_scriptHandle",
		"_currentBergenCount"
	];

	_currentBergenCount = 9999;
	// If the player doesn't have a bergen, then we need to reduce the overall bergen count
	if !((backpack player) in (missionNamespace getVariable ["SAEF_LRRP_AllowedBackpacks", []])) then
	{
		_currentBergenCount = ["BERGEN_UPDATE_SERVER", ["REMOVE"]] call SAEF_LRRP_fnc_CommandTent;
	};

	if (_currentBergenCount <= 0) exitWith
	{
		hint "No bergens remaining, cannot get kit!";
	};

	if (_hasBergen && (_currentBergenCount != 9999)) then
	{
		hint (format ["Grabbing Bergen, %1 remaining...", _currentBergenCount]);
	};

	_scriptHandle = [player, _loadout] execVM (missionNamespace getVariable ["SAEF_LRRP_LoadoutManager", "Loadouts\Core.sqf"]);

	waitUntil {
		sleep 0.1;
		((scriptDone _scriptHandle) || (isNull _scriptHandle))
	};

	if (_hasBergen) then
	{
		["SET_BACKPACK", [_loadoutId]] call SAEF_LRRP_fnc_Gear;
	};
};

// Log warning if type is not recognised
["SAEF_LRRP_fnc_Loadout", 2, (format ["Unrecognised type [%1], nothing is being executed!", _type])] call RS_fnc_LoggingHelper;