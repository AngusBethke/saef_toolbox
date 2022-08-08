/*
	fn_Gear.sqf

	Description:
		Handles gear and the actions for that gear
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
		["INIT"] call SAEF_LRRP_fnc_Gear;
*/
if (toUpper(_type) == "INIT") exitWith
{
	player addEventHandler ["Put", {
		params ["_unit", "_container", "_item"];
		["Gear_Action", [_unit, _container, _item]] call SAEF_LRRP_fnc_Gear;
	}];
};

/*
	------------------
	-- SET_BACKPACK --
	------------------

	This method handles the setting of backpack type

	Calling:
		["SET_BACKPACK", ["loadout_sl"]] call SAEF_LRRP_fnc_Gear;
*/
if (toUpper(_type) == "SET_BACKPACK") exitWith
{
	_params params
	[
		"_id"
	];

	private
	[
		"_backpack"
	];
	
	_backpack = unitBackpack player;
	_backpack setVariable ["SAEF_LRRP_LoadoutId", _id, true];
	player setVariable ["SAEF_LRRP_Backpack", _backpack, true];
};

/*
	-----------------
	-- GEAR_ACTION --
	-----------------

	Called by an event handler, this handles the creation of ace interactions for the gear
*/
if (toUpper(_type) == "GEAR_ACTION") exitWith
{
	_params params 
	[
		"_unit", 
		"_container", 
		"_item"
	];

	private
	[
		"_backpack"
	];

	_backpack = player getVariable ["SAEF_LRRP_Backpack", objNull];

	// If this is not the backpack, we're going to ignore it
	if (typeOf _backpack != _item) exitWith {};

	private 
	[
		"_id"
	];

	_id = _backpack getVariable ["SAEF_LRRP_LoadoutId", ""];

	if (_id != "") then
	{
		{
			_x params
			[
				"_loadoutId",
				"_loadout",
				"_loadoutName",
				"_loadoutHasBergen",
				"_loadoutGearActions"
			];

			if (_loadoutId == _id) then
			{
				private
				[
					"_parentAction"
				];

				["SAEF_LRRP_fnc_Gear", 3, "Adding gear actions to container..."] call RS_fnc_LoggingHelper;

				_parentAction = ["SAEF_LRRP_Action", "Gear", "", {}, {true}, {}, [], [0,0,0], 100] call ace_interact_menu_fnc_createAction;
				[_container, 0, ["ACE_MainActions"], _parentAction] call ace_interact_menu_fnc_addActionToObject;

				{
					_x params
					[
						"_gearId",
						"_gearName",
						"_gearItems"
					];

					private
					[
						"_action"
					];

					["SAEF_LRRP_fnc_Gear", 3, (format ["Adding gear action [%1] to container [%2]...", _gearName, _container])] call RS_fnc_LoggingHelper;

					_action = [(format ["SAEF_LRRP_Action_%1", _gearId]), (format ["Unpack %1", _gearName]), "",
						{
							params ["_target", "_player", "_params"];
							_params params
							[
								"_type",
								"_gearParams"
							];

							_gearParams params
							[
								"_backpack", 
								"_gearId", 
								"_gearItems",
								"_gearName"
							];

							// Ensure that we cannot unpack the same item twice
							_backpack setVariable [(format ["SAEF_LRRP_HasUnpacked_%1", _gearId]), true, true];

							_params spawn SAEF_LRRP_fnc_Gear;
						},
						{
							params ["_target", "_player", "_params"];
							_params params
							[
								"_type",
								"_gearParams"
							];

							_gearParams params
							[
								"_backpack", 
								"_gearId", 
								"_gearItems",
								"_gearName"
							];

							// Ensure that we cannot unpack the same item twice
							!(_backpack getVariable [(format ["SAEF_LRRP_HasUnpacked_%1", _gearId]), false])
						}, 
						{}, ["Gear", [_backpack, _gearId, _gearItems, _gearName]], [0,0,0], 100
					] call ace_interact_menu_fnc_createAction;			

					[_container, 0, ["ACE_MainActions", "SAEF_LRRP_Action"], _action] call ace_interact_menu_fnc_addActionToObject;
				} forEach _loadoutGearActions;
			};
		} forEach (missionNamespace getVariable ["SAEF_LRRP_Loadouts", []]);
	};
};

/*
	----------
	-- GEAR --
	----------

	Called by the ace actions created in the init method, this method handles the creation of items 
	as defined in the configuration for this ace interaction
*/
if (toUpper(_type) == "GEAR") exitWith
{
	_params params
	[
		"_backpack",
		"_gearId",
		"_gearItems",
		"_gearName"
	];

	private
	[
		"_item",
		"_itemToSpawn"
	];

	hint (format ["Unpacking %1", _gearName]);

	sleep 3;

	playSound3D [(["Bag3D"] call SAEF_LRRP_fnc_Sounds), player, false, (getPosASL player), 5, 1, 100];

	sleep 1;

	_item = "groundweaponholder" createVehicle (getpos player);

	{
		_x params
		[
			"_itemClassname",
			"_itemCount",
			"_itemType"
		];

		_itemToSpawn = "";

		if ((typeName _itemClassname) == "STRING") then
		{
			_itemToSpawn = _itemClassname;
		};

		if ((typeName _itemClassname) == "ARRAY") then
		{
			_itemToSpawn = (selectRandom _itemClassname);
		};

		if (_itemToSpawn != "") then
		{
			if (toUpper(_itemType) == "ITEM") then
			{
				_item addItemCargoGlobal [_itemToSpawn, _itemCount];
			};
			
			if (toUpper(_itemType) == "WEAPON") then
			{
				_item addWeaponCargoGlobal [_itemToSpawn, _itemCount];
			};
			
			if (toUpper(_itemType) == "MAGAZINE") then
			{
				_item addMagazineCargoGlobal [_itemToSpawn, _itemCount];
			};
			
			if (toUpper(_itemType) == "BACKPACK") then
			{
				_item addBackpackCargoGlobal [_itemToSpawn, _itemCount];
			};
		}
		else
		{
			["SAEF_LRRP_fnc_Gear", 2, (format ["[GEAR] Cannot determine type for [%1], nothing will be spawned!", _itemClassname])] call RS_fnc_LoggingHelper;
		};
	} forEach _gearItems;

	_item setPos (player modelToWorld [0,1,0]);
};

/*
	---------------------
	-- GENERATE_CONFIG --
	---------------------

	Called manually to generate the configuration for gear
*/
if (toUpper(_type) == "GENERATE_CONFIG") exitWith
{
	_params params
	[
		"_header",
		"_items"
	];

	private
	[
		"_recognisedItemTypes",
		"_errorMessage"
	];

	_recognisedItemTypes = ["BACKPACK", "ITEM", "MAGAZINE", "WEAPON"];
	_errorMessage = "";

	{
		_x params
		[
			"_itemClassName",
			"_itemCount",
			"_itemType"
		];

		if (!(toUpper(_itemType) in _recognisedItemTypes)) then
		{
			_errorMessage = (format ["Unrecognised item type [%1] in config generation for header [%2]", _itemType, _header]);
			["SAEF_LRRP_fnc_Gear", 1, _errorMessage] call RS_fnc_LoggingHelper;
		};
	} forEach _items;

	if (_errorMessage != "") exitWith
	{
		// Return empty array
		[]
	};

	private
	[
		"_configSection"
	];

	_configSection = 
	[
		(["ID_FROM_HEADER", [_header]] call SAEF_LRRP_fnc_Gear),
		_header,
		_items
	];

	// Return the config section
	_configSection
};

/*
	---------------------------
	-- GENERATE_CONFIG_MULTI --
	---------------------------

	Called manually to generate multiple configurations for gear
*/
if (toUpper(_type) == "GENERATE_CONFIG_MULTI") exitWith
{
	_params params
	[
		"_header",
		"_count",
		"_items"
	];

	private
	[
		"_multiConfigSection"
	];

	_multiConfigSection = [];

	for "_i" from 1 to _count do
	{
		private
		[
			"_augmentedConfigSection"
		];

		(["GENERATE_CONFIG", [_header, _items]] call SAEF_LRRP_fnc_Gear) params
		[
			"_configSectionId",
			"_configSectionHeader",
			"_configSectionItems"
		];

		_augmentedConfigSection = 
		[
			(format ["%1_%2", _configSectionId, _i]),
			_configSectionHeader,
			_configSectionItems
		];

		_multiConfigSection pushBack _augmentedConfigSection;
	};

	// Return the multi config section
	_multiConfigSection
};



/*
	-----------------------------
	-- GENERATE_LOADOUT_CONFIG --
	-----------------------------

	Called manually to generate the configuration for a loadout
*/
if (toUpper(_type) == "GENERATE_LOADOUT_CONFIG") exitWith
{
	_params params
	[
		"_header",
		"_script",
		"_gearConfigSections"
	];

	_configSection = 
	[
		(format["loadout_%1", (["ID_FROM_HEADER", [_header]] call SAEF_LRRP_fnc_Gear)]),
		_script,
		_header,
		true,
		_gearConfigSections
	];

	// Return the config section
	_configSection
};

/*
	--------------------
	-- ID_FROM_HEADER --
	--------------------

	Called by generate config to safely generate an id from the header
*/
if (toUpper(_type) == "ID_FROM_HEADER") exitWith
{
	_params params
	[
		"_header"
	];

	private
	[
		"_id"
	];

	_id = toLower((_header splitString "-,. ") joinString "_");

	// Return the id
	_id
};

// Log warning if type is not recognised
["SAEF_LRRP_fnc_Gear", 2, (format ["Unrecognised type [%1], nothing is being executed!", _type])] call RS_fnc_LoggingHelper;