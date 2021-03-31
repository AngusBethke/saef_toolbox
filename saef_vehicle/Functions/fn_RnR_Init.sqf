/*
	fn_RnR_Init.sqf

	Description:
		Handles initialisation for the rearm and repair toolset
*/

// Only the server will process this
if (isServer) then
{
	["SAEF_RnRQueue"] call RS_MQ_fnc_CreateQueue;
	["SAEF_RnR_ModuleQueue"] call RS_MQ_fnc_CreateQueue;
	[] spawn SAEF_VEH_fnc_RnR_InitQueueHandler;
};

// All player clients will process this
if (hasInterface) then
{
	private
	[
		"_uid",
		"_queueName",
		"_queueProcessVariable"
	];

	_uid = getPlayerUID player;
	_queueName = (format ["SAEF_RnRQueue_%1", _uid]);

	// If the player disconnects we should re-create their queue
	_queueProcessVariable = format ["%1_MessageHandler_Run", _queueName];

	if (missionNamespace getVariable [_queueProcessVariable, false]) then
	{
		missionNamespace setVariable [_queueProcessVariable, false, true];
	};

	// Run the message handler
	[_queueName] spawn RS_MQ_fnc_MessageHandler;
};