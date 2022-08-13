/*
	fn_Player.sqf

	Description:
		Handles the settings and methods related to the players

	Player Conditions:
		VeryGood 	= 0.8+
		Good 		= 0.6
		Neutral 	= 0.4
		Bad 		= 0.2
		VeryBad 	= 0

	Ammo Statuses:
		Green 		= 0.8+
		Yellow 		= 0.6
		Orange 		= 0.4
		Red 		= 0.2
		Black 		= 0
*/

params
[
	"_type",
	["_params", []]
];

// Set the script tag
private
[
	"_scriptTag"
];

_scriptTag = "SAEF AID Player";

/*
	----------------------------
	-- GETOVERALLSTATUSFACTOR --
	----------------------------

	Gets the over status factor based on all player groups
*/
if (toUpper(_type) == "GETOVERALLSTATUSFACTOR") exitWith
{
	_params params
	[
		["_logStatus", false]
	];

	// Get player conditions
	private
	[
		"_playerGroups",
		"_statusFactor"
	];

	// Get the status factor of each group
	_playerGroups = (["GetAllPlayerGroups"] call SAEF_AID_fnc_Player);
	_statusFactor = 0;

	private
	[
		"_jsonResultArray"
	];

	_jsonResultArray = [];

	{
		(["GetGroupStatusFactor", [_x, true]] call SAEF_AID_fnc_Player) params
		[
			"_tStatusFactor",
			["_tJsonResult", ""]
		];

		_statusFactor = _statusFactor + _tStatusFactor;

		if (!(_tJsonResult isEqualTo [])) then
		{
			_jsonResultArray pushBack _tJsonResult;
		};
	} forEach _playerGroups;

	// Divide status factor by number of groups
	_statusFactor = (_statusFactor / (count _playerGroups));

	private
	[
		"_jsonResult"
	];

	// Log the status using the JSON logger
	_jsonResult = "";
	if (_logStatus) then
	{
		_jsonResult = [
			"BuildItems", 
			[
				["OverallStatusFactor", _statusFactor], 
				["CurrentDifficulty", (["Get"] call SAEF_AID_fnc_Difficulty)], 
				["GroupStatusFactors", _jsonResultArray, true]
			]
		] call SAEF_LOG_fnc_JsonLogger;
	};

	// Return the status factor
	[_statusFactor, _jsonResult]
};

/*
	-------------------------------
	-- GETGROUPSTATUSFACTORATPOS --
	-------------------------------

	Gets the player status factor based on the group closest to the given position
*/
if (toUpper(_type) == "GETGROUPSTATUSFACTORATPOS") exitWith
{
	_params params
	[
		"_position",
		["_logStatus", false]
	];

	// Return the status factor
	(["GetGroupStatusFactor", [(["GetPlayerGroup", [_position]] call SAEF_AID_fnc_Player), _logStatus]] call SAEF_AID_fnc_Player)
};

/*
	--------------------------
	-- GETGROUPSTATUSFACTOR --
	--------------------------

	Gets the status factor based on the given
*/
if (toUpper(_type) == "GETGROUPSTATUSFACTOR") exitWith
{
	_params params
	[
		"_playerGroup",
		["_logStatus", false]
	];

	(["GetConditions", [_playerGroup, _logStatus]] call SAEF_AID_fnc_Player) params
	[
		"_condition",
		"_liveState",
		"_ammoState",
		["_tJsonResult", ""]
	];

	private
	[
		"_statusFactor"
	];

	_statusFactor = ((_condition + _liveState + _ammoState) / 3);

	// Log the status using the JSON logger
	_playerGroup params
	[
		"_groupId",
		"_units"
	];

	private
	[
		"_jsonResult"
	];

	// Log the conditions
	_jsonResult = "";
	if (_logStatus) then
	{
		_jsonResult = ["BuildItems", [["GroupId", _groupId], ["Size", (count _units)], ["StatusFactor", _statusFactor], ["Condition", _tJsonResult, true]]] call SAEF_LOG_fnc_JsonLogger;
	};

	// Return the status factor
	[_statusFactor, _jsonResult]
};

