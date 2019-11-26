/*
	Name:			fn_Admin_RunScriptOnServer.sqf
	Description:	Takes script and parameters and executes it on the server
*/

private
[
	"_params",
	"_script"
];

_params = _this select 0;
_script = _this select 1;

[_params, _script] remoteExec ["execVM", 2, false];