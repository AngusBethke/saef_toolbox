/**
	@namespace RS_CP
	@class CivilianPresence
	@method RS_CP_fnc_GetCompatibleFacesFromConfig
	@file fn_GetCompatibleFacesFromConfig.sqf
	@summary 
    
	@param any _unit
	@param any _class

	@return array

**/
/*
	fn_GetCompatibleFacesFromConfig.sqf
*/

params
[
	"_unit",
	"_class"
];

private
[
	"_tags",
	"_headTags",
	"_languageTags",
	"_faceClasses",
	"_faces",
	"_filteredFaces",
	"_voices",
	"_filteredVoices",
	"_face",
	"_voice"
];

// Get tags
_tags = (getArray (configfile >> "CfgVehicles" >> _class >> "identityTypes"));
_headTags = [];
_languageTags = [];
{
	if (["Head", _x, false] call BIS_fnc_inString) then
	{
		_headTags pushBack _x;
	};

	if (["Language", _x, false] call BIS_fnc_inString) then
	{
		_languageTags pushBack _x;
	};
} forEach _tags;

// Get faces
_faceClasses = ("true" configClasses (configfile >> "CfgFaces" >> "Man_A3"));
_faces = [];
{
	_faces pushBack (configName _x);
} forEach _faceClasses;

_filteredFaces = [];
{
	private
	[
		"_face",
		"_tags"
	];

	_face = _x;
	_tags = (getArray (configfile >> "CfgFaces" >> "Man_A3" >> _face >> "identityTypes"));

	{
		if (_x in _tags) then
		{
			_filteredFaces pushBack _face;
		};
	} forEach _headTags;
} forEach _faces;

// Get voices
_voices = (getArray (configfile >> "CfgVoice" >> "voices"));

_filteredVoices = [];
{
	private
	[
		"_voice",
		"_tags"
	];

	_voice = _x;
	_tags = (getArray (configfile >> "CfgVoice" >> _voice >> "identityTypes"));

	{
		if (_x in _tags) then
		{
			_filteredVoices pushBack _voice;
		};
	} forEach _languageTags;
} forEach _voices;

if (!(_filteredFaces isEqualTo [])) then
{
	_face = selectRandom _filteredFaces;
}
else
{
	_face = (face _unit);
};

if (!(_filteredVoices isEqualTo [])) then
{
	_voice = selectRandom _filteredVoices;
}
else
{
	_voice = (speaker _unit);
};

[_face, _voice]