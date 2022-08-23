/*
	fn_Handle.sqf

	Description:
		Handles task functionality and methods
*/

// This function set should only be handled by the server
if (!isServer) exitWith
{
	["SAEF_TSK_ProcessQueue", _this, "SAEF_TSK_fnc_Handle"] call RS_MQ_fnc_MessageEnqueue;
};

params
[
	"_type",
	["_params", []],
	["_taskId", ""]
];

private
[
	"_scriptTag",
	"_taskStates"
];

_scriptTag = "SAEF Tasks - Handle";
_taskStates = ["CREATED", "ASSIGNED", "AUTOASSIGNED", "SUCCEEDED", "FAILED", "CANCELLED"];

/*
	------------
	-- CREATE --
	------------

	Create a task
*/
if (toUpper(_type) == "CREATE") exitWith
{
	_params params
	[
		"_owner",
		"_description",
		"_position",
		"_image",
		["_conditionOfCompletion", []],
		["_state", "CREATED"],
		["_completionCodeBlocks", []],
		["_conditionOfCreation", {true}]
	];

	// Decorate incoming variables
	_state = toUpper(_state);

	// State must be in allowed states
	if (!(_state in _taskStates)) exitWith
	{
		[_scriptTag, 1, (format ["Unrecognised state [%1], cannot create the task!", _state])] call RS_fnc_LoggingHelper;
	};

	// Get a safe id
	if (_taskId == "") then
	{
		_taskId = ["GetSafeId"] call SAEF_TSK_fnc_Handle;
	};

	// If condition of creation doesn't immediately clear, then we need to get this into the queue 
	if (!(_this call _conditionOfCreation)) then
	{
		["SAEF_TSK_ProcessQueue", [_type, _params, _taskId], "SAEF_TSK_fnc_Handle", _conditionOfCreation, objNull, 0, {}, 10] call RS_MQ_fnc_MessageEnqueue;
	};

	// By default the condition of completion of this task will be a check against the missionNamespace variable id of this task
	if (_conditionOfCompletion isEqualTo []) then
	{
		[
			_scriptTag, 
			1, 
			(format ["Condition of compeletion for task [%1] defaulted, states are now controlled by the following variables: %2", _taskId, [(format ["%1_complete", _taskId]), (format ["%1_failed", _taskId]), (format ["%1_cancelled", _taskId])]])
		] call RS_fnc_LoggingHelper;

		_conditionOfCompletion = [
			[],
			{
				params
				[
					"_taskId"
				];

				// Ensure condition of completion returns the correct states
				[
					missionNamespace getVariable [(format ["%1_complete", _taskId]), false],		// Complete State
					missionNamespace getVariable [(format ["%1_failed", _taskId]), false],			// Failed State
					missionNamespace getVariable [(format ["%1_cancelled", _taskId]), false]		// Cancelled State
				]
			}
		];
	};

	// Create the task
	private
	[
		"_taskCreationSuccess"
	];

	_taskCreationSuccess = [_owner, _taskId, _description, _position, _state, 0, true, _image] call BIS_fnc_taskCreate;

	// Handle completion of the task
	["HandleCompletion", [_conditionOfCompletion, _completionCodeBlocks], _taskId] spawn SAEF_TSK_fnc_Handle;

	// Return the id of the task
	if (!canSuspend) exitWith
	{
		_taskId
	};
};

/*
	----------------------
	-- HANDLECOMPLETION --
	----------------------

	Handles the completion of the task
*/
if (toUpper(_type) == "HANDLECOMPLETION") exitWith
{
	if (!canSuspend) exitWith
	{
		_this spawn SAEF_TSK_fnc_Handle;
	};

	_params params
	[
		"_conditionOfCompletion",
		"_completionCodeBlocks"
	];

	_conditionOfCompletion params
	[
		"_conOfCompParams",
		"_conOfCompCode"
	];

	private
	[
		"_completed",
		"_failed",
		"_cancelled"
	];

	_completed = false;
	_failed = false;
	_cancelled = false;

	waitUntil {
		sleep 10;

		private
		[
			"_success"
		];

		_success = false;

		(([_taskId] + _conOfCompParams) call _conOfCompCode) params
		[
			"_tCompleted",
			"_tFailed",
			"_tCancelled"
		];

		if (_tCompleted || _tFailed || _tCancelled) then
		{
			_completed = _tCompleted;
			_failed = _tFailed;
			_cancelled = _tCancelled;

			_success = true;
		};

		// Evaluate success
		_success
	};

	_completionCodeBlocks params
	[
		["_completedCodeBlockAndParams", [[], {}]],
		["_failedCodeBlockAndParams", [[], {}]],
		["_cancelledCodeBlockAndParams", [[], {}]]
	];

	if (_completed) exitWith
	{
		[_taskId, "SUCCEEDED"] call BIS_fnc_taskSetState;
		["ExecuteCompletion", ([(format ["%1_complete", _taskId])] + _completedCodeBlockAndParams), _taskId] call SAEF_TSK_fnc_Handle;
	};

	if (_failed) exitWith
	{
		[_taskId, "FAILED"] call BIS_fnc_taskSetState;
		["ExecuteCompletion", ([(format ["%1_failed", _taskId])] + _failedCodeBlockAndParams), _taskId] call SAEF_TSK_fnc_Handle;
	};

	if (_cancelled) exitWith
	{
		[_taskId, "CANCELLED"] call BIS_fnc_taskSetState;
		["ExecuteCompletion", ([(format ["%1_cancelled", _taskId])] + _cancelledCodeBlockAndParams), _taskId] call SAEF_TSK_fnc_Handle;
	};
};

/*
	-----------------------
	-- EXECUTECOMPLETION --
	-----------------------

	Executes completion for task
*/
if (toUpper(_type) == "EXECUTECOMPLETION") exitWith
{
	_params params
	[
		"_variable",
		"_codeParams",
		"_codeBlock"
	];

	missionNamespace setVariable [_variable, true, true];

	([_taskId] + _codeParams) call _codeBlock;
};

/*
	---------------
	-- GETSAFEID --
	---------------

	Gets a safe id for the task (also adds it to the tracking variable)
*/
if (toUpper(_type) == "GETSAFEID") exitWith
{
	private
	[
		"_tasks"
	];

	_tasks = (missionNamespace getVariable ["SAEF_TSK_TaskList", []]);

	private
	[
		"_task"
	];

	_task = (format ["saef_task_%1", ((count _tasks) + 1)]);
	_tasks pushBack _task;

	missionNamespace setVariable ["SAEF_TSK_TaskList", _tasks, true];

	// Return the task id
	_task
};

// Log warning if type is not recognised
[_scriptTag, 2, (format ["Unrecognised type [%1], nothing is being executed!", _type])] call RS_fnc_LoggingHelper;