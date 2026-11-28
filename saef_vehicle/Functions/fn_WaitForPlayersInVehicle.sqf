/*
	Moved to saef_toolbox from the SAEF Mission Framework (Scripts\Player\InVehicle.sqf).
*/

/*
	InVehicle.sqf

	Description: 
		Confirm that all players are in a kind of vehicle
*/

params
[
	"_veh",
	"_var"
];

waitUntil {
	sleep 5;

	private
	[
		"_condition"
	];

	_condition = true;
	
	// Test that player is in a vehicle
	{
		_x params ["_player"];

		if (!((vehicle _player) isKindOf _veh) && (alive _player)) then
		{
			_condition = false;
		};
	} forEach ([] call RS_PLYR_fnc_GetTruePlayers);
	
	// Condition
	_condition
};

missionNamespace setVariable [_var, true, true];