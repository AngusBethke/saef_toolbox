/*
	fn_ExecScriptHandler.sqf
	Description: Accepts a script string and then does some validation to determine if a headless client is active, if the headless client is active, execute on the headless client, otherwise it is executed on the server.
	How to call: 
		[
			_params, 	// Parameters for your function/script <array, string>
			_script,	// The script/function that you would like to execute <string, function definition>
			_exec,		// Optional: Third parameter if you would like to override the default "spawn" with "call" or similar
			_target		// Optional: The exact client you want to target (useful if you have multiple headless client objects)
		] call RS_fnc_ExecScriptHandler;
	Examples:
	[[], "Scripts\MissionSpawners\Spawn_Handler_Main.sqf"] call RS_fnc_ExecScriptHandler;
	[[_group, _area, _usePara, _secondPos], "DS_fnc_HunterKiller"] call RS_fnc_ExecScriptHandler;
	[[_secondPos, _group, _area], "DS_fnc_Garrison", "call"] call RS_fnc_ExecScriptHandler;
*/

params
[
	"_params",
	"_script",
	[
		"_exec",
		"spawn"
	],
	[
		"_target", 
		"HC1"
	]
];

private
[
	"_isScript",
	"_headlessPresent",
	"_headlessObject"
];

// Test if this is of type script
_isScript = false;
if ([".sqf", _script] call BIS_fnc_inString) then
{
	_isScript = true;
	_exec = "execVM";
};

// Test if the target is present
_headlessPresent = false;
if (!isNil _target) then
{
	_headlessObject = (call compile _target);
	_headlessPresent = isPlayer _headlessObject;
};

// If the target is present, execute the script on the target, else on the server
if (_headlessPresent) then
{
	["RS_fnc_ExecScriptHandler", 3, (format ["Target [%1] found, executing script/function on [%1]: %2 %3 %4", _target, _params, _exec, _script]), true] call RS_fnc_LoggingHelper;
	if (_isScript) then
	{
		[_params, _script] remoteExec [_exec, _headlessObject, false];
	}
	else
	{
		if (toUpper(_exec) == "CALL") then
		{
			_params remoteExecCall [_script, _headlessObject, false];
		}
		else
		{
			_params remoteExec [_script, _headlessObject, false];
		};
	};
}
else
{
	["RS_fnc_ExecScriptHandler", 3, (format ["Target [%1] not found, executing script/function on the Server: %2 %3 %4", _target, _params, _exec, _script]), true] call RS_fnc_LoggingHelper;
	if (_isScript) then
	{
		[_params, _script] remoteExec [_exec, 2, false];
	}
	else
	{
		if (toUpper(_exec) == "CALL") then
		{
			_params remoteExecCall [_script, 2, false];
		}
		else
		{
			_params remoteExec [_script, 2, false];
		};
	};
};