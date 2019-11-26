/*
	fn_CreateRiftParticleEffect.sqf
	Description: Creates a particle effect on a given position
	[object] call RS_Rift_fnc_CreateRiftParticleEffect;
*/

_object = _this select 0;

_source = "#particlesource" createVehicle (position _object); 
_source setParticleParams 
[
	[
		"\A3\data_f\ParticleEffects\Universal\Refract.p3d",
		1,
		0,
		1,
		0
	],
	"",
	"Billboard",
	1,
	1,
	[0,0,-2],
	[0,0,1],
	0,
	1,
	1,
	0,
	[.25,4,4,0],
	[
		[1,1,1,1],
		[1,1,1,1]
	],
	[1.5,0.5],
	0,
	0,
	"",
	"",
	_object
];
_source setDropInterval 0.1;

//_source setParticleClass "Refract";

_effects = missionNamespace getVariable ["RS_Rift_ParticleEffectArray", []];
_effects = _effects + [_source];
missionNamespace setVariable ["RS_Rift_ParticleEffectArray", _effects];