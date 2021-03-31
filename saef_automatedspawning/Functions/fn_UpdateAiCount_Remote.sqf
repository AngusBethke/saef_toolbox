/*
	fn_UpdateAiCount_Remote.sqf

	Description:
		Returns the object for our current owner id (specifically for headless clients)

	How to call:
		[
			_clientId,		// Id of the executing client
			_count			// Number factor for count update
		] call SAEF_AS_fnc_UpdateAiCount_Remote;
*/

if (!isServer) exitWith
{
	["SAEF_AS_fnc_UpdateAiCount_Remote", 1, "This must be executed on the server!"] call RS_fnc_LoggingHelper;
};

params
[
	"_clientId",
	"_count"
];

private
[
	"_target"
];

{
	if ((owner _x) == _clientId) then
	{
		_target = _x;
	};
} forEach (entities "HeadlessClient_F");

// We need to update the staged ai count
[_target, _count, false] call SAEF_AS_fnc_UpdateAiCount;