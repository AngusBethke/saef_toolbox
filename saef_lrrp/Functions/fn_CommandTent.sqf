/*
	fn_CommandTent.sqf

	Description:
		Manages the command tent
*/

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
		["INIT"] call SAEF_LRRP_fnc_CommandTent;
*/
if (toUpper(_type) == "INIT") exitWith 
{
	if (hasInterface) exitWith
	{
		["DEPLOY_ACTION"] call SAEF_LRRP_fnc_CommandTent;
	};
};

/*
	------------
	-- DEPLOY --
	------------

	Called by the persistence mechanism and ace interaction, this method handles the deployment of the command tent
*/
if (toUpper(_type) == "DEPLOY") exitWith 
{
	["SAEF_LRRP_fnc_CommandTent", 3, "Deploying the command tent..."] call RS_fnc_LoggingHelper;

	_params params
	[
		["_position", (player modelToWorld [0,1,0])],
		["_direction", (getDir player)],
		["_bergenCount", (missionNamespace getVariable ["SAEF_LRRP_CommandTent_BergenCount", 60])]
	];

	if (hasInterface) then
	{
		// Ensure it is marked that the player has no command tent
		player setVariable ["SAEF_LRRP_HasCommandTent", nil, true];

		hint "Deploying Command Tent...";
	};
	
	(missionNamespace getVariable ["SAEF_LRRP_CommandTent", []]) params
	[
		"_tentType",
		"_tentFolded",
		"_tentExtras"
	];

	private
	[
		"_commandTent"
	];

	_commandTent = createVehicle [_tentFolded, _position, [], 0, "CAN_COLLIDE"];
	_commandTent setDir _direction;
	_commandTent allowDamage false;

	playSound3D [(["Bag3D"] call SAEF_LRRP_fnc_Sounds), _commandTent, false, (getPosASL _commandTent), 5, 1, 100];

	_position = (getPos _commandTent);
	_direction = (getDir _commandTent);

	deleteVehicle _commandTent;

	sleep 5;

	_commandTent = createVehicle [_tentType, _position, [], 0, "CAN_COLLIDE"];
	_commandTent setDir _direction;
	_commandTent allowDamage false;

	playSound3D [(["Bag3D"] call SAEF_LRRP_fnc_Sounds), _commandTent, false, (getPosASL _commandTent), 5, 1, 100];

	private
	[
		"_commandTentExtras"
	];

	_commandTentExtras = [];
	{
		_x params
		[
			"_tentExtraType",
			"_tentExtraDir",
			"_tentExtraPos"
		];

		private
		[
			"_tentExtra"
		];

		_tentExtra = createVehicle [_tentExtraType, _position, [], 0, "CAN_COLLIDE"];
		_tentExtra attachTo [_commandTent, _tentExtraPos];
		_tentExtra setDir _tentExtraDir;
		_tentExtra allowDamage false;

		_commandTentExtras pushBack _tentExtra;
	} forEach _tentExtras;

	// Ensure extras are linked to the command tent
	_commandTent setVariable ["SAEF_LRRP_CommandTent_Extras", _commandTentExtras, true];

	// Let the mission know this is the current command tent
	missionNamespace setVariable ["SAEF_LRRP_CommandTent_Object", _commandTent, true];

	// Move respawn point
	(missionNamespace getVariable ["SAEF_LRRP_CommandTent_Marker", "respawn"]) setMarkerPos (getPos _commandTent);

	// Add actions
	["RETRIEVE_ACTION_GLOBAL", [_commandTent]] call SAEF_LRRP_fnc_CommandTent;
	["RETURN_BERGEN_ACTION_GLOBAL", [_commandTent]] call SAEF_LRRP_fnc_CommandTent;
	["LOADOUT_ACTION_GLOBAL", [_commandTent]] call SAEF_LRRP_fnc_CommandTent;
	["SUPPORTS_ACTION_GLOBAL", [_commandTent]] call SAEF_LRRP_fnc_CommandTent;

	// Persistence
	["PERSIST_SERVER", [(getPos _commandTent), (getDir _commandTent), _bergenCount]] call SAEF_LRRP_fnc_CommandTent;

	// Markers
	["MARKER", [_commandTent, "Create"]] call SAEF_LRRP_fnc_CommandTent;

	if (hasInterface) then
	{
		hint "Command Tent Deployed!";
	};
};

/*
	--------------
	-- RETRIEVE --
	--------------

	Called by ace interaction, this method handles the retrieval of the command tent
*/
if (toUpper(_type) == "RETRIEVE") exitWith 
{
	_params params
	[
		"_commandTent"
	];

	playSound3D [(["Bag3D"] call SAEF_LRRP_fnc_Sounds), _commandTent, false, (getPosASL _commandTent), 5, 1, 100];

	player setVariable ["SAEF_LRRP_HasCommandTent", true, true];

	["MARKER", [_commandTent]] call SAEF_LRRP_fnc_CommandTent;
	missionNamespace setVariable ["SAEF_LRRP_CommandTent_Object", nil, true];

	// Cleanup the command tent extras
	{
		deleteVehicle _x;
	} forEach (_commandTent getVariable ["SAEF_LRRP_CommandTent_Extras", []]);

	deleteVehicle _commandTent;

	// Move respawn point
	(missionNamespace getVariable ["SAEF_LRRP_CommandTent_Marker", "respawn"]) setMarkerPos [0,0,0];
};

