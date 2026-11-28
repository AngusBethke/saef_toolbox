/*
	fn_DeploymentBeacon.sqf

	Description:
		Handles actions related to the deployment beacon

	How to Call:
		[_type, _beacon] call SAEF_ASA_fnc_DeploymentBeacon;
*/

params
[
	"_type",
	"_beacon"
];

if (toUpper(_type) == "DEPLOY") then
{
	_beacon params
	[
		"_beaconObj",
		"_beaconName",
		"_deployPara"
	];

	private
	[
		"_position",
		"_direction"
	];

	_position = (player getRelPos [1, 0]);
	_direction = (getDir player);

	["SAEF_ASA_INS_Queue", [_beaconObj, _beaconName, _deployPara, _position, _direction], "SAEF_ASA_fnc_HandleDeploymentBeaconPlacement"] call RS_MQ_fnc_MessageEnqueue;
};

if (toUpper(_type) == "DEPLOYNOPLAYER") then
{
	_beacon params
	[
		"_beaconObj",
		"_beaconName",
		"_deployPara",
		"_position",
		"_direction"
	];

	["SAEF_ASA_INS_Queue", [_beaconObj, _beaconName, _deployPara, _position, _direction], "SAEF_ASA_fnc_HandleDeploymentBeaconPlacement"] call RS_MQ_fnc_MessageEnqueue;
};

if (toUpper(_type) == "DEPLOYACTION") then
{
	_beacon params
	[
		"_beaconObjString",
		"_beaconName",
		["_deployPara", false]
	];

	if (isNil _beaconObjString) exitWith 
	{
		["SAEF_ASA_fnc_DeploymentBeacon", 1, (format ["Cannot add action for deploy beacon [%1] that doesn't exist!", _beaconObjString])] call RS_fnc_LoggingHelper;
	};

	private
	[
		"_beaconObj",
		"_action"
	];

	// Parse the object
	_beaconObj = (call compile _beaconObjString);
	_beaconObj allowDamage false;

	// Create the deploy action
	_action = [(format ["SAEF_ASA_Deploy_%1", _beaconObjString]), (format ["Deploy Beacon: %1", _beaconName]), "", 
		{
			params ["_target", "_player", "_params"];

			_params call SAEF_ASA_fnc_DeploymentBeacon;
		}, 
		{
			// Condition
			(((leader (group player)) == player) && ((vehicle player) == player))
		}, 
		{}, ["Deploy", [_beaconObj, _beaconName, _deployPara]]
	] call ace_interact_menu_fnc_createAction;

	[player, 1, ["ACE_SelfActions", "SAEF_ASA_Personal_Actions"], _action, true] call ace_interact_menu_fnc_addActionToObject;
};

if (toUpper(_type) == "MOVE") then
{
	[_beacon] spawn 
	{
		params
		[
			"_beacon"
		];

		// Either paradrop the player or move them to the beacon
		if (_beacon getVariable ["SAEF_ASA_DeployObject_Para", false]) then
		{
			[_beacon, "PARA", ["ACE_NonSteerableParachute"]] spawn SAEF_ASA_INS_fnc_HandleInsertion;
		}
		else
		{
			player setPosATL (getPosATL _beacon);
		};
	};
};

if (toUpper(_type) == "MOVEACTION") then
{
	_beacon params
	[
		"_beaconObjString",
		"_beaconName",
		"_moveBeaconObjString"
	];

	if (isNil _beaconObjString) exitWith 
	{
		["SAEF_ASA_fnc_DeploymentBeacon", 1, (format ["Cannot add action for movement to beacon [%1] that doesn't exist!", _beaconObjString])] call RS_fnc_LoggingHelper;
	};

	if (isNil _moveBeaconObjString) exitWith 
	{
		["SAEF_ASA_fnc_DeploymentBeacon", 1, (format ["Cannot add action for movement to beacon [%1] on object [%2] that doesn't exist!", _beaconObjString, _moveBeaconObjString])] call RS_fnc_LoggingHelper;
	};

	private
	[
		"_beaconObj",
		"_moveBeaconObj",
		"_action"
	];

	// Parse the objects
	_beaconObj = (call compile _beaconObjString);
	_moveBeaconObj = (call compile _moveBeaconObjString);

	// Ensure vehicle varname is set
	[_beaconObj, _beaconObjString] call SAEF_VEH_fnc_RnR_GlobalRename;

	// Add the actions
	_action = [(format ["SAEF_ASA_Deploy_Move_%1", _moveBeaconObjString]), (format ["Deploy to Beacon: %1", _beaconName]), "",
		{
			params ["_target", "_player", "_params"];

			_params call SAEF_ASA_fnc_DeploymentBeacon;
		},
		{true}, {}, ["Move", _beaconObj], [0,0,0], 100
	] call ace_interact_menu_fnc_createAction;			

	[_moveBeaconObj, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
};

if (toUpper(_type) == "CARGOACTIONS") then
{
	_beacon params
	[
		"_beaconObjString"
	];

	if (isNil _beaconObjString) exitWith 
	{
		["SAEF_ASA_fnc_DeploymentBeacon", 1, (format ["Cannot add action for movement to beacon [%1] that doesn't exist!", _beaconObjString])] call RS_fnc_LoggingHelper;
	};

	private
	[
		"_beaconObj",
		"_cargoItems"
	];

	// Parse the objects
	_beaconObj = (call compile _beaconObjString);
	_cargoItems = missionNamespace getVariable ["SAEF_ASA_INS_ParadropCargoItems", []];

	{
		_x params
		[
			"_itemClassName",
			"_itemDisplayName",
			"_additionalScripts"
		];

		private
		[
			"_action"
		];

		// Add the actions
		_action = [(format ["SAEF_ASA_Deploy_Cargo_%1", _forEachIndex]), (format ["Request: %1", _itemDisplayName]), "",
			{
				params ["_target", "_player", "_params"];

				_params spawn SAEF_ASA_INS_fnc_HandleInsertion;
			},
			{true}, {}, [_beaconObj, "CARGO", [_itemClassName, _additionalScripts]] , [0,0,0], 100
		] call ace_interact_menu_fnc_createAction;			

		[_beaconObj, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
	} forEach _cargoItems;
};