/*
	fn_Create.sqf

	Description:
		Helper methods to support the creation of tasks
*/

params
[
	"_type",
	["_params", []]
];

private
[
	"_scriptTag"
];

_scriptTag = "SAEF Tasks - Create";

/*
	------------
	-- SECURE --
	------------

	Creates a task to secure some area
*/
if (toUpper(_type) == "SECURE") exitWith
{
	_params params
	[
		"_owner",
		"_description",
		"_title",
		"_marker",
		"_trigger",
		["_state", "CREATED"],
		["_completionCodeBlocks", []],
		["_conditionOfCreation", {true}],
		["_creationCodeBlocks", []],
		["_taskId", ""]
	];

	// Setup the condition of completion
	private
	[
		"_conditionOfCompletion"
	];

	_conditionOfCompletion = 
	[
		[_trigger],
		{
			params
			[
				"_taskId",
				"_trigger"
			];

			// Ensure condition of completion returns the correct states
			[
				(triggerActivated _trigger),
				missionNamespace getVariable [(format ["%1_failed", _taskId]), false],
				missionNamespace getVariable [(format ["%1_cancelled", _taskId]), false]
			]
		}
	];

	_creationCodeBlocks = ["InjectCodeBlocksParams", [_creationCodeBlocks, _params]] call SAEF_TSK_fnc_Create;

	// Create the task
	["Create", [_owner, [_description, (format ["Secure - %1", _title]), _marker], (markerPos [_marker, true]), "attack", _conditionOfCompletion, _state, _completionCodeBlocks, _conditionOfCreation, _creationCodeBlocks], _taskId] call SAEF_TSK_fnc_Handle;
};

/*
	-------------
	-- DESTROY --
	-------------

	Creates a task to destroy some objects
*/
if (toUpper(_type) == "DESTROY") exitWith
{
	_params params
	[
		"_owner",
		"_description",
		"_title",
		"_marker",
		"_objects",
		["_state", "CREATED"],
		["_completionCodeBlocks", []],
		["_conditionOfCreation", {true}],
		["_creationCodeBlocks", []],
		["_taskId", ""]
	];

	// Setup the condition of completion
	private
	[
		"_conditionOfCompletion"
	];

	_conditionOfCompletion = 
	[
		[_objects],
		{
			params
			[
				"_taskId",
				"_objects"
			];

			private
			[
				"_objectsDestroyed"
			];

			_objectsDestroyed = true;

			{
				if (canMove _x) then
				{
					_objectsDestroyed = false;
				};
			} forEach _objects;

			// Ensure condition of completion returns the correct states
			[
				_objectsDestroyed,
				missionNamespace getVariable [(format ["%1_failed", _taskId]), false],
				missionNamespace getVariable [(format ["%1_cancelled", _taskId]), false]
			]
		}
	];

	_creationCodeBlocks = ["InjectCodeBlocksParams", [_creationCodeBlocks, _params]] call SAEF_TSK_fnc_Create;

	// Create the task
	["Create", [_owner, [_description, (format ["Destroy - %1", _title]), _marker], (markerPos [_marker, true]), "destroy", _conditionOfCompletion, _state, _completionCodeBlocks, _conditionOfCreation, _creationCodeBlocks], _taskId] call SAEF_TSK_fnc_Handle;
};

/*
	------------
	-- DEFEND --
	------------

	Creates a task to defend some area
*/
if (toUpper(_type) == "DEFEND") exitWith
{
	_params params
	[
		"_owner",
		"_description",
		"_title",
		"_marker",
		"_trigger",
		["_state", "CREATED"],
		["_completionCodeBlocks", []],
		["_conditionOfCreation", {true}],
		["_creationCodeBlocks", []],
		["_taskId", ""]
	];

	// Setup the condition of completion
	private
	[
		"_conditionOfCompletion"
	];

	_conditionOfCompletion = 
	[
		[_trigger],
		{
			params
			[
				"_taskId",
				"_trigger"
			];

			// Ensure condition of completion returns the correct states
			[
				(triggerActivated _trigger),
				missionNamespace getVariable [(format ["%1_failed", _taskId]), false],
				missionNamespace getVariable [(format ["%1_cancelled", _taskId]), false]
			]
		}
	];

	_creationCodeBlocks = ["InjectCodeBlocksParams", [_creationCodeBlocks, _params]] call SAEF_TSK_fnc_Create;

	// Create the task
	["Create", [_owner, [_description, (format ["Defend - %1", _title]), _marker], (markerPos [_marker, true]), "defend", _conditionOfCompletion, _state, _completionCodeBlocks, _conditionOfCreation, _creationCodeBlocks], _taskId] call SAEF_TSK_fnc_Handle;
};

/*
	------------
	-- CUSTOM --
	------------
	Creates a custom task
*/
if (toUpper(_type) == "CUSTOM") exitWith
{
	_params params
	[
		"_owner",
		"_description",
		"_title",
		"_marker",
		"_variable",
		["_state", "CREATED"],
		["_completionCodeBlocks", []],
		["_conditionOfCreation", {true}],
		["_creationCodeBlocks", []],
		["_taskId", ""]
	];

	// Setup the condition of completion
	private
	[
		"_conditionOfCompletion"
	];

	_conditionOfCompletion = 
	[
		[_variable],
		{
			params
			[
				"_taskId",
				"_variable"
			];

			// Ensure condition of completion returns the correct states
			[
				missionNamespace getVariable [_variable, false],
				missionNamespace getVariable [(format ["%1_failed", _variable]), false],
				missionNamespace getVariable [(format ["%1_cancelled", _variable]), false]
			]
		}
	];

	_creationCodeBlocks = ["InjectCodeBlocksParams", [_creationCodeBlocks, _params]] call SAEF_TSK_fnc_Create;

	// Create the task
	["Create", [_owner, [_description, _title, _marker], (markerPos [_marker, true]), "intel", _conditionOfCompletion, _state, _completionCodeBlocks, _conditionOfCreation, _creationCodeBlocks], _taskId] call SAEF_TSK_fnc_Handle;
};

/*
	----------------------------
	-- InjectCodeBlocksParams --
	----------------------------
	Injects parameters into the code blocks
*/
if (toUpper(_type) == toUpper("InjectCodeBlocksParams")) exitWith
{
	_params params
	[
		"_creationCodeBlocks",
		"_allParams"
	];

	// If we have no code blocks we can bail out
	if (_creationCodeBlocks isEqualTo []) exitWith { [] };

	// Add parameters for injection into the code blocks and return
	[
		[(_allParams select 0), (_allParams select 1), (_allParams select 2), (_allParams select 3), (_allParams select 4)],
		_creationCodeBlocks
	]
};

// Log warning if type is not recognised
[_scriptTag, 2, (format ["Unrecognised type [%1], nothing is being executed!", _type])] call RS_fnc_LoggingHelper;