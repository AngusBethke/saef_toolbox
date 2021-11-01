/*
	fn_GetClosestPlayerObject.sqf

	Description: 
		Returns the closest player object

	How to Call: 
		[
			<position>, 
			<radius>, 					// Optional
			<playerValidationCode> 		// Optional
		] call RS_PLYR_fnc_GetClosestPlayerObject;
*/

params
[
	"_pos",
	["_radius", 250],
	["_playerValidation", {true}]
];

private
[
	"_closestPlayer",
	"_distance"
];

_closestPlayer = objNull;
_distance = _radius;

// Looks for Nearby Players
{
	_x params ["_player"];

	// Confirm if we need to check this player
	private
	[
		"_check"
	];

	_check = [_player] call _playerValidation;
	
	if (_check) then
	{
		private
		[
			"_newDistance"
		];

		_newDistance = (_player distance _pos);
		if (_newDistance < _distance) then
		{
			_closestPlayer = _player;
			_distance = _newDistance;
		};
	};
} forEach (allPlayers - (entities "HeadlessClient_F"));

// Returns Closest Player Position Within Given Radius
_closestPlayer

/*
	END
*/