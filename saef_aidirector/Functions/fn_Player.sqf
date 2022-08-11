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

	{
		_statusFactor = _statusFactor + (["GetGroupStatusFactor", [_x, true]] call SAEF_AID_fnc_Player);
	} forEach _playerGroups;

	// Divide status factor by number of groups
	_statusFactor = (_statusFactor / (count _playerGroups));

	// Log the status using the JSON logger
	if (_logStatus) then
	{
		["LogItem", ["OverallStatusFactor", _statusFactor]] call SAEF_LOG_fnc_JsonLogger;
	};

	// Return the status factor
	_statusFactor
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
		"_position"
	];

	// Return the status factor
	(["GetGroupStatusFactor", [(["GetPlayerGroup", [_position]] call SAEF_AID_fnc_Player)]] call SAEF_AID_fnc_Player)
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
		"_ammoState"
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

	if (_logStatus) then
	{
		["LogItems", [["GroupId", _groupId], ["GroupSize", (count _units)], ["GroupStatusFactor", _statusFactor]]] call SAEF_LOG_fnc_JsonLogger;
	};

	// Return the status factor
	_statusFactor
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

	// Log the conditions
	if (_logStatus) then
	{
		["LogItems", [["GroupId", _groupId], ["GroupSize", (count _units)], ["GroupCondition", _condition], ["GroupLiveState", _liveState], ["GroupAmmoState", _ammoState]]] call SAEF_LOG_fnc_JsonLogger;
	};

	// Return our altered conditions
	[_condition, _liveState, _ammoState]
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

	// Get unit loadout
	(getUnitLoadout _unit) params
	[
		"_weapon",
		"_launcher",
		"_pistol",
		"_uniform",
		"_vest",
		"_backpack",
		"_helmet",
		"_goggles"
	];

	private
	[
		"_totalAmmoCount"
	];

	_totalAmmoCount = 0;

	// Evaluate unit weapons
	{
		private
		[
			"_weapon"
		];

		_weapon = _x;

		{
			_x params
			[
				"_magazine",
				"_ammoCount"
			];

			if (_magazine in ([_weapon] call BIS_fnc_compatibleMagazines)) then
			{
				_totalAmmoCount = _totalAmmoCount + _ammoCount;
			};
		} forEach _magazines;
	} forEach _weapons;

	(["GetAmmoSetup"] call SAEF_AID_fnc_Difficulty) params
	[
		"_primaryWeaponAmmo",
		"_secondaryWeaponAmmo",
		"_launcherWeaponAmmo"
	];

	private
	[
		"_ammoFactor"
	];

	if (_totalAmmoCount != 0) then
	{
		_ammoFactor = _totalAmmoCount / (_primaryWeaponAmmo + _secondaryWeaponAmmo + _launcherWeaponAmmo);
	};

	// Clamp the factor to 1
	if (_ammoFactor > 1) then
	{
		_ammoFactor = 1;
	};

	// Return our ammo factor
	_ammoFactor
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
				_selectedGroup = _units;
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

	// Third pass array joining
	(["PlayerGroupsThirdPass", [_secondPassSeparateUnits]] call SAEF_AID_fnc_Player) params
	[
		"_thirdPassSeparateUnits"
	];

	// Get the player groups after array passes
	(["GetPlayerGroupsWithPasses", [_thirdPassSeparateUnits, _unitKeys]] call SAEF_AID_fnc_Player) params
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

		_separateUnits pushBackUnique [(format ["%1", _unit])];
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
		"_passUnits"
	];

	_passUnits = [];

	{
		private
		[
			"_units"
		];

		_units = [];

		{
			private
			[
				"_unit"
			];

			_unit = _x;
			_units pushBackUnique _unit;

			{
				private
				[
					"_xString"
				];

				_xString = (format ["%1", _x]);

				if (_unit != _xString) then
				{
					// Fetch the actual object
					private
					[
						"_unitObject",
						"_xObject"
					];

					_unitObject = ["GetItemFromDictionary", [_unit, _unitKeys]] call SAEF_AID_fnc_Player;
					_xObject = ["GetItemFromDictionary", [_xString, _unitKeys]] call SAEF_AID_fnc_Player;

					// Evaluate distance
					if ((_unitObject distance _xObject) <= 69) then
					{
						_units pushBackUnique _xString;
					};
				};
			} forEach _players;
		} forEach _x;

		_units sort true;
		_passUnits pushBackUnique (_units arrayIntersect _units);
	} forEach _separateUnits;

	// Return the pass units
	[_passUnits]
};

/*
	----------------------------
	-- PLAYERGROUPSTHIRDPASS --
	----------------------------

	Does the third array pass for sorting player groups
*/
if (toUpper(_type) == "PLAYERGROUPSTHIRDPASS") exitWith
{
	_params params
	[
		"_secondPassSeparateUnits"
	];

	private
	[
		"_passUnits"
	];

	_passUnits = [];

	{
		private
		[
			"_units",
			"_newUnits"
		];

		_units = _x;
		_newUnits = _units;

		{
			private
			[
				"_subUnits"
			];

			_subUnits = _x;

			if (!(_units isEqualTo _subUnits)) then
			{
				{
					if (_x in _subUnits) then
					{
						_newUnits = _newUnits + _subUnits;
					};
				} forEach _units;
			};
		} forEach _secondPassSeparateUnits;

		_newUnits sort true;
		_passUnits pushBackUnique (_newUnits arrayIntersect _newUnits);
	} forEach _secondPassSeparateUnits;

	// Return the pass units
	[_passUnits]
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
		"_thirdPassSeparateUnits",
		"_unitKeys"
	];

	private
	[
		"_groupUnits"
	];

	_groupUnits = (_thirdPassSeparateUnits arrayIntersect _thirdPassSeparateUnits);

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
["SAEF_AID_fnc_Player", 2, (format ["Unrecognised type [%1], nothing is being executed!", _type])] call RS_fnc_LoggingHelper;