/*
	------------
	-- MARKER --
	------------

	Executed by the unpack method, this method handles the creation and deletion for the marker of the player's tent rally point
*/
if (toUpper(_type) == "MARKER") exitWith 
{
	_params params
	[
		"_commandTent",
		["_markerAction", "DELETE"]
	];

	private
	[
		"_markerName"
	];

	_markerName = "SAEF_LRRP_CommandTent_Marker";

	if (toUpper(_markerAction) == "CREATE") then
	{
		private
		[
			"_marker"
		];

		_marker = createMarker [_markerName, (getPos _commandTent)];
		_marker setMarkerColor "colorBLUFOR";
		_marker setMarkerType "hd_flag";
		_marker setMarkerText "Command Tent";
	}
	else
	{
		deleteMarker _markerName;
	};
};

/*
	----------------------------
	-- RETRIEVE_ACTION_GLOBAL --
	----------------------------

	This method is a global caller for the RETRIEVE_ACTION method
*/
if (toUpper(_type) == "RETRIEVE_ACTION_GLOBAL") exitWith 
{
	["RETRIEVE_ACTION", _params] remoteExecCall ["SAEF_LRRP_fnc_CommandTent", 0, true];
};

/*
	---------------------------------
	-- RETURN_BERGEN_ACTION_GLOBAL --
	---------------------------------

	This method is a global caller for the RETRIEVE_ACTION method
*/
if (toUpper(_type) == "RETURN_BERGEN_ACTION_GLOBAL") exitWith 
{
	["RETURN_BERGEN_ACTION", _params] remoteExecCall ["SAEF_LRRP_fnc_CommandTent", 0, true];
};

/*
	---------------------------
	-- LOADOUT_ACTION_GLOBAL --
	---------------------------

	This method is a global caller to the loadout function to add all of the loadout actions to the command tent
*/
if (toUpper(_type) == "LOADOUT_ACTION_GLOBAL") exitWith 
{
	["INIT", _params] remoteExecCall ["SAEF_LRRP_fnc_Loadout", 0, true];
};

/*
	---------------------------
	-- SUPPORTS_ACTION_GLOBAL --
	---------------------------

	This method is a global caller to the ace supports toolbox to add the option to get a mobile supports object
*/
if (toUpper(_type) == "SUPPORTS_ACTION_GLOBAL") exitWith 
{
	_params params
	[
		"_commandTent"
	];

	["GetAction", _commandTent] remoteExecCall ["SAEF_ASA_fnc_MobileSupportObject", 0, true];
};

/*
	--------------------
	-- PERSIST_SERVER --
	--------------------

	This method is a server caller to the persistence method to save persistence values
*/
if (toUpper(_type) == "PERSIST_SERVER") exitWith 
{
	["SAVE", _params] remoteExecCall ["SAEF_LRRP_fnc_Persistence", 2, false];
};

/*
	--------------------------
	-- BERGEN_UPDATE_SERVER --
	--------------------------

	This method is a server caller to the bergen update method to update bergen information
*/
if (toUpper(_type) == "BERGEN_UPDATE_SERVER") exitWith 
{
	// Update the bergen count locally
	_params params
	[
		"_updateType"
	];

	_bergenCount = (missionNamespace getVariable ["SAEF_LRRP_CommandTent_BergenCount", 60]);

	if ((toUpper _updateType) == "ADD") then
	{
		_bergenCount = _bergenCount + 1;
	}
	else
	{
		_bergenCount = _bergenCount - 1;
	};

	missionNamespace setVariable ["SAEF_LRRP_CommandTent_BergenCount", _bergenCount, true];

	// Notify that the server should update the persistence settings
	["BERGEN_UPDATE"] remoteExecCall ["SAEF_LRRP_fnc_CommandTent", 2, false];

	// Return the updated bergen count
	_bergenCount
};

/*
	-------------------
	-- BERGEN_UPDATE --
	-------------------

	This method updates bergen information and saves persistence
*/
if (toUpper(_type) == "BERGEN_UPDATE") exitWith 
{
	// Save command tent params
	private
	[
		"_commandTent",
		"_paramsToSave",
		"_bergenCount"
	];

	_commandTent = (missionNamespace getVariable ["SAEF_LRRP_CommandTent_Object", objNull]);
	_bergenCount = (missionNamespace getVariable ["SAEF_LRRP_CommandTent_BergenCount", 60]);

	if (!(isNull _commandTent)) then
	{
		_paramsToSave =
		[
			(getPos _commandTent), 
			(getDir _commandTent), 
			_bergenCount
		];

		["SAVE", _paramsToSave] call SAEF_LRRP_fnc_Persistence;
	};
};

