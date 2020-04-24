/*
	fn_GetClosestPlayer.sqf
	Description: Returns the Closest Player to a Position within 250m (default).
	How to Call: 
		[
			<position>, 
			<radius>, 					// Optional
			<playerValidationCode> 		// Optional
		] call RS_PLYR_fnc_GetClosestPlayer;
*/

params
[
	"_pos",
	["_radius", 250],
	["_playerValidation", {true}]
];

private
[
	"_closestPlayerPos",
	"_distance"
];

_closestPlayerPos = [0,0,0];
_distance = _radius;

// Looks for Nearby Players
{
	// Confirm if we need to check this player
	_check = [_x] call _playerValidation;
	
	if (_check) then
	{
		_newDistance = (_x distance _pos);
		if (_newDistance < _distance) then
		{
			_closestPlayerPos = getPos _x;
			_distance = _newDistance;
		};
	};
} forEach (allPlayers - entities "HeadlessClient_F");

// Returns Closest Player Position Within Given Radius
_closestPlayerPos

/*
	END
*/