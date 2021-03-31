/*
	fn_MedicalInfantry.sqf

	Description:
		Adds the basic medical items we frequently use to the player's uniform

	How to Call:
		[
			_unit				// The unit we're applying the loadout to
		] call RS_LD_fnc_MedicalInfantry;
*/

params
[
	"_unit"
];

[_unit, "Uniform", ["ACE_packingBandage", 5]] call RS_LD_fnc_TryAddItems;
[_unit, "Uniform", ["ACE_tourniquet", 2]] call RS_LD_fnc_TryAddItems;
[_unit, "Uniform", ["ACE_morphine", 4]] call RS_LD_fnc_TryAddItems;
[_unit, "Uniform", ["ACE_bloodIV_250", 1]] call RS_LD_fnc_TryAddItems;
[_unit, "Uniform", ["ACE_epinephrine", 1]] call RS_LD_fnc_TryAddItems;