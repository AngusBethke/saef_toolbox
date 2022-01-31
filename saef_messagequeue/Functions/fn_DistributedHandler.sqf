/**
	@namespace RS_MQ
	@class MessageQueue
	@method RS_MQ_fnc_DistributedHandler
	@file fn_DistributedHandler.sqf
	@summary Handles message distribution for execution on multiple clients
	
	@param string _queueName
	@param array _evaluationInformation

**/

/*
	fn_DistributedHandler.sqf

	Description: 
		Handles message distribution for execution on multiple clients

	Author: 
		Angus Bethke a.k.a. Rabid Squirrel

	How to Call:
		[
			_queueName,
			_evaluationInformation (optional)
		] spawn RS_MQ_fnc_DistributedHandler;
*/

params
[
	"_queueName",
	["_evaluationInformation", ["SAEF_AS_fnc_EvaluationParameter", "SAEF_AS_fnc_EvaluateAiCount", "SAEF_AS_fnc_UpdateAiCount"]]
];

private
[
	"_logName"
	,"_queueProcessVariable"
	,"_pollTime"
	,"_messages"
];

_logName = "RS Distributed Handler";
_queueProcessVariable = format ["%1_MessageHandler_Run", _queueName];

if (missionNamespace getVariable [_queueProcessVariable, false]) exitWith
{
	[_logName, 1, (format ["Message Handler already running for queue [%1], to stop processing toggle variable [%2] to false.", _queueName, _queueProcessVariable])] call RS_fnc_LoggingHelper;
};

// Test our evaluation information
_evaluationInformation params
[
	["_evaluationParameterFunction", ""],
	["_evaluationFunction", ""],
	["_updateFunction", ""]
];

if (isNil _evaluationParameterFunction) exitWith
{
	[_logName, 1, (format ["Function [%1] not found while trying to initialise queue [%2], queue will not be initialised!", _evaluationParameterFunction, _queueName])] call RS_fnc_LoggingHelper;
};

if (isNil _evaluationFunction) exitWith
{
	[_logName, 1, (format ["Function [%1] not found while trying to initialise queue [%2], queue will not be initialised!", _evaluationFunction, _queueName])] call RS_fnc_LoggingHelper;
};

if (isNil _updateFunction) exitWith
{
	[_logName, 1, (format ["Function [%1] not found while trying to initialise queue [%2], queue will not be initialised!", _updateFunction, _queueName])] call RS_fnc_LoggingHelper;
};

missionNamespace setVariable [_queueProcessVariable, true, true];
[_logName, 0, (format ["Starting Message Handler for queue [%1], to stop processing toggle variable [%2] to false.", _queueName, _queueProcessVariable])] call RS_fnc_LoggingHelper;

// Compile the evaluation code for use
private
[
	"_evaluationParameterCode"
	,"_evaluationCode"
	,"_updateCode"
];

_evaluationParameterCode = (call compile _evaluationParameterFunction);
_evaluationCode = (call compile _evaluationFunction);
_updateCode = (call compile _updateFunction);

_pollTime = 1;
while {missionNamespace getVariable [_queueProcessVariable, false]} do
{
	// Fetch our Messages from the queue
	_messages = missionNamespace getVariable [_queueName, []];
	
	if (!(_messages isEqualTo [])) then
	{
		// Process our messages
		{
			_x params 
			[
				"_messageId"
				,"_params"
				,"_script"
				,"_queueName"
				,"_validation"
			];

			// Remove the message from the queue (this is because the distributed handler doesn't actually process the messages, but rather hands them off to a new queue)
			_x call RS_MQ_fnc_MessageDequeue;

			private
			[
				"_targets"
			];

			_targets = [];
			{
				_x params ["_target"];

				if (toLower(_target) != "server") then
				{
					_targets pushBack [_target, (format ["%1_%2", _queueName, _target])];
				};
			} forEach (missionNamespace getVariable [(format ["%1_Targets", _queueName]), []]);

			if (_targets isEqualTo []) then
			{
				[_logName, 2, (format ["Unable to locate additional targets for queue [%1], cannot re-route message. Falling back to server for message execution.", _queueName])] call RS_fnc_LoggingHelper;

				[(format ["%1_Server", _queueName]), _params, _script, _validation] call RS_MQ_fnc_MessageEnqueue;
			}
			else
			{
				private
				[
					"_targetWeightArray"
				];

				_targetWeightArray = [];
				{
					_x params 
					[
						"_tempTarget",
						"_variable"
					];

					private
					[
						"_compTarget"
					];

					if (!isNil _tempTarget) then
					{
						_compTarget = (call compile _tempTarget);
						if (isPlayer _compTarget) then
						{
							_targetWeightArray pushBack [([_compTarget] call _evaluationCode), _compTarget, _variable];
						}
						else
						{
							[_logName, 2, (format ["Target [%1] for queue [%2], is not a playable entity!", _tempTarget, _queueName])] call RS_fnc_LoggingHelper;
						};
					}
					else
					{
						[_logName, 2, (format ["Target [%1] for queue [%2], appears to be null.", _tempTarget, _queueName])] call RS_fnc_LoggingHelper;
					};
				} foreach _targets;

				// If we succesfully picked a target to distribute to, then we can send the message to it's queue
				if (!(_targetWeightArray isEqualTo [])) then
				{
					_targetWeightArray sort true;

					(_targetWeightArray select 0) params
					[
						["_weight", 0],
						["_target", objNull],
						["_variable", ""]
					];

					if (_target != objNull) then
					{
						private
						[
							"_evaluationParameterIndex"
						];

						_evaluationParameterIndex = [_script] call _evaluationParameterCode;

						[_variable, _params, _script, _validation, _target, _evaluationParameterIndex, _updateCode] call RS_MQ_fnc_MessageEnqueue;
					}
					else
					{
						[_logName, 2, (format ["Weighted target for queue [%1], appears to be null or not active. Falling back to server for message execution.", _queueName])] call RS_fnc_LoggingHelper;

						[(format ["%1_Server", _queueName]), _params, _script, _validation] call RS_MQ_fnc_MessageEnqueue;
					};
				}
				else
				{
					[_logName, 2, (format ["Additional targets for queue [%1], appear to be null or not active. Falling back to server for message execution.", _queueName])] call RS_fnc_LoggingHelper;

					[(format ["%1_Server", _queueName]), _params, _script, _validation] call RS_MQ_fnc_MessageEnqueue;
				};
			};
		} forEach _messages;
	}
	else
	{
		if (_pollTime >= 30) then
		{
			_pollTime = 0;
			[_logName, 3, (format ["Message Handler for queue [%1] polling for messages...", _queueName])] call RS_fnc_LoggingHelper;
		};
	};

	_pollTime = _pollTime + 1;
	sleep 1;
};

[_logName, 3, (format ["Ending Message Handler for queue [%1]", _queueName])] call RS_fnc_LoggingHelper;

/*
	END
*/