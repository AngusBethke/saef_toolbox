/*
	fn_Client_JumpMoveToStand.sqf
	
	Description:
		Stands the unit up in the plaen
		
	How to Call:
		[_plane, _unit] call RS_INV_fnc_Client_JumpMoveToStand;
		
	Called by:
		fn_Client_RemoteParaPlane.sqf
*/

params
[
	"_plane",
	"_unit"
];

_unitCargoIndexPlane = _plane getCargoIndex _unit;
_unit setVariable ["LIB_UnitCargoIndexPlane",_unitCargoIndexPlane];

_maxGunnerProxy = (_plane getVariable "LIB_JumpMasterTurretIndex") - 2;//minus jump master and door proxy
_unitTurretPlane = [_maxGunnerProxy - _unitCargoIndexPlane];

_unit setVariable ["LIB_UnitTurretPlane",_unitTurretPlane];
[_plane,[_unitTurretPlane,false]] remoteExec ["lockTurret",_plane];

["RS_INV_fnc_Client_JumpMoveToStand", 3, (format ["Moving _unit [%1] to turret index (standing) [%2] in _plane [%3]", _unit, _unitTurretPlane, _plane])] call RS_fnc_LoggingHelper;
//_unit moveInTurret [_plane,_unitTurretPlane];
_unit action ["moveToTurret",_plane,_unitTurretPlane];

[_plane,[_unitCargoIndexPlane,true]] remoteExec ["lockCargo",_plane];

_unit setVariable ["LIB_IsUnitStanding",true];

/* 
	END
*/