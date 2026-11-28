/*
	Moved to saef_toolbox from the SAEF Mission Framework (Scripts\Vehicle\SpawnDriverAI.sqf).
*/

/*
	SpawnDriverAI.sqf

	Description:
		Creates AI driver for specified vehicle

	How to call:
		["AddAction", "B_Helo_F", "B_crew_F", true] spawn SAEF_VEH_fnc_SpawnDriverAI;
		["AddDriver", (vehicle player), _crewType, _execLoadout] spawn SAEF_VEH_fnc_SpawnDriverAI;
*/

params
[
	"_type",
	"_vehicle",
	"_crewType",
	"_execLoadout"
];

if (toUpper(_type) == "ADDACTION") exitWith
{
	private
	[
		"_action"
	];

	_action = ["SAEF_AddAiDriver", "Add AI Driver", "", 
		{
			params ["_target", "_player", "_params"];
			_params params ["_vehicle", "_crewType", "_execLoadout"];

			// Execute the script
			["AddDriver", (vehicle player), _crewType, _execLoadout] spawn SAEF_VEH_fnc_SpawnDriverAI;
		}, 
		{
			params ["_target", "_player", "_params"];
			_params params ["_vehicle", "_crewType", "_execLoadout"];

			// Condition: Player is commander of vehicle
			(((commander (vehicle player)) == player) && ((typeOf (vehicle player)) in _vehicle))
		}, 
		{}, [_vehicle, _crewType, _execLoadout]
	] call ace_interact_menu_fnc_createAction;

	[player, 1, ["ACE_SelfActions"], _action, true] call ace_interact_menu_fnc_addActionToObject;
};

if (toUpper(_type) == "ADDDRIVER") exitWith
{
	private
	[
		"_createUnitCode"
	];

	_createUnitCode = {
		params
		[
			"_unitType",
			"_side",
			"_position"
		];

		private
		[
			"_group",
			"_unit"
		];

		_group = createGroup [_side, true];
		_unit = _group createUnit [_unitType, _position, [], 0, "FORM"];

		_unit
	};

	if (isNull (driver _vehicle)) then
	{
		private
		[
			"_driver"
		];

		// Create the new unit and move it into the driver seat
		_driver = [_crewType, (side player), (getPos _vehicle)] call _createUnitCode;
		_driver moveInDriver _vehicle;

		// Give the unit the correct loadout
		if (_execLoadout) then
		{
			[_driver] execVM "Loadouts\Core.sqf";
		};
	}
	else
	{
		private
		[
			"_driver"
		];

		_driver = (driver _vehicle);

		// If the driver is not a player
		if (!(isPlayer _driver)) then
		{
			// If this is not local
			if (!(local _driver)) then
			{
				// Delete the driver
				deleteVehicle _driver;

				// Create the new unit and move it into the driver seat
				_driver = [_crewType, (side player), (position _vehicle)] call _createUnitCode;
				_driver moveInDriver _vehicle;

				// Give the unit the correct loadout
				if (_execLoadout) then
				{
					[_driver] execVM "Loadouts\Core.sqf";
				};
			};
		};
	};
};