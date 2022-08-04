/**
	@namespace SAEF_VEH
	@class RearmAndRepair
	@method SAEF_VEH_fnc_RnR_InitQueueHandler
	@file fn_RnR_InitQueueHandler.sqf
	@summary Handles the initialisation queue for this toolset

**/

/*
	fn_RnR_InitQueueHandler.sqf

	Description:
		Handles the initialisation queue for this toolset
*/

missionNamespace setVariable ["SAEF_RnR_InitQueueHandler", true, true];

// Start-up delay
sleep 10;

while {(missionNamespace getVariable ["SAEF_RnR_InitQueueHandler", false])} do
{
	private
	[
		"_initQueue"
	];

	_initQueue = missionNamespace getVariable ["SAEF_RnR_InitQueue", []];

	if (!(_initQueue isEqualTo [])) then
	{
		{
			_x params
			[
				"_vehString",
				"_objString"
			];

			private
			[
				"_checkVar"
			];

			_checkVar = (format ["SAEF_RnR_Vehicle_%1_Checked", _vehString]);

			{
				_x params ["_player"];

				if (!(_player getVariable [_checkVar, false])) then
				{
					_player setVariable [_checkVar, true, true];

					private
					[
						"_uid",
						"_queueName"
					];

					_uid = getPlayerUID _player;
					_queueName = (format ["SAEF_RnRQueue_%1", _uid]);

					[_queueName, [_vehString, _objString], "SAEF_VEH_fnc_RnR_PlayerSetup"] remoteExecCall ["RS_MQ_fnc_MessageEnqueue", _player, false];
				};
			} forEach ([true, true] call RS_PLYR_fnc_GetTruePlayers);
		} forEach _initQueue;
	};

	sleep 60;
};