/*
	-------------------
	-- RETURN_BERGEN --
	-------------------

	This method is called by the return bergen ace action
*/
if (toUpper(_type) == "RETURN_BERGEN") exitWith 
{
	// Remove player's backpack
	removeBackpack player;

	// Add it back to the command tent
	private
	[
		"_currentBergenCount"
	];

	_currentBergenCount = ["BERGEN_UPDATE_SERVER", ["ADD"]] call SAEF_LRRP_fnc_CommandTent;

	hint (format ["Returned Bergen, %1 remaining...", _currentBergenCount]);
};

/*
	-------------------
	-- DEPLOY_ACTION --
	-------------------

	Called by the init method, this method creates the ace action for deployment of the command tent
*/
if (toUpper(_type) == "DEPLOY_ACTION") exitWith 
{
	if (!hasInterface) exitWith {};

	["SAEF_LRRP_fnc_CommandTent", 3, "Adding deploy action for command tent..."] call RS_fnc_LoggingHelper;

	private
	[
		"_action"
	];

	_action = ["SAEF_LRRP_CommandTent_Unpack", "Unpack Command Tent", "saef_lrrp\Images\CommandRally_co.paa", 
		{
			params ["_target", "_player", "_params"];

			_params spawn SAEF_LRRP_fnc_CommandTent;
		},
		{
			// If the player has a command tent, and their backpack is in the list of backpacks allowed to deploy that tent
			((player getVariable ["SAEF_LRRP_HasCommandTent", false]) 
			&& ((backpack player) in (missionNamespace getVariable ["SAEF_LRRP_AllowedBackpacks", []])))
		},
		{}, ["Deploy"], [0,0,0], 100
	] call ace_interact_menu_fnc_createAction;
	
	[player, 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToObject;
};

/*
	---------------------
	-- RETRIEVE_ACTION --
	---------------------

	Called by the deploy method, this method creates the ace action for retrieval of the command tent
*/
if (toUpper(_type) == "RETRIEVE_ACTION") exitWith 
{
	if (!hasInterface) exitWith {};

	["SAEF_LRRP_fnc_CommandTent", 3, "Adding retrieve action to command tent..."] call RS_fnc_LoggingHelper;

	_params params
	[
		"_commandTent"
	];

	private
	[
		"_action"
	];

	_action = ["SAEF_LRRP_CommandTent_Pickup", "Pickup Command Tent", "saef_lrrp\Images\CommandRally_co.paa",
		{
			params ["_target", "_player", "_params"];

			_params call SAEF_LRRP_fnc_CommandTent;
		},
		{
			(!(player getVariable ["SAEF_LRRP_HasCommandTent", false]) 
			&& ((backpack player) in (missionNamespace getVariable ["SAEF_LRRP_AllowedBackpacks", []])))
		}, {}, ["Retrieve", [_commandTent]], [0,0,0], 100
	] call ace_interact_menu_fnc_createAction;
	
	[_commandTent, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
};

/*
	--------------------------
	-- RETURN_BERGEN_ACTION --
	--------------------------

	Called by the deploy method, this method creates the ace action for returning a bergen
*/
if (toUpper(_type) == "RETURN_BERGEN_ACTION") exitWith 
{
	if (!hasInterface) exitWith {};

	["SAEF_LRRP_fnc_CommandTent", 3, "Adding retrieve action to command tent..."] call RS_fnc_LoggingHelper;

	_params params
	[
		"_commandTent"
	];

	private
	[
		"_action"
	];

	_action = ["SAEF_LRRP_CommandTent_ReturnBergen", "Return Bergen", "",
		{
			params ["_target", "_player", "_params"];

			_params call SAEF_LRRP_fnc_CommandTent;
		},
		{
			((backpack player) in (missionNamespace getVariable ["SAEF_LRRP_AllowedBackpacks", []]))
		}, {}, ["Return_Bergen"], [0,0,0], 100
	] call ace_interact_menu_fnc_createAction;
	
	[_commandTent, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
};

/*
	------------------
	-- TENT_BUILDER --
	------------------

	Called manually, this method can be used to build the array for the tent extras 

	["TENT_BUILDER", [commandTent]] call SAEF_LRRP_fnc_CommandTent;
*/
if (toUpper(_type) == "TENT_BUILDER") exitWith 
{
	_params params
	[
		"_commandTent"
	];

	private
	[
		"_commandTentItems"
	];

	_commandTentItems = [];

	{
		private
		[
			"_item",
			"_position",
			"_direction"
		];

		_item = _x;
		_position = _commandTent worldToModel (getPos _item);
		_direction = (getDir _item) - (getDir _commandTent);

		if (_direction < 0) then
		{
			_direction = _direction + 360;
		};

		_commandTentItems pushBack [(typeOf _item), (round _direction), _position];
	} forEach (_commandTent nearEntities 3);

	["SAEF_LRRP_fnc_CommandTent", 3, (format ["TENT_BUILDER: %1", _commandTentItems])] call RS_fnc_LoggingHelper;
};


// Log warning if type is not recognised
["SAEF_LRRP_fnc_CommandTent", 2, (format ["Unrecognised type [%1], nothing is being executed!", _type])] call RS_fnc_LoggingHelper;