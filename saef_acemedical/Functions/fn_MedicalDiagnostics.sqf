// Gain access to variables
#include "\z\ace\addons\medical_treatment\script_component.hpp"

/*
	fn_MedicalDiagnostics.sqf
	Description: Allows medics to check if a player currently has any injuries that are not obvious
	Author: Angus Bethke (a.k.a. Rabid Squirrel)
*/

params ["_patient"];

if (!alive _patient) exitWith {};

_diagString = format [(
	"Medical Debug" + "\n"
	"Pain: %1" + "\n"
	"Blood Volume: %2" + "\n"
	"Tourniquets: %3" + "\n"
	"Occluded Medications: %4" + "\n"
	"Open Wounds: %5" + "\n"
	"Bandaged Wounds: %6" + "\n"
	"Stitched Wounds: %7" + "\n"
	"Is Limping: %8" + "\n"
	"Fractures: %9" + "\n"
	"Heart Rate: %10" + "\n"
	"Blood Pressure: %11" + "\n"
	"Periph Res: %12" + "\n"
	"IV Bags: %13" + "\n"
	"Body Part Damage: %14" + "\n"
	"Hemorrhage: %15" + "\n"
	"In Pain: %16" + "\n"
	"Pain Suppression: %17" + "\n"
	"Medications: %18"
	),

	// Get Pain Level and Blood Volume
	_patient getVariable VAR_PAIN,
	_patient getVariable VAR_BLOOD_VOL,

	// Tourniquets
	_patient getVariable VAR_TOURNIQUET,
	_patient getVariable QGVAR(occludedMedications),

	// Wounds and Injuries
	_patient getVariable VAR_OPEN_WOUNDS,
	_patient getVariable VAR_BANDAGED_WOUNDS,
	_patient getVariable VAR_STITCHED_WOUNDS,
	_patient getVariable QEGVAR(medical,isLimping),
	_patient getVariable VAR_FRACTURES,

	// Vitals
	_patient getVariable VAR_HEART_RATE,
	_patient getVariable VAR_BLOOD_PRESS,
	_patient getVariable VAR_PERIPH_RES,

	// IVs
	_patient getVariable QEGVAR(medical,ivBags),

	// Damage storage
	_patient getVariable QEGVAR(medical,bodyPartDamage),

	// Generic medical admin
	_patient getVariable VAR_HEMORRHAGE,
	_patient getVariable VAR_IN_PAIN,
	_patient getVariable VAR_PAIN_SUPP,

	// Medication
	_patient getVariable VAR_MEDICATIONS
];

_diagString

/*
	END
*/