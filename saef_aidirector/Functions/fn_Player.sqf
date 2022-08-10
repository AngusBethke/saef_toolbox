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
	---------------------------
	-- GETPLAYERSTATUSFACTOR --
	---------------------------

	Gets the player status factor based on the group closest to the given position
*/
if (toUpper(_type) == "GETPLAYERSTATUSFACTOR") exitWith
{
	_params params
	[
		"_position"
	];

	(["GetConditions", [(["GetPlayerGroup", [_position]] call SAEF_AID_fnc_Player)]] call SAEF_AID_fnc_Player) params
	[
		"_condition",
		"_liveState",
		"_ammoState"
	];

	private
	[
		"_statusFactor"
	];

	_statusFactor = ((_condition + _liveState + _ammoState) / 2);

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
		"_playerGroup"
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
		// Check if this unit is unconcious
		if (!(_unit getVariable ["ACE_isUnconscious", false])) then
		{
			
		}
		else
		{

		};
			
		// If this player is alive, easy set
		_liveState = 1;

		// Check this player's ammo
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
		"_uniform",
		"_backpack",
		"_linkedItems",
		"_weapons",
		"_items",
		"_magazines"
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

	private
	[
		"_ammoFactor"
	];

	// TODO: Move this to missionNamespace variable - 227
	[180, 45, 2] params
	[
		"_primaryWeaponAmmo",
		"_secondaryWeaponAmmo",
		"_launcherWeaponAmmo"
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
				_players pushBackUnique _players;
			};
		} forEach allUnits;
	};

	// Separate the players out into groups
	private
	[
		"_groupUnits"
	]

	_groupUnits = [];

	{
		private
		[
			"_unit",
			"_tempGroupUnits"
		];

		_unit = _x;
		_tempGroupUnits = _groupUnits;

		// If this is the first player we're evaluating
		if (_groupUnits isEqualTo []) then
		{
			_groupUnits pushBack [_unit];
		}
		else
		{
			// We iterate into the group now to ensure we evaluate the current unit against every possible unit in the array
			{
				private
				[
					"_subUnits",
					"_subUnitIndex"
				];

				_subUnits = _x;
				_subUnitIndex = _forEachIndex;

				{
					private
					[
						"_subUnit"
					];

					_subUnit = _x;

					if (_unit != _subUnit) then
					{
						if ((_unit distance _subUnit) <= 69) then
						{
							_subUnits pushBack _unit;
						};
					};
				} forEach _subUnits;

				_groupUnits set [_subUnitIndex, _subUnits];
			} forEach _tempGroupUnits;
		};
	} forEach _players;

	private
	[
		"_playerGroups"
	];

	_playerGroups = [];

	{
		_playerGroups pushBack [(_foreachIndex + 1), _x];
	} forEach _groupUnits;

	// Return the player groups
	_playerGroups
};

// Log warning if type is not recognised
["SAEF_AID_fnc_Player", 2, (format ["Unrecognised type [%1], nothing is being executed!", _type])] call RS_fnc_LoggingHelper;