/*
	fn_SwitchToInsurgent_Individual.sqf
	Description: Will switch the specific unit to an insurgent if they meet the required conditions
	[] spawn RS_fnc_Ins_SwitchToInsurgent_Individual;
*/

params
[
	"_unit"
];

// Set the insurgent to a HunterKiller
[_group, 4000, false, (getPos _unit)] spawn RS_DS_fnc_HunterKiller;

// Wait until they are relatively close to a player
waitUntil {
	sleep 5;
	
	_closePlayer = [(getPos _unit), 5] call RS_PLYR_fnc_GetClosestPlayer;
	(!(_closePlayer isEqualTo [0,0,0]) || !(alive _unit))
};

// If the unit is alive, perform the switch to Insurgent
if (alive _unit) then
{
	// Fetch the assigned weapon
	_weapon = _unit getVariable ["RS_Insurgency_HasWeapon", ""];

	// Move the weapon to the unit's hands
	_unit removeItemFromBackpack _weapon;
	_unit addWeapon _weapon;

	// Create a group for the unit and assign them to it
	_group = createGroup [(missionNamespace getVariable ["RS_EnemySide", EAST]), true];
	[_unit] joinSilent _group;
};

/*
	END
*/