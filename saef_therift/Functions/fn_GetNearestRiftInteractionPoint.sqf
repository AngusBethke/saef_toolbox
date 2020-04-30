/*
	fn_GetNearestRiftInteractionPoint.sqf
	Description:
		Returns the closest rift interaction point to the player
		
	[player, true] call RS_Rift_fnc_GetNearestRiftInteractionPoint;
*/

params
[
	"_unit",
	["_force", false]
];

_riftObjects = missionNamespace getVariable ["RS_Rift_InteractionPointObjects", []];

_closestObject = objNull;
_closeDistance = 99999;

{
	_riftObject = _x;
	if (!(isNil _riftObject)) then
	{
		_object = (call compile _riftObject);
		if (!(_object getVariable ["RS_Rift_InteractionPointObject_Created", false]) || _force) then
		{
			_distance = _object distance _unit;
			
			if (_distance < _closeDistance) then
			{
				_closestObject = _object;
			};
		};
	};
} forEach _riftObjects;

// Return the closest object to the player
_closestObject

/*
	END
*/