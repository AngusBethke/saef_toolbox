/*
	fn_Action.sqf

	Description:
		Handles the application of actions
*/

params
[
	"_type",
	["_params", []]
];

/*
	----------------------
	-- INTERRUPT_ACTION --
	----------------------

	Adds the interrupt action to the players
*/
if (toUpper(_type) == "INTERRUPT_ACTION") exitWith
{
	private
	[
		"_action"
	];

	_action = ["SAEF_SPTR_InterruptAction", "Spectator - Watch me!", "", 
		{
			params ["_target", "_player", "_params"];

			missionNamespace setVariable ["SAEF_SPTR_InterruptRequester", player, true];
		},
		{
			// If there are any spectators and an interrupt is not already in progress
			(!((["GETSPECTATORS"] call SAEF_SPTR_fnc_Handler) isEqualTo []) 
				&& !(missionNamespace getVariable ["SAEF_SPTR_InterruptInProgress", false]))
		},
		{}, [], [0,0,0], 100
	] call ace_interact_menu_fnc_createAction;
	
	[player, 1, ["ACE_SelfActions", "SAEF_Tools"], _action] call ace_interact_menu_fnc_addActionToObject;
};

["SAEF_SPTR_fnc_View", 2, (format ["Unrecognised type [%1], nothing is being executed!", _type])] call RS_fnc_LoggingHelper;