/*
	fn_Player_PersonalSupportActions.sqf

	Description:	
		Sets player EndFlght Variable

	How to Call:	
		[] call SAEF_ASA_fnc_Player_PersonalSupportActions;
*/

private
[
	"_action"
];

// Create base action
_action = ["SAEF_ASA_Personal_Actions", "SAEF Supports", "", {}, {true}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions"], _action, true] call ace_interact_menu_fnc_addActionToObject;

// Actions for the supports
private
[
	"_supportTypes"
];

_supportTypes = ["SAEF_ASA_AirSupport", "SAEF_ASA_TransportSupport"];

{
	_x params
	[
		"_supportType"
	];

	private
	[
		"_action"
	];

	// Create the end support action
	_action = [(format ["%1_EndSupport", _supportType]), "End Current Support", "", 
		{
			params ["_target", "_player", "_params"];
			_params params ["_supportType"];

			// Set relevant variables
			player setVariable [(format ["%1_CurrentlyInSupportVehicle", _supportType]), false, true];
			player setVariable [(format ["%1_EndSupport", _supportType]), true, true];
		}, 
		{
			params ["_target", "_player", "_params"];
			_params params ["_supportType"];
			
			// Condition
			(player getVariable [(format ["%1_CurrentlyInSupportVehicle", _supportType]), false])
		}, 
		{}, [_supportType]
	] call ace_interact_menu_fnc_createAction;

	[player, 1, ["ACE_SelfActions", "SAEF_ASA_Personal_Actions"], _action, true] call ace_interact_menu_fnc_addActionToObject;
} forEach _supportTypes;