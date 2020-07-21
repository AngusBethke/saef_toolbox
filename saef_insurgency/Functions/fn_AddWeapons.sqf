/*
	fn_AddWeapons.sqf
	Description: Adds weapons to the backpacks of the civilian insurgents.
	How to Call:
		[_unit] call RS_INS_fnc_AddWeapons;
*/

params
[
	"_unit"
];

// Get a random weapon from the setup Weapons Array
_weaponArray = selectRandom (missionNamespace getVariable ["RS_Insurgency_WeaponArray", [["arifle_AKS_F", "30Rnd_545x39_Mag_F"]]]);
_weapon = _weaponArray select 0;
_mag = _weaponArray select 1;
	
// Add the weapon to the unit's backpack
_unit addItemToBackpack _weapon;
for "_i" from 1 to 3 do {_unit addItemToBackpack _mag;};

// Set the unit's weapon
_unit setVariable ["RS_Insurgency_HasWeapon", _weapon, true];

/*
	END
*/