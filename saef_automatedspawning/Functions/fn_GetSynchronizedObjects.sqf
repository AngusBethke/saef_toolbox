/**
	@namespace SAEF_AS
	@class AutomatedSpawning
	@method SAEF_AS_fnc_GetSynchronizedObjects
	@file fn_GetSynchronizedObjects.sqf
	@summary Gets synchronised objects and takes into account the 3DEN editor
	@param object _object The object
**/

/* 
	fn_GetSynchronizedObjects.sqf

	Description: 
		Gets synchronised objects and takes into account the 3DEN editor

	How to Call: 
		[
			_object		// The object
		] call SAEF_AS_fnc_GetSynchronizedObjects;
*/

params
[
	"_object"
];

private
[
	"_syncedObjects"
];

_syncedObjects = [];

// 3DEN Adjustment
if (is3DEN) then
{
	{
		_x params
		[
			"_type",
			"_item"
		];

		if (toLower(_type) == "sync") then
		{
			_syncedObjects pushBack _item;
		};
	} forEach (get3DENConnections _object);
}
else
{
	_syncedObjects = (synchronizedObjects _object);
};

// Return the synchronised objects
_syncedObjects