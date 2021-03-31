/*
	fn_Radius.sqf

	Description: 
		Holds spawn of certain units until player is within the spawn range.

	How to Call: 
		[
			"_params"						// Array: Parameters for function execution
			,"_script"						// String: Script/Function to be re-queued
			,"_range"						// Integer: How far the players need to be from the area in order for radius to activate
			,"_position"					// Array: Position array to evaluate for distance from the area
			,"_playerValidation"			// (Optional) Code Block: Condition passed to GetClosestPlayer to evaluate players for inclusion
			,"_queueValidation"				// (Optional) Code Block: Condition passed to the Message Queue to evaluate message for processing
		] spawn RS_AS_fnc_Radius;
*/

params 
[
	"_params"
	,"_script"
	,"_range"
	,"_position"
	,["_playerValidation", {true}]
	,["_queueValidation", {true}]
];

[_script, 3, "Starting wait for Player"] call RS_fnc_LoggingHelper;

_j = 1;
waitUntil {
	// Suspend
	sleep 5;
	_valid = false;
	_tooClose = false;
	
	// Test if player is close by
	_closePlayer = [_position, _range, _playerValidation] call RS_PLYR_fnc_GetClosestPlayer;
	
	// If there is a player close by
	if (!(_closePlayer isEqualTo [0,0,0])) then
	{
		_tooClose = ((_closePlayer distance _position) < 5);
		_valid = (!_tooClose);
	};
	
	// Log every 3 minutes
	if (_j == 36) then
	{
		_j = 1;
		
		if (_tooClose) then
		{
			[_script, 2, "Polling | Players too close to conduct spawning"] call RS_fnc_LoggingHelper;
		}
		else
		{
			[_script, 3, "Polling | Waiting for Player"] call RS_fnc_LoggingHelper;
		};
	};
	_j = _j + 1;
	
	// Condition met
	_valid
};

[_script, 3, "Wait for Player Finished"] call RS_fnc_LoggingHelper;

// Add this back into the spawn queue - this time without radius spawn set
["SAEF_SpawnerQueue", _params, _script, _queueValidation] call RS_MQ_fnc_MessageEnqueue;

/*
	END
*/