/**
	@namespace RS_Rift
	@class TheRift
	@method RS_Rift_fnc_DeleteRiftParticleEffects
	@file fn_DeleteRiftParticleEffects.sqf
	@summary Deletes all rift particle effects

	@param object _object

	@usages ```
	[] call RS_Rift_fnc_DeleteRiftParticleEffects;
	```	@endusages
**/

/*
	fn_DeleteRiftParticleEffects.sqf
	Description: Deletes all rift particle effects
	[] call RS_Rift_fnc_DeleteRiftParticleEffects;
*/

_effects = missionNamespace getVariable ["RS_Rift_ParticleEffectArray", []];

{
	deleteVehicle _x;
} forEach _effects;