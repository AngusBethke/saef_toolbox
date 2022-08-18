/*	
	fn_SpawnProtection.sqf
	Author: Angus Bethke
	Description: 
		Gives the AI 10 seconds of spawn protection to ensure they don't die right after they have spawned
*/

params
[
	"_unit"
];

private
[
	"_closestPlayer"
];

// If a player is close by, we don't want to give the AI spawn protection, could lead to some frustrating deaths
_closestPlayer = [(getPos _unit), 100] call RS_PLYR_fnc_GetClosestPlayerObject;

if ((isDamageAllowed _unit) && (isNull _closestPlayer)) then
{
	_unit allowDamage false;

	if ((vehicle _unit) != _unit) then
	{
		(vehicle _unit) allowDamage false;
	};

	sleep 10;

	_unit allowDamage true;

	if ((vehicle _unit) != _unit) then
	{
		(vehicle _unit) allowDamage true;
	};
};