/*
	fn_ModuleCivilianPresence.sqf
	Description: Distributes to the delegate function, on the headless client if necessary

	Originally Developed by Bohemia Interactive
*/

if (!isServer) exitWith {};

_executionLocality = missionNamespace getVariable ["SAEF_CivilianPresence_ExecutionLocality", "HC1"];
[_this, "RS_CP_fnc_Delegate_ModuleCivilianPresence", "call", _executionLocality] call RS_fnc_ExecScriptHandler;