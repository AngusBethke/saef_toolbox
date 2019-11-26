/*
	fn_DeleteRiftParticleEffects.sqf
	Description: Deletes all rift particle effects
	[] call RS_Rift_fnc_DeleteRiftParticleEffects;
*/

_effects = missionNamespace getVariable ["RS_Rift_ParticleEffectArray", []];

{
	deleteVehicle _x;
} forEach _effects;