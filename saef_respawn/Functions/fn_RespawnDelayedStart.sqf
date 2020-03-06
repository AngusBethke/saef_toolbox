/*
	fn_RespawnDelayedStart.sqf
	Description: Runs for the player on a delay, so that this doesn't initialise too soon.
*/

// Wait until the player has loaded in correctly
waitUntil {
	sleep 1;
	(!isNull player)
};

private
[
	"_casCount"
];

// Initialise Event Handlers
player setVariable ["RespawnHandlerHint", true, true];
[] call RS_fnc_PlayerEventHandlers;

// Start Hints
[] spawn RS_fnc_RespawnHints;

sleep 5;

// Fix for if Player Joins while Respawns are currently disabled
if (!(missionNamespace getVariable ["RespawnEnabled", true])) then 
{
	if (missionNamespace getVariable ["ST_AllowLogging", false]) then
	{
		_casCount = missionNamespace getVariable "ST_Casualties";
		_casCount = _casCount - 1;
		missionNamespace setVariable ["ST_Casualties", _casCount, true];
	};
	
	player setDamage 1;
};

/*
	END
*/