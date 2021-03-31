/*
	fn_Init.sqf
	Description: Initialises necessary functions for the Message Queue
	Author: Angus Bethke a.k.a. Rabid Squirrel
*/

if (!isServer) exitWith {};

["RS_MQ_QueueCreator", 0] spawn RS_MQ_fnc_MessageHandler;

private
[
	"_variable",
	"_logName"
];

_logName = "RS Message Queue Init";

// Set our variable
_variable = "RS_MQ_Run_QueueCreator";
missionNamespace setVariable [_variable, true, true];

// Let everyone know what we're up to
[_logName, 0, (format ["Starting Queue Creator for headless clients, to stop processing toggle variable [%1] to false.", _variable])] call RS_fnc_LoggingHelper;

// Persistently initialise the queue creators for all headless clients
[_variable] spawn {
	params
	[
		"_variable"
	];

	private
	[
		"_timeout",
		"_count"
	];

	_timeout = 30;
	_count = 0;

	// Check that that are at least some headless clients before starting
	waitUntil {
		sleep 1;
		_count = _count + 1;
		((_count == _timeout) || !((entities "HeadlessClient_F") isEqualTo []))
	};

	while { (missionNamespace getVariable [_variable, false]) } do
	{
		{
			_x params
			[
				"_client"
			];

			if ((_client in allPlayers) && !(_client getVariable ["RS_MQ_QueueCreator_Assigned", false])) then
			{
				private
				[
					"_queueName"
				];

				_queueName = (format ["RS_MQ_QueueCreator_%1", (vehicleVarName _client)]);
				[_queueName] remoteExec ["RS_MQ_fnc_MessageHandler", _client, false];
				
				_client setVariable ["RS_MQ_QueueCreator_Assigned", true, true];
			};
		} forEach (entities "HeadlessClient_F");

		sleep 120;
	};
};