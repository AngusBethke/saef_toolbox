/*
	fn_MobileSupportObject.sqf

	Description:
		Deploys Mobile Support Object

	How to Call:
		[_type, _object] call SAEF_ASA_fnc_MobileSupportObject;
*/

params
[
	"_type",
	["_object", objNull]
];

// Deploy the object
if (toUpper(_type) == "DEPLOY") exitWith
{
	// Setup our private variables (important as this function is called recursively)
	private
	[
		"_radioType",
		"_pos",
		"_dir",
		"_object"
	];

	// Mark that the player no longer has the designator
	player setVariable ["SAEF_ASA_HasMobileSupportObject", false, true];

	// Set the radio type
	_radiotype = (missionNamespace getVariable ["SAEF_ASA_MobileSupportObject", "B_Static_Designator_01_F"]);

	// Derive some information from the player
	_pos = getPos player;
	_dir = getDir player;

	// Set Radio Parameters
	_object = createVehicle [_radiotype, _pos, [], 0, "NONE"];
	_object allowDamage false;
	_object setPos (player modelToWorld [0,1,0]);
	_object setDir _dir;
	_object enableSimulation false;
	_object setVehicleLock "LOCKED";
	_object disableAI "ALL";
	_object enableWeaponDisassembly false;

	// Notification that it's deployed
	hint "Mobile Support Object Deployed";

	// Add Action to pick up designator again
	["PickupAction", _object] remoteExecCall ["SAEF_ASA_fnc_MobileSupportObject", 0, true];

	// Add all Default Support Actions
	[_object] remoteExecCall ["SAEF_ASA_fnc_MSO_AddActions", 0, true];
};

// The action to deploy the object
if (toUpper(_type) == "DEPLOYACTION") exitWith
{
	private
	[
		"_action"
	];
	
	_action = ["saef_asa_deploy_mso","Deploy Mobile Support Object","\saef_supports\Images\ace_designator.paa",
		{
			// Execution Code Block
			if (player getVariable ["SAEF_ASA_HasMobileSupportObject", false]) then
			{
				["Deploy"] call SAEF_ASA_fnc_MobileSupportObject;
			}
			else
			{
				hint "You don't have a Designator To Deploy!";
			};
		}, 
		{
			// Condition Code Block
			((player getVariable ["SAEF_ASA_HasMobileSupportObject", false]) && ((vehicle player) == player))
		}
	] call ace_interact_menu_fnc_createAction;
	
	// Add the action to the Player
	[player, 1, ["ACE_SelfActions", "SAEF_ASA_Personal_Actions"], _action, true] call ace_interact_menu_fnc_addActionToObject;
};

// Deploy the object on death
if (toUpper(_type) == "DEPLOYDEATH") exitWith
{
	if (player getVariable ["SAEF_ASA_HasMobileSupportObject", false]) then 
	{
		["Deploy"] call SAEF_ASA_fnc_MobileSupportObject;
	};
};

// Get the object
if (toUpper(_type) == "GET") exitWith
{
	private
	[
		"_allowedDes",
		"_activeDes"
	];

	_allowedDes = missionNamespace getVariable ["SAEF_ASA_AllowedMSOCount", 2];
	_activeDes = missionNamespace getVariable ["SAEF_ASA_ActiveMSOCount", 0];

	if (_activeDes < _allowedDes) then
	{
		player setVariable ["SAEF_ASA_HasMobileSupportObject", true, true];
		missionNamespace setVariable ["SAEF_ASA_ActiveMSOCount", (_activeDes + 1), true];
		hint "Mobile Support Object Acquired";
	}
	else
	{
		if (_activeDes == 1) then
		{
			hint format ["There is already an active mobile support object"];
		}
		else
		{
			hint format ["There are already %1 active mobile support objects", _activeDes];
		};
	};
};

// The action to get the object
if (toUpper(_type) == "GETACTION") exitWith
{
	private
	[
		"_action"
	];

	_action = ["saef_asa_get_mso","Get Mobile Support Object","\saef_supports\Images\ace_designator.paa",
		{
			if !(player getVariable ["SAEF_ASA_HasMobileSupportObject", false]) then
			{
				["Get"] call SAEF_ASA_fnc_MobileSupportObject;
			}
			else
			{
				hint "You already have a Mobile Support Object!";
			};
		},
		{
			!(player getVariable ["SAEF_ASA_HasMobileSupportObject", false])
		},
		{},[], [0,0,0], 100
	] call ace_interact_menu_fnc_createAction;			

	[_object, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
};

// Pickup the object
if (toUpper(_type) == "PICKUP") exitWith
{
	deleteVehicle _object;

	// Notification that it's been picked up
	hint "Mobile Support Object Retrieved";

	player setVariable ["SAEF_ASA_HasMobileSupportObject", true, true];
};

// The action to pickup the object
if (toUpper(_type) == "PICKUPACTION") exitWith
{
	// Disable ability to drag and carry this object
	[_object, false] call ace_dragging_fnc_setCarryable;
	[_object, false] call ace_dragging_fnc_setDraggable;

	private
	[
		"_action"
	];

	_action = ["saef_asa_pickup_mso", "Pick-up Mobile Support Object", "\saef_supports\Images\ace_designator.paa",
		{
			params ["_target"];
			
			// Pass the object to the Pickup Script
			["Pickup", _target] call SAEF_ASA_fnc_MobileSupportObject;
		},
		{
			!(player getVariable ["SAEF_ASA_HasMobileSupportObject", false])
		},
		{},[], [0,0,0], 100
	] call ace_interact_menu_fnc_createAction;			

	[_object, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
};