/*
	fn_CreateQueue.sqf
	Description: Safe way to initialise queues
	Author: Angus Bethke a.k.a. Rabid Squirrel

	How to Call:
		[
			"_queueName"
			,"_target"				// Optional
			,"_serverFallback"		// Optional
		] call RS_MQ_fnc_CreateQueue;
*/

params
[
	["_queueName", "", [""]]
	,["_target", "", []]
	,["_serverFallback", true, [true]]
	,["_distributedQueueEvaluationFunctions", []]
];

private
[
	"_logName"
];

_logName = "RS Message Queue Creator";

if (_queueName == "") exitWith
{
	[_logName, 3, "Queue Name must be supplied when creating a queue!"] call RS_fnc_LoggingHelper;
};

switch toUpper(_target) do
{
	case "ALL_HEADLESS":
	{
		if (!isServer) exitWith 
		{
			[_logName, 1, (format ["Only the server may create a distributed queue! Cannot create queue with name [%1]", _queueName])] call RS_fnc_LoggingHelper;
		};

		// Set up the distributed handler
		if (_distributedQueueEvaluationFunctions isEqualTo []) then
		{
			["RS_MQ_QueueCreator", [_queueName], "RS_MQ_fnc_DistributedHandler"] call RS_MQ_fnc_MessageEnqueue;
		}
		else
		{
			["RS_MQ_QueueCreator", [_queueName, _distributedQueueEvaluationFunctions], "RS_MQ_fnc_DistributedHandler"] call RS_MQ_fnc_MessageEnqueue;
		};

		// Create a queue for the server (as a fallback for the distributed handler)
		[(format ["%1_Server", _queueName])] call RS_MQ_fnc_CreateQueue;

		// Create queues for all the connected headless clients
		private
		[
			"_targets"
		];

		_targets = [];
		{
			_x params ["_headlessClient"];

			if (isPlayer _headlessClient) then
			{
				private
				[
					"_headlessQueueName"
				];

				_headlessQueueName = (format ["%1_%2", _queueName, (vehicleVarName _headlessClient)]);

				[_headlessQueueName, (vehicleVarName _headlessClient), false] call RS_MQ_fnc_CreateQueue;

				_targets pushBack (vehicleVarName _headlessClient);
			};
		} forEach (entities "HeadlessClient_F");

		// Register the targets for this queue
		missionNamespace setVariable [(format ["%1_Targets", _queueName]), _targets, true];
	};
	case "":
	{
		["RS_MQ_QueueCreator", [_queueName], "RS_MQ_fnc_MessageHandler"] call RS_MQ_fnc_MessageEnqueue;
	};
	default 
	{
		private
		[
			"_mqName"
		];

		_mqName = (format ["RS_MQ_QueueCreator_%1", _target]);
		[_mqName, [_queueName], "RS_MQ_fnc_MessageHandler"] call RS_MQ_fnc_MessageEnqueue;

		if (_serverFallback) then
		{
			[_logName, _queueName] spawn
			{
				params
				[
					"_logName",
					"_queueName"
				];

				sleep 10;

				if (!(missionNamespace getVariable [(format ["%1_MessageHandler_Run", _queueName]), false])) then
				{
					[_logName, 2, (format ["Cannot find started queue with given name [%1], falling back to server for queue creation. To turn this functionality off you should supply the third parameter to RS_MQ_fnc_CreateQueue as 'false'.", _queueName])] call RS_fnc_LoggingHelper;
					[_queueName] call RS_MQ_fnc_CreateQueue;
				};
			};
		};
	};
};