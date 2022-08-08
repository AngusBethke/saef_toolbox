/*
	fn_Tent.sqf

	Description:
		Handles the tent
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
		["INIT"] call SAEF_LRRP_fnc_Tent;
*/
if (toUpper(_type) == "INIT") exitWith
{
	// Player will be given tent to start
	player setVariable ["SAEF_LRRP_HasTent", true, true];

	["Unpack_Action"] call SAEF_LRRP_fnc_Tent;
	["Respawn_EH"] call SAEF_LRRP_fnc_Tent;
};

/*
	------------
	-- PACKUP --
	------------

	Executed by the packup ace action, this method handles the packup of the tent
*/
if (toUpper(_type) == "PACKUP") exitWith 
{
	_params params
	[
		"_tent"
	];

	deleteVehicle _tent;
	hint "Packed up Tent";
	
	// Ensure it is marked that the player has their tent
	player setVariable ["SAEF_LRRP_HasTent", true, true];
};

/*
	------------
	-- UNPACK --
	------------

	Executed by the several ace actions, this method handles the unpacking, pitching and folding of the tent
*/
if (toUpper(_type) == "UNPACK") exitWith 
{
	// Ensure it is marked that the player has no tent
	player setVariable ["SAEF_LRRP_HasTent", false, true];

	_params params
	[
		["_tent", objNull],
		["_actionType", "Unfold"]
	];

	playSound3D [(["Bag3D"] call SAEF_LRRP_fnc_Sounds), _tent, false, (getPosASL _tent), 5, 1, 100];
	
	(missionNamespace getVariable ["SAEF_LRRP_Tent", []]) params
	[
		"_tentType",
		"_tentFolded"
	];

	private
	[
		"_pos",
		"_dir"
	];

	_pos = (getPos player);
	_dir = (getDir player);

	if (!(isNull _tent)) then
	{
		_pos = (getPos _tent);
		_dir = (getDir _tent);

		deleteVehicle _tent;
	};

	if (toUpper(_actionType) == "PITCH") then
	{
		hint "Pitched Tent";
		_tent = createVehicle [_tentType, _pos, [], 0, "CAN_COLLIDE"];
	}
	else 
	{
		hint "Folded Tent";
		_tent = createVehicle [_tentFolded, _pos, [], 0, "CAN_COLLIDE"];
	};
			
	_tent setPos (player modelToWorld [0,0,0]);
	_tent setDir _dir;
	_tent allowDamage false;
	_tent enableSimulation false;

	if (toUpper(_actionType) == "PITCH") then
	{
		["FOLDUP_ACTION", [_tent]] call SAEF_LRRP_fnc_Tent;
		["MARKER", [_tent, "Create"]] call SAEF_LRRP_fnc_Tent;

		player setVariable ["SAEF_LRRP_Tent", _tent, true];
	}
	else 
	{
		["PACKUP_ACTION", [_tent]] call SAEF_LRRP_fnc_Tent;
		["PITCH_ACTION", [_tent]] call SAEF_LRRP_fnc_Tent;
		["MARKER", [_tent]] call SAEF_LRRP_fnc_Tent;

		player setVariable ["SAEF_LRRP_Tent", nil, true];
	};
};

/*
	-------------------
	-- UNPACK_ACTION --
	-------------------

	Executed by the init method, this method creates the ace action to unpack the tent
*/
if (toUpper(_type) == "UNPACK_ACTION") exitWith
{
	private
	[
		"_action"
	];

	_action = ["SAEF_LRRP_Tent_Unpack", "Unpack Tent", "saef_lrrp\Images\PersonalRally_co.paa", 
		{
			params ["_target", "_player", "_params"];

			_params call SAEF_LRRP_fnc_Tent;
		},
		{
			// If the player has a tent, and their backpack is in the list of backpacks allowed to deploy that tent
			((player getVariable ["SAEF_LRRP_HasTent", false]) 
			&& ((backpack player) in (missionNamespace getVariable ["SAEF_LRRP_AllowedBackpacks", []])))
		},
		{}, ["Unpack"], [0,0,0], 100
	] call ace_interact_menu_fnc_createAction;
	
	[player, 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToObject;
};

/*
	-------------------
	-- PACKUP_ACTION --
	-------------------

	Executed by the unpack method, this method creates the ace action to packup the tent
*/
if (toUpper(_type) == "PACKUP_ACTION") exitWith 
{
	_params params
	[
		"_tent"
	];

	private
	[
		"_action"
	];

	_action = ["SAEF_LRRP_Tent_Pickup", "Pickup Tent", "saef_lrrp\Images\PersonalRally_co.paa",
		{
			params ["_target", "_player", "_params"];

			_params call SAEF_LRRP_fnc_Tent;
		},
		{
			(!(player getVariable ["SAEF_LRRP_HasTent", false]) 
			&& ((backpack player) in (missionNamespace getVariable ["SAEF_LRRP_AllowedBackpacks", []])))
		}, {}, ["Packup", [_tent]], [0,0,0], 100
	] call ace_interact_menu_fnc_createAction;
	
	[_tent, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
};

/*
	------------------
	-- PITCH_ACTION --
	------------------

	Executed by the unpack method, this method creates the ace action to pitch the tent
*/
if (toUpper(_type) == "PITCH_ACTION") exitWith 
{
	_params params
	[
		"_tent"
	];

	private
	[
		"_action"
	];

	_action = ["SAEF_LRRP_Tent_Pitch", "Pitch Tent", "saef_lrrp\Images\PersonalRally_co.paa",
		{
			params ["_target", "_player", "_params"];

			_params call SAEF_LRRP_fnc_Tent;
		}, 
		{true}, {}, ["Unpack", [_tent, "Pitch"]], [0,0,0], 100
	] call ace_interact_menu_fnc_createAction;
	
	[_tent, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
};

/*
	-------------------
	-- FOLDUP_ACTION --
	-------------------

	Executed by the unpack method, this method creates the ace action to foldup the tent
*/
if (toUpper(_type) == "FOLDUP_ACTION") exitWith 
{
	_params params
	[
		"_tent"
	];

	private
	[
		"_action"
	];

	_action = ["SAEF_LRRP_Tent_Foldup", "Foldup Tent", "saef_lrrp\Images\PersonalRally_co.paa",
		{
			params ["_target", "_player", "_params"];

			_params call SAEF_LRRP_fnc_Tent;
		},
		{true}, {}, ["Unpack", [_tent]], [0,0,0], 100
	] call ace_interact_menu_fnc_createAction;
	
	[_tent, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
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
		"_tent",
		["_markerAction", "DELETE"]
	];

	private
	[
		"_markerName"
	];

	_markerName = (format ["SAEF_LRRP_Tent_Marker_%1", (name player)]);

	if (toUpper(_markerAction) == "CREATE") then
	{
		private
		[
			"_marker"
		];

		_marker = createMarker [_markerName, (getPos _tent)];
		_marker setMarkerColor "colorBLUFOR";
		_marker setMarkerType "hd_flag";
		_marker setMarkerText (format ["Tent-Rally (%1)", (name player)]);
	}
	else
	{
		deleteMarker _markerName;
	};
};

/*
	----------------
	-- RESPAWN_EH --
	----------------

	Executed by the init method, this method creates the respawn event handler for the player
*/
if (toUpper(_type) == "RESPAWN_EH") exitWith 
{
	// Respawn event handler
	player addEventHandler ["Respawn", 
	{
		params ["_unit", "_corpse"];

		["RESPAWN"] call SAEF_LRRP_fnc_Tent;
	}];

	// Move player to the tent when it's available or after 10 seconds
	[] spawn 
	{
		private
		[
			"_control"
		];

		_control = 1;
		waitUntil {
			sleep 0.1;
			_control = _control + 1;
			(!(isNull (missionNamespace getVariable ["SAEF_LRRP_CommandTent_Object", objNull])) || _control >= 100)
		};

		["RESPAWN"] call SAEF_LRRP_fnc_Tent;
	};
};

/*
	-------------
	-- RESPAWN --
	-------------

	Executed by the respawn event handler, this method will move the player to their tent rally (if there is one)
	when they respawn.
*/
if (toUpper(_type) == "RESPAWN") exitWith 
{
	private
	[
		"_tent"
	];

	_tent = player getVariable ["SAEF_LRRP_Tent", objNull];

	// If there is a tent, that is now the player's respawn position
	if (!(isNull _tent)) exitWith
	{
		player setPos (getPos _tent);
	};

	// If the respawn marker is not at [0,0,0], that is the player's spawn
	private
	[
		"_respawnMarker"
	];

	_respawnMarker = (missionNamespace getVariable ["SAEF_LRRP_CommandTent_Marker", "respawn"]);
	if (!((markerPos _respawnMarker) isEqualTo [0,0,0])) exitWith
	{
		player setPos (markerPos _respawnMarker);
	};

	// If all else fails, we need to pick a random player for respawn
	private
	[
		"_playerToSpawn"
	];

	_playerToSpawn = objNull;
	{
		if ((alive _x) && ((_x distance [0,0,0]) > 50) && (((getPosATL _x) select 2) < 15)) then
		{
			_playerToSpawn  = _x;
		};
	} forEach ([] call RS_PLYR_fnc_GetTruePlayers);

	if (!(isNull _playerToSpawn)) then
	{
		player setPos (_playerToSpawn modelToWorld [0,-2, 0]);
	};
};

// Log warning if type is not recognised
["SAEF_LRRP_fnc_Tent", 2, (format ["Unrecognised type [%1], nothing is being executed!", _type])] call RS_fnc_LoggingHelper;