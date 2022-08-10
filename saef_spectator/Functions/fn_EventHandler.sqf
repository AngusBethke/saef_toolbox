/*
	fn_EventHandler.sqf

	Description:
		Monitors units and attaches local event handlers
*/

private "_eventHandlerCode";
_eventHandlerCode = {
	params ["_unit", "_firer", "_distance", "_weapon", "_muzzle", "_mode", "_ammo", "_gunner"];

	_unit setVariable ["SAEF_SPTR_EH_FiredNear_Time", (["GET"] call SAEF_SPTR_fnc_Time), true];
};

// If this is a player, then add a personalised event handler
if (hasInterface) then
{
	if (!(player getVariable ["SAEF_SPTR_EH_FiredNear_Added", false])) then
	{
		player setVariable ["SAEF_SPTR_EH_FiredNear_Added", true, true];

		player addEventHandler ["FiredNear", _eventHandlerCode];
	};

	if (!(player getVariable ["SAEF_SPTR_EH_Action_Added", false])) then
	{
		player setVariable ["SAEF_SPTR_EH_Action_Added", true, true];
		["INIT"] call SAEF_SPTR_fnc_Action;
	};
};

// If this is the server and a player (i.e. Singleplayer), then we're going to attach the event handler to all units for debug purposes
if (isServer && hasInterface) then
{
	missionNamespace setVariable ["SAEF_SPTR_Run_EH_Handler", true];

	while {(missionNamespace getVariable ["SAEF_SPTR_Run_EH_Handler", false])} do
	{
		{
			// We're immediately going to remove them from this list if they're not local
			if (local _x) then
			{
				if (!(_x getVariable ["SAEF_SPTR_EH_FiredNear_Added", false])) then
				{
					_x setVariable ["SAEF_SPTR_EH_FiredNear_Added", true, true];

					_x addEventHandler ["FiredNear", _eventHandlerCode];
				};
			};
		} forEach allUnits;

		sleep 10;
	};
};