/*
	-------------------
	-- GETCONDITIONS --
	-------------------

	Gets the conditions for a specified player group
*/
if (toUpper(_type) == "GETCONDITIONS") exitWith
{
	_params params
	[
		"_playerGroup",
		["_logStatus", false]
	];

	_playerGroup params
	[
		"_groupId",
		"_units"
	];

	private
	[
		"_condition",
		"_liveState",
		"_ammoState"
	];

	_condition = 0;
	_liveState = 0;
	_ammoState = 0;

	{
		(["GetCondition", [_x]] call SAEF_AID_fnc_Player) params
		[
			"_tCondition",
			"_tLiveState",
			"_tAmmoState"
		];

		_condition = _condition + _tCondition;
		_liveState = _liveState + _tLiveState;
		_ammoState = _ammoState + _tAmmoState;
	} forEach _units;

	// Adjust the variables to be factors at a squad level
	_condition = (_condition / (count _units));
	_liveState = (_liveState / (count _units));
	_ammoState = (_ammoState / (count _units));

	private
	[
		"_jsonResult"
	];

	// Log the conditions
	_jsonResult = "";
	if (_logStatus) then
	{
		_jsonResult = ["BuildItems", [["GeneralCondition", _condition], ["LiveState", _liveState], ["AmmoState", _ammoState]]] call SAEF_LOG_fnc_JsonLogger;
	};

	// Return our altered conditions
	[_condition, _liveState, _ammoState, _jsonResult]
};

/*
	------------------
	-- GETCONDITION --
	------------------

	Gets the condition for a specified player
*/
if (toUpper(_type) == "GETCONDITION") exitWith
{
	_params params
	[
		"_unit"
	];

	private
	[
		"_condition",
		"_liveState",
		"_ammoStatus"
	];

	_condition = 0;
	_liveState = 0;
	_ammoStatus = 0;

	// If the unit is alive
	if (alive _unit) then
	{
		if (_unit in ([true, true] call RS_PLYR_fnc_GetTruePlayers)) then
		{
			// Check if this unit is unconscious - will be zero if they're unconscious
			if (!(_unit getVariable ["ACE_isUnconscious", false])) then
			{
				// Raise to good condition
				_condition = 1;

				// Incrementally lower status based on open wounds
				private
				[
					"_openWounds"
				];

				_openWounds = _unit getVariable ["ace_medical_openWounds", []];

				{
					_condition = _condition - 0.05;
				} forEach _openWounds;

				// Condition cannot be worse than 0.05 if the unit is still conscious
				if (_condition < 0.05) then
				{
					_condition - 0.05;
				};
			};
		}
		else
		{
			// If this is AI, then we check their general damage
			_condition = 1 - (damage _unit);
		};
		
		// If this player is alive, easy set
		_liveState = 1;

		// Check this player's ammo
		_ammoStatus = ["CheckPlayerAmmo", [_unit]] call SAEF_AID_fnc_Player;
	};

	// Return our conditions
	[_condition, _liveState, _ammoStatus]
};

/*
	---------------------
	-- CHECKPLAYERAMMO --
	---------------------

	Checks the players ammo and returns a factor based on ammo count
*/
if (toUpper(_type) == "CHECKPLAYERAMMO") exitWith
{
	_params params
	[
		"_unit"
	];

	(["GetWeaponsAndAmmo", [_unit]] call SAEF_AID_fnc_Player) params 
	[
		"_currentWeapon",
		"_currentLauncher",
		"_currentPistol"
	];

	(["GetAmmoSetup"] call SAEF_AID_fnc_Difficulty) params
	[
		"_primaryWeaponAmmo",
		"_secondaryWeaponAmmo",
		"_launcherWeaponAmmo"
	];

	// Get the ammo factor for each weapon
	private
	[
		"_primaryWeaponAmmoFactor",
		"_secondaryWeaponAmmoFactor",
		"_launcherWeaponAmmoFactor",
		"_ammoFactor"
	];

	_primaryWeaponAmmoFactor = ["GetWeaponAmmoFactor", [_currentWeapon, _primaryWeaponAmmo]] call SAEF_AID_fnc_Player;
	_secondaryWeaponAmmoFactor = ["GetWeaponAmmoFactor", [_currentPistol, _secondaryWeaponAmmo]] call SAEF_AID_fnc_Player;
	_launcherWeaponAmmoFactor = ["GetWeaponAmmoFactor", [_currentLauncher, _launcherWeaponAmmo]] call SAEF_AID_fnc_Player;

	_ammoFactor = ((_primaryWeaponAmmoFactor + _secondaryWeaponAmmoFactor + _launcherWeaponAmmoFactor) / 3);

	// Return our ammo factor
	_ammoFactor
};

/*
	-------------------------
	-- GETWEAPONAMMOFACTOR --
	-------------------------

	Gets the weapons ammo factor
*/
if (toUpper(_type) == "GETWEAPONAMMOFACTOR") exitWith
{
	_params params
	[
		"_currentWeapon",
		"_weaponAmmo"
	];

	// If we don't have this weapon, the ammo factor is automatically 1
	if (_currentWeapon isEqualTo []) exitWith
	{
		1
	};

	_currentWeapon params
	[
		"_weaponClassName",
		"_weaponCurrentAmmo"
	];

	private
	[
		"_weaponAmmoFactor"
	];

	[_scriptTag, 4, (format ["[GETWEAPONAMMOFACTOR] Weapon [%1], current ammo [%2], recommended ammo [%3]", _weaponClassName, _weaponCurrentAmmo, _weaponAmmo])] call RS_fnc_LoggingHelper;

	_weaponAmmoFactor = (_weaponCurrentAmmo / _weaponAmmo);

	if (_weaponAmmoFactor > 1) then
	{
		_weaponAmmoFactor = 1;
	};

	// Return the weapon ammo factor
	_weaponAmmoFactor
};

/*
	-----------------------
	-- GETWEAPONSANDAMMO --
	-----------------------

	Gets the players weapons and ammo
*/
if (toUpper(_type) == "GETWEAPONSANDAMMO") exitWith
{
	_params params
	[
		"_unit"
	];

	// Get unit loadout
	(getUnitLoadout _unit) params
	[
		["_weapon", []],
		["_launcher", []],
		["_pistol", []],
		["_uniform", []],
		["_vest", []],
		["_backpack", []],
		["_helmet", ""],
		["_goggles", ""],
		["_binoculars", []],
		["_linkedItems", []]
	];

	private
	[
		"_currentWeapon",
		"_currentLauncher",
		"_currentPistol"
	];

	_currentWeapon = ["GetWeaponSetup", [_weapon]] call SAEF_AID_fnc_Player;
	_currentLauncher = ["GetWeaponSetup", [_launcher]] call SAEF_AID_fnc_Player;
	_currentPistol = ["GetWeaponSetup", [_pistol]] call SAEF_AID_fnc_Player;

	
	if (!(_currentWeapon isEqualTo [])) then
	{
		_currentWeapon = (["GetAmmoFromContainer", [_uniform, _currentWeapon]] call SAEF_AID_fnc_Player);
		_currentWeapon = (["GetAmmoFromContainer", [_vest, _currentWeapon]] call SAEF_AID_fnc_Player);
		_currentWeapon = (["GetAmmoFromContainer", [_backpack, _currentWeapon]] call SAEF_AID_fnc_Player);
	};
	
	if (!(_currentLauncher isEqualTo [])) then
	{
		_currentLauncher = (["GetAmmoFromContainer", [_uniform, _currentLauncher]] call SAEF_AID_fnc_Player);
		_currentLauncher = (["GetAmmoFromContainer", [_vest, _currentLauncher]] call SAEF_AID_fnc_Player);
		_currentLauncher = (["GetAmmoFromContainer", [_backpack, _currentLauncher]] call SAEF_AID_fnc_Player);
	};
	
	if (!(_currentPistol isEqualTo [])) then
	{
		_currentPistol = (["GetAmmoFromContainer", [_uniform, _currentPistol]] call SAEF_AID_fnc_Player);
		_currentPistol = (["GetAmmoFromContainer", [_vest, _currentPistol]] call SAEF_AID_fnc_Player);
		_currentPistol = (["GetAmmoFromContainer", [_backpack, _currentPistol]] call SAEF_AID_fnc_Player);
	};

	// Return our weapons and their ammo
	[
		_currentWeapon,
		_currentLauncher,
		_currentPistol
	]
};

/*
	--------------------
	-- GETWEAPONSETUP --
	--------------------

	Gets the weapon setup from given weapon
*/
if (toUpper(_type) == "GETWEAPONSETUP") exitWith
{
	_params params
	[
		"_weapon"
	];

	if (_weapon isEqualTo []) exitWith 
	{
		[]
	};

	private
	[
		"_weaponParams",
		"_magazineParams",
		"_currentWeapon"
	];

	_weaponParams =
	[
		"_weaponClassName",
		"_weaponMuzzleAttachment",
		"_weaponSideAttachment",
		"_weaponOpticAttachment",
		"_weaponMagazinePrimary",
		"_weaponMagazineSecondary",
		"_weaponBipodAttachment"
	];

	_magazineParams = 
	[
		"_magazineClassName",
		"_magazineAmmoCount"
	];

	_currentWeapon = [];

	_weapon params _weaponParams;

	// Add the classname to the weapon
	_currentWeapon pushBack _weaponClassName;

	// Add the ammo count to the weapon
	if (!(_weaponMagazinePrimary isEqualTo [])) then
	{
		_weaponMagazinePrimary params _magazineParams;
		_currentWeapon pushBack _magazineAmmoCount;
		_currentWeapon pushBack [_magazineClassName];
	}
	else
	{
		_currentWeapon pushBack 0;
	};

	// Return the weapon
	_currentWeapon
};

/*
	---------------------------
	-- GETPLAYERLAUNCHERTYPE --
	---------------------------

	Determines whether a group of players has a specific launcher type
*/
if (toUpper(_type) == "GETPLAYERLAUNCHERTYPE") exitWith
{
	_params params
	[
		"_position"
	];

	(["GetPlayerGroup", [_position]] call SAEF_AID_fnc_Player) params
	[
		"_groupId",
		"_units"
	];

	private
	[
		"_hasAntiAir",
		"_hasAntiTank"
	];

	_hasAntiAir = false;
	_hasAntiTank = false;

	{
		private
		[
			"_unit"
		];

		_unit = _x;

		(["GetWeaponsAndAmmo", [_unit]] call SAEF_AID_fnc_Player) params 
		[
			"_currentWeapon",
			"_currentLauncher",
			"_currentPistol"
		];

		if (!(_currentLauncher isEqualTo [])) then
		{
			_currentLauncher params
			[
				"_weaponClassname",
				"_weaponAmmo",
				"_weaponMagazines"
			];

			{
				if (_x isKindOf ["CA_LauncherMagazine", configFile >> "CfgMagazines"]) exitWith
				{
					if (_x isKindOf ["Titan_AA", configFile >> "CfgMagazines"]) then
					{
						_hasAntiAir = true;
					}
					else
					{
						_hasAntiTank = true;
					};
				};
			} forEach _weaponMagazines;
		};
	} forEach _units;

	// Return launcher status
	[
		_hasAntiAir,
		_hasAntiTank
	]
};

/*
	--------------------------
	-- GETAMMOFROMCONTAINER --
	--------------------------

	Gets the ammo for a weapon from the container
*/
if (toUpper(_type) == "GETAMMOFROMCONTAINER") exitWith
{
	_params params
	[
		"_container",
		"_weapon"
	];

	_weapon params
	[
		"_weaponClassName",
		"_weaponCurrentAmmo",
		["_weaponMagazines", []]
	];

	if (_container isEqualTo []) exitWith 
	{
		[_weaponClassName, _weaponCurrentAmmo, _weaponMagazines]
	};

	private
	[
		"_containerItemParams"
	];

	_containerItemParams = 
	[
		"_containerItemClassName",
		"_containerItemCount",
		["_containerItemAmmoCount", 0]
	];

	_container params
	[
		"_containerClassName",
		"_containerItems"
	];

	{
		_x params _containerItemParams;

		if (_containerItemAmmoCount > 0) then
		{
			private
			[
				"_compatibleMagazines"
			];

			_compatibleMagazines = ([_weaponClassName] call BIS_fnc_compatibleMagazines);

			if (toLower(_containerItemClassName) in _compatibleMagazines) then
			{
				_weaponCurrentAmmo = _weaponCurrentAmmo + (_containerItemCount * _containerItemAmmoCount);
				_weaponMagazines pushBackUnique toLower(_containerItemClassName);
			};
		};
	} forEach _containerItems;

	// Return weapon
	[_weaponClassName, _weaponCurrentAmmo, _weaponMagazines]
};

/*
	--------------------
	-- GETPLAYERGROUP --
	--------------------

	Gets the closest player group (players within 69 meters of one another) to the given position
*/
if (toUpper(_type) == "GETPLAYERGROUP") exitWith
{
	_params params
	[
		"_position"
	];

	private
	[
		"_playerGroups",
		"_closestDistance",
		"_selectedGroup"
	];

	_playerGroups = ["GetAllPlayerGroups"] call SAEF_AID_fnc_Player;
	_closestDistance = 999999;

	{
		_x params
		[
			"_groupId",
			"_units"
		];

		{
			private
			[
				"_distance"
			];

			_distance = (_x distance _position);

			if (_distance < _closestDistance) then
			{
				_closestDistance = _distance;
				_selectedGroup = [_groupId, _units];
			};
		} forEach _units;
	} forEach _playerGroups;

	// Return the selected group
	_selectedGroup
};

/*
	------------------------
	-- GETALLPLAYERGROUPS --
	------------------------

	Gets all player groups (players within 69 meters of one another)
*/
if (toUpper(_type) == "GETALLPLAYERGROUPS") exitWith
{
	// Singleplayer debug
	private
	[
		"_players"
	];

	_players = ([true, true] call RS_PLYR_fnc_GetTruePlayers);

	if (isServer && hasInterface) then
	{
		_players = [];

		{
			if ((side _x) == (side player)) then
			{
				_players pushBackUnique _x;
			};
		} forEach allUnits;
	};

	// Get the first pass of units and create a dictionary for them
	(["PlayerGroupsFirstPass", [_players]] call SAEF_AID_fnc_Player) params
	[
		"_separateUnits",
		"_unitKeys"
	];

	// Second pass array joining
	(["PlayerGroupsSecondPass", [_separateUnits, _unitKeys]] call SAEF_AID_fnc_Player) params
	[
		"_secondPassSeparateUnits"
	];

	// Get the player groups after array passes
	(["GetPlayerGroupsWithPasses", [_secondPassSeparateUnits, _unitKeys]] call SAEF_AID_fnc_Player) params
	[
		"_playerGroups"
	];

	// Return the player groups
	_playerGroups
};

/*
	---------------------------
	-- PLAYERGROUPSFIRSTPASS --
	---------------------------

	Does the first array pass for sorting player groups
*/
if (toUpper(_type) == "PLAYERGROUPSFIRSTPASS") exitWith
{
	_params params
	[
		"_players"
	];
	
	private
	[
		"_separateUnits",
		"_unitKeys"
	];

	_separateUnits = [];
	_unitKeys = [];

	{
		private
		[
			"_unit"
		];

		_unit = _x;

		_separateUnits pushBackUnique (format ["%1", _unit]);
		_unitKeys pushBackUnique [(format ["%1", _unit]), _unit];
	} forEach _players;

	// Return our items
	[_separateUnits, _unitKeys]
};

/*
	----------------------------
	-- PLAYERGROUPSSECONDPASS --
	----------------------------

	Does the second array pass for sorting player groups
*/
if (toUpper(_type) == "PLAYERGROUPSSECONDPASS") exitWith
{
	_params params
	[
		"_separateUnits",
		"_unitKeys"
	];

	private
	[
		"_secondPassSeparateUnits"
	];

	_secondPassSeparateUnits = [];

	while {!(_separateUnits isEqualTo [])} do
	{
		private
		[
			"_groupOfUnits"
		];

		_groupOfUnits = ["PlayerGroupsSecondPass_UOW", [[(_separateUnits select 0)], _separateUnits, _unitKeys]] call SAEF_AID_fnc_Player;
		_separateUnits = _separateUnits - _groupOfUnits;

		_groupOfUnits sort true;
		_secondPassSeparateUnits pushBack _groupOfUnits;
	};

	// Return the units
	[_secondPassSeparateUnits]
};

/*
	--------------------------------
	-- PLAYERGROUPSSECONDPASS_UOW --
	--------------------------------

	Conducts the recursive unit of work for the second pass
*/
if (toUpper(_type) == "PLAYERGROUPSSECONDPASS_UOW") exitWith
{
	_params params
	[
		"_groupOfUnits",
		"_players",
		"_unitKeys"
	];

	private
	[
		"_controlGroup"
	];

	_controlGroup = _groupOfUnits;

	{
		// Setup player object
		private
		[
			"_player",
			"_playerObject"
		];

		_player = _x;
		_playerObject = ["GetItemFromDictionary", [_player, _unitKeys]] call SAEF_AID_fnc_Player;

		// Alter the given players to ensure we don't test against duplicates
		_players = _players - _groupOfUnits;

		{
			private
			[
				"_tempPlayer"
			];

			_tempPlayer = _x;

			// Fetch the actual object
			private
			[
				"_tempPlayerObject"
			];

			_tempPlayerObject = ["GetItemFromDictionary", [_tempPlayer, _unitKeys]] call SAEF_AID_fnc_Player;

			// Evaluate distance
			if ((_tempPlayerObject distance _playerObject) <= 69) then
			{
				_groupOfUnits pushBackUnique _tempPlayer;
			};
		} forEach _players;
	} forEach _groupOfUnits;

	// Recursive call
	if (!(_groupOfUnits isEqualTo _controlGroup)) then
	{	
		_groupOfUnits = ["PlayerGroupsSecondPass_UOW", [_groupOfUnits, _players, _unitKeys]] call SAEF_AID_fnc_Player;
	};

	// Return the group of units
	_groupOfUnits
};

/*
	-------------------------------
	-- GETPLAYERGROUPSWITHPASSES --
	-------------------------------

	Gets the player groups once all passes are complete
*/
if (toUpper(_type) == "GETPLAYERGROUPSWITHPASSES") exitWith
{
	_params params
	[
		"_secondPassSeparateUnits",
		"_unitKeys"
	];

	private
	[
		"_groupUnits"
	];

	_groupUnits = (_secondPassSeparateUnits arrayIntersect _secondPassSeparateUnits);

	// Turn them into the groups
	private
	[
		"_playerGroups"
	];

	_playerGroups = [];

	{
		private
		[
			"_objects"
		];

		_objects = [];

		{
			private
			[
				"_unitString"
			];

			_objects pushBackUnique (["GetItemFromDictionary", [_x, _unitKeys]] call SAEF_AID_fnc_Player);
		} forEach _x;

		_playerGroups pushBack [(_foreachIndex + 1), _objects];
	} forEach _groupUnits;

	// Return the player groups
	[_playerGroups]
};

/*
	---------------------------
	-- GETITEMFROMDICTIONARY --
	---------------------------

	Gets an item from the given dictionary based on the key
*/
if (toUpper(_type) == "GETITEMFROMDICTIONARY") exitWith
{
	_params params
	[
		"_key",
		"_array"
	];
	
	private
	[
		"_object"
	];

	_object = objNull;

	{
		_x params
		[
			"_arrayKey",
			"_arrayObj"
		];

		if (_key == _arrayKey) then
		{
			_object = _arrayObj;
		};
	} forEach _array;

	// Return the object
	_object
};

// Log warning if type is not recognised
[_scriptTag, 2, (format ["Unrecognised type [%1], nothing is being executed!", _type])] call RS_fnc_LoggingHelper;