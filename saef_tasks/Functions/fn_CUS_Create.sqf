/*
	fn_CUS_Create.sqf

	Description:
		Compatibility alias: SAEF_TSK_CUS_fnc_Create was the mission-side copy of the task helpers in the
		SAEF Mission Framework (Toolbox\Tasks). Forwards to SAEF_TSK_fnc_Create, which supports the same
		"Custom" task type plus optional creation code blocks.
*/

_this call SAEF_TSK_fnc_Create