/*
	fn_DynamicGarrison.sqf

	Description:
		Holds the units until players get close, at which point they break the garrison and chase down the players
*/

params
[
	"_unit"
];

// Wait until a player is close by, or the unit is dead
waitUntil {
	sleep 5;
	(
		!(alive _unit) 
		|| !(([(getPos _unit), 3] call RS_PLYR_fnc_GetClosestPlayer) isEqualTo [0,0,0]) 
		|| ((group _unit) getVariable ["RS_DS_DynamicGarrison_ForcefulEnd", false])
	)
};

if (alive _unit) then
{
	_unit setVariable ["RS_DS_DynamicGarrison_Finished", true, true];
	_unit enableAI "PATH";
	_unit setUnitPos "AUTO";

	// Exit from Vehicle (if in one)
	if ((vehicle _unit) != _unit) then
	{
		unassignVehicle _unit;  
		moveOut _unit;
	};
};