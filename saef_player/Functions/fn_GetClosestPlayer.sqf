/*
	fn_GetClosestPlayer.sqf
	Description: Returns the Closest Player to a Position within 250m (default).
	How to Call: [<position>, <radius> (optional)] call RS_PLYR_fnc_GetClosestPlayer;
*/

private
[
	"_pos",
	"_radius",
	"_closestPlayerPos",
	"_distance"
];

_pos = _this select 0;
_radius = _this select 1;

if (isNil "_radius") then
{
	_radius = 250;
};

_closestPlayerPos = [0,0,0];
_distance = _radius;
// Looks for Nearby Players
{
	_newDistance = (_x distance _pos);
	if (_newDistance < _distance) then
	{
		_closestPlayerPos = getPos _x;
		_distance = _newDistance;
	};
} forEach (allPlayers - entities "HeadlessClient_F");

// Returns Closest Player Position Within Given Radius
_closestPlayerPos

/*
	END
*/