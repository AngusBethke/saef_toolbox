/**
	@namespace RS
	@class Admin
	@method RS_fnc_Admin_RunScriptOnServer
	@file fn_Admin_RunScriptOnServer.sqf
	@summary Takes script and parameters and executes it on the server
	@param array _params
	@param string _script
**/

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