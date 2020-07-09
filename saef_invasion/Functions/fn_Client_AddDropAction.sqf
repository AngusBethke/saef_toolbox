/*
	fn_Client_AddDropAction.sqf
	
	Description:
		Adds the action to kick off the aircraft boarding process
	
	How to Call: 
		[
			_object
		] call RS_INV_fnc_Client_AddDropAction;
*/

params
[
	"_object"
];

private
[
	"_position"
];

_position = [0,0,0];
if (_object isKindOf "Vysilacka") then
{
	_position = [0,0,-1];
};

// Creates the action to board the aircraft
_action = ["RS_INV_BoardAircraft", "Board Aircraft", "",
{
	params ["_target", "_player", "_params"];
	
	_functionLockVariable = "RS_INV_MountPlayers_Function_Locked";
	if (missionNamespace getVariable [_functionLockVariable, false]) then 
	{
		hint "[RS] [INVASION] [INFO] Aircraft boarding process locked by another player!";
	}
	else
	{
		[_functionLockVariable] spawn RS_INV_fnc_Client_MountPlayer;
	};
},
{
	params ["_target", "_player", "_params"];
	
	// Condition
	!(missionNamespace getVariable ["RS_INV_MountPlayers_Function_Locked", false])
},
{}, [], _position, 5] call ace_interact_menu_fnc_createAction;

// Map the Action to an Object
[_object, 0, [], _action] call ace_interact_menu_fnc_addActionToObject;

/*
	END
*/