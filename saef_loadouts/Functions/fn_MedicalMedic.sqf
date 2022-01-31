/**
	@namespace RS_LD
	@class Loadouts
	@method RS_LD_fnc_MedicalMedic
	@file fn_MedicalMedic.sqf
	@summary Adds the basic medical items for medics that we frequently use to the player's backpack
	
	@param unit _unit The unit we're applying the loadout to
	@param ?bool _isFirstAid Whether or not this is just a first aid slot (and not a full medic)

	@usage ```[_unit, _isFirstAid] call RS_LD_fnc_MedicalMedic;```
	
**/

/*
	fn_MedicalMedic.sqf

	Description:
		Adds the basic medical items for medics that we frequently use to the player's backpack

	How to Call:
		[
			_unit,				// The unit we're applying the loadout to
			_isFirstAid			// (Optional) Whether or not this is just a first aid slot (and not a full medic)
		] call RS_LD_fnc_MedicalMedic;
*/

params
[
	"_unit",
	["_isFirstAid", false]
];

private
[
	"_bandageSeed",
	"_morphineSplintSeed",
	"_epiTourniquetSeed",
	"_bloodOneLSeed",
	"_bloodHalfLSeed"
];

_bandageSeed = 40;
_morphineSplintSeed = 20;
_epiTourniquetSeed = 10;
_bloodOneLSeed = 8;
_bloodHalfLSeed = 4;

if (_isFirstAid) then
{
	_bandageSeed = 20;
	_morphineSplintSeed = 10;
	_epiTourniquetSeed = 5;
	_bloodOneLSeed = 4;
	_bloodHalfLSeed = 2;
};

// Safe way to add items
[_unit, "Backpack", ["ACE_packingBandage", _bandageSeed]] call RS_LD_fnc_TryAddItems;
[_unit, "Backpack", ["ACE_morphine", _morphineSplintSeed]] call RS_LD_fnc_TryAddItems;
[_unit, "Backpack", ["ACE_splint", _morphineSplintSeed]] call RS_LD_fnc_TryAddItems;
[_unit, "Backpack", ["ACE_epinephrine", _epiTourniquetSeed]] call RS_LD_fnc_TryAddItems;
[_unit, "Backpack", ["ACE_tourniquet", _epiTourniquetSeed]] call RS_LD_fnc_TryAddItems;
[_unit, "Backpack", ["ACE_bloodIV", _bloodOneLSeed]] call RS_LD_fnc_TryAddItems;
[_unit, "Backpack", ["ACE_bloodIV_500", _bloodHalfLSeed]] call RS_LD_fnc_TryAddItems;