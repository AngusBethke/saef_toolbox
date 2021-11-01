/*
	fn_CreateRiftParticleEffect.sqf
	Description: Creates a particle effect on a given position
	[object] call RS_Rift_fnc_CreateRiftParticleEffect;
*/

params
[
	"_object"
];

private
[
	"_source"
];

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

private
[
	"_effects"
];

_effects = missionNamespace getVariable ["RS_Rift_ParticleEffectArray", []];
_effects = _effects + [_source];
missionNamespace setVariable ["RS_Rift_ParticleEffectArray", _effects];

// Link the effect to an object
_object setVariable ["RS_Rift_ParticleEffect_LinkedObject", _source, true];

// Returns the particle source
_source