/*
	fn_ExecScriptHandler.sqf
	Description: Accepts a script string and then does some validation to determine if a headless client is active, if the headless client is active, execute on the headless client, otherwise it is executed on the server.
	How to call: 
		[
			_params, 	// Parameters for your function/script <array, string>
			_script,	// The script/function that you would like to execute <string, function definition>
			_exec		// Optional: Third parameter if you would like to override the default "spawn" with "call" or similar
		] call RS_fnc_ExecScriptHandler;
	Examples:
	[[], "Scripts\MissionSpawners\Spawn_Handler_Main.sqf"] call RS_fnc_ExecScriptHandler;
	[[_group, _area, _usePara, _secondPos], "DS_fnc_HunterKiller"] call RS_fnc_ExecScriptHandler;
	[[_secondPos, _group, _area], "DS_fnc_Garrison", "call"] call RS_fnc_ExecScriptHandler;
*/

private
[
	 "_params"
	,"_script"
	,"_exec"
	,"_headlessPresent"
];

_params = _this select 0;
_script = _this select 1;
_exec = _this select 2;

// Test our optional third parameter
if (isNil "_exec") then
{
	_exec = "spawn";
};

// Test if this is of type script
_isScript = false;
if ([".sqf", _script] call BIS_fnc_inString) then
{
	_isScript = true;
	_exec = "execVM";
};

// Test if the Headless Client is present
_headlessPresent = false;
if (!isNil "HC1") then
{
	_headlessPresent = isPlayer HC1;
};

// If the headless is present, execute the script on the headless, else on the server
if (_headlessPresent) then
{
	diag_log format ["[RS] [ExecScriptHandler] [INFO] Headless found, executing script/function on the Headless Client: %1 %2 %3", _params, _exec, _script];
	if (_isScript) then
	{
		[_params, _script] remoteExec [_exec, HC1, false];
	}
	else
	{
		if (toUpper(_exec) == "CALL") then
		{
			_params remoteExecCall [_script, HC1, false];
		}
		else
		{
			_params remoteExec [_script, HC1, false];
		};
	};
}
else
{
	diag_log format ["[RS] [ExecScriptHandler] [INFO] No Headless found, executing script/function on the Server: %1 %2 %3", _params, _exec, _script];
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