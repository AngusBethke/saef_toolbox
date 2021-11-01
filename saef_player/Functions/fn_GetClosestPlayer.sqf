/*
	fn_GetClosestPlayer.sqf

	Description: 
		Returns the closest player position within a given radius

	How to Call: 
		[
			<position>, 
			<radius>, 					// Optional
			<playerValidationCode> 		// Optional
		] call RS_PLYR_fnc_GetClosestPlayer;
*/

private
[
	"_closestPlayerPos",
	"_closestPlayer"
];

_closestPlayerPos = [0,0,0];

// Get the closest player
_closestPlayer = _this call RS_PLYR_fnc_GetClosestPlayerObject;

if (!(isNull _closestPlayer)) then
{
	_closestPlayerPos = getPos _closestPlayer;
};

// Returns closest player position within given radius
_closestPlayerPos

/*
	END
*/