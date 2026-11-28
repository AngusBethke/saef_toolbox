/*
	fn_HelicopterInsertion_AddAction.sqf

	Description:
		Add the action for the insertion
*/

// Only player clients should be executing this
if (!hasInterface) exitWith {};

params
[
	"_vehicle",
	"_deploymentLocationName"
];

private
[
	"_variableName"
];

_variableName = (format ["SAEF_ASA_INS_AceAction_%1", (vehicleVarName _vehicle)]);

// We're only going to add this action if we haven't done so already
if (!(player getVariable [_variableName, false])) then
{
	// Set up some variables
	private
	[
		"_name",
		"_text"
	];

	_name = format ["SAEF_ASA_INS_StartInsertion_%1", (vehicleVarName _vehicle)];
	_text = format ["Start the Insertion: %1", _deploymentLocationName];

	// Add the action
	private
	[
		"_action"
	];

	_action = 
	[
		_name,  
		_text, 
		"",
		{
			params ["_target", "_player", "_params"];

			_target setVariable ["SAEF_ASA_INS_StartInsertion", true, true];
		},
		{
			params ["_target", "_player", "_params"];

			// Has the insertion started already? 
			!(_target getVariable ["SAEF_ASA_INS_StartInsertion", false])
		},
		{},
		[], 
		[0,0,0], 
		3
	] call ace_interact_menu_fnc_createAction;

	// Map the action to the given object
	[_vehicle, 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToObject;

	// Mark that this action has been added
	player setVariable [_variableName, true, true];
};