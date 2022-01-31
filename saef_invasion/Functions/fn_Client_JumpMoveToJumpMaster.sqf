/**
	@namespace RS_INV
	@class Invasion
	@method RS_INV_fnc_Client_JumpMoveToJumpMaster
	@file fn_Client_JumpMoveToJumpMaster.sqf
	@summary Moves the unit to the jump master position in the plane
	
	@param object _plane
	@param unit _unit

	@usage ```[_plane, _unit] call RS_INV_fnc_Client_JumpMoveToJumpMaster;```
	
**/

/*
	fn_Client_JumpMoveToJumpMaster.sqf
	
	Description:
		Moves the unit to the jump master position in the plane
		
	How to Call:
		[_plane, _unit] call RS_INV_fnc_Client_JumpMoveToJumpMaster;
		
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

_jumpMasterTurret = [_plane getVariable "LIB_JumpMasterTurretIndex"];

_unit setVariable ["LIB_UnitTurretPlane",_jumpMasterTurret];
[_plane,[_jumpMasterTurret,false]] remoteExec ["lockTurret",_plane];

["RS_INV_fnc_Client_JumpMoveToJumpMaster", 3, (format ["Moving _unit [%1] to turret index (jump master) [%2] in _plane [%3]", _unit, _jumpMasterTurret, _plane])] call RS_fnc_LoggingHelper;
//_unit moveInTurret [_plane,_jumpMasterTurret];
_unit action ["moveToTurret",_plane,_jumpMasterTurret];

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