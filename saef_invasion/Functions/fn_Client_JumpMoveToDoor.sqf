/*
	fn_Client_JumpMoveToDoor.sqf
	
	Description:
		Moves the unit to the door of the plane
		
	How to Call:
		[_plane, _unit] call RS_INV_fnc_Client_JumpMoveToDoor;
		
	Called by:
		fn_Client_RemoteParaPlane.sqf
*/

params
[
	"_plane",
	"_unit"
];

_unitTurretPlane = _unit getVariable ["LIB_UnitTurretPlane",[]];
_unitCargoIndexPlane = _plane getCargoIndex _unit;

_doorTurret = [_plane getVariable "LIB_DoorTurretIndex"];

_unit setVariable ["LIB_UnitTurretPlane",_doorTurret];
[_plane,[_doorTurret,false]] remoteExec ["lockTurret",_plane];

["RS_INV_fnc_Client_JumpMoveToDoor", 3, (format ["Moving _unit [%1] to turret index (door) [%2] in _plane [%3]", _unit, _doorTurret, _plane]), true] call RS_fnc_LoggingHelper;
//_unit moveInTurret [_plane,_doorTurret];
_unit action ["moveToTurret",_plane,_doorTurret];

if (_unitTurretPlane isEqualTo []) then
{
	_unit setVariable ["LIB_UnitCargoIndexPlane",_unitCargoIndexPlane];

	[_plane,[_unitCargoIndexPlane,true]] remoteExec ["lockCargo",_plane];
	_unit setVariable ["LIB_IsUnitStanding",true];
}
else
{
	[_plane,[_unitTurretPlane,true]] remoteExec ["lockTurret",_plane];
};

/* 
	END
*/