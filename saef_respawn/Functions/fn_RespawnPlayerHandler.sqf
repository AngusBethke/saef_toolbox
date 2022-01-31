/**
	@namespace RS
	@class Respawn
	@method RS_fnc_RespawnPlayerHandler
	@file fn_RespawnPlayerHandler.sqf
	@summary Allows an admin user to forcefully respawn players

	@param any _adminUtilsParent

**/

/*
	fn_RespawnPlayerHandler.sqf

	Description:
		Allows an admin user to forcefully respawn players
*/

params
[
	"_adminUtilsParent"
];

private
[
	"_action",
	"_actionParent"
];

// Parent Action
_action = ["SAEF_RespawnPlayersForce","Force Respawn Players","saef_admin\Images\rs_logo.paa", {}, {true}] call ace_interact_menu_fnc_createAction;
[player, 1, _adminUtilsParent, _action, true] call ace_interact_menu_fnc_addActionToObject;
_actionParent = _adminUtilsParent + ["SAEF_RespawnPlayersForce"];

while {(missionNamespace getVariable ["SAEF_Respawn_RunPlayerHandler", false])} do
{
	private
	[
		"_variable"
	];

	_variable = (player getVariable ["SAEF_ForceRespawn_Player_ActionAdded", []]);

	{
		private
		[
			"_name",
			"_actionName",
			"_action"
		];

		_name = (name _x);
		_uid = (getPlayerUID _x);

		// Don't add this more than once for each player
		if (!(_uid in _variable)) then
		{
			_variable pushBack _uid;
			_actionName = (format ["SAEF_ForceRespawn_%1", _uid]);

			// Enable Respawn Hints
			_action = [_actionName, _name, "",
				{
					params ["_target", "_player", "_params"];
					_params params ["_uid"];

					private
					[
						"_unit"
					];
					
					_unit = objNull;
					{
						if (_uid == (getPlayerUID _x)) then
						{
							_unit = _x;
						};
					} forEach (allPlayers - (entities "HeadlessClient_F"));

					if (_unit == objNull) exitWith 
					{
						[
							"RS_fnc_RespawnPlayerHandler", 
							2, 
							(format ["Unit with uid [%1] not returned by allPlayers!", _uid])
						] call RS_fnc_LoggingHelper;
					};

					// Execution Code Block
					_unit setVariable ["SAEF_Player_ForceRespawnEnabled", true, true];
				}, 
				{
					params ["_target", "_player", "_params"];
					_params params ["_uid"];

					private
					[
						"_unit"
					];
					
					_unit = objNull;
					{
						if (_uid == (getPlayerUID _x)) then
						{
							_unit = _x;
						};
					} forEach (allPlayers - (entities "HeadlessClient_F"));

					if (_unit == objNull) exitWith 
					{
						[
							"RS_fnc_RespawnPlayerHandler", 
							2, 
							(format ["Unit with uid [%1] not returned by allPlayers!", _uid])
						] call RS_fnc_LoggingHelper;

						// Return false
						false
					};

					// Condition Code Block
					(_unit getVariable ["SAEF_Respawn_AwaitingRespawn", false])
				},
				{},
				[_uid]
			] call ace_interact_menu_fnc_createAction;
			
			// Add the action to the Player
			[player, 1, _actionParent, _action, true] call ace_interact_menu_fnc_addActionToObject;
		};
	} forEach (allPlayers - (entities "HeadlessClient_F"));

	player setVariable ["SAEF_ForceRespawn_Player_ActionAdded", _variable, true];

	sleep 10;
};