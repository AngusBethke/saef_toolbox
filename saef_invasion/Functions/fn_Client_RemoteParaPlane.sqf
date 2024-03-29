/**
	@namespace RS_INV
	@class Invasion
	@method RS_INV_fnc_Client_RemoteParaPlane
	@file fn_Client_RemoteParaPlane.sqf
	@summary Remote execution handler for player interactions within the plane
	
	@param unit _unit
	@param string _type

	@usage ```[_type, _type] spawn RS_INV_fnc_Client_RemoteParaPlane;```
	
**/

/* 
	fn_Client_RemoteParaPlane.sqf 
	
	Description:
		Remote execution handler for player interactions within the plane
		
	How to Call:
		[
			_unit,
			_type
		] spawn RS_INV_fnc_Client_RemoteParaPlane;
		
	Called by:
		fn_Server_PlayerAirDrop.sqf
*/

params
[
	"_unit",
	"_type"
];


switch toUpper(_type) do
{
	case "TOJSTAND": 
	{
		_plane = vehicle _unit;
		["RS_INV_fnc_Client_RemoteParaPlane", 3, (format ["Moving _unit [%1] to Jump Master Position in _plane [%2]", _unit, _plane])] call RS_fnc_LoggingHelper;
		[_plane, _unit] call RS_INV_fnc_Client_JumpMoveToJumpMaster;
	};
	
	case "TOSTAND": 
	{
		_plane = vehicle _unit;
		["RS_INV_fnc_Client_RemoteParaPlane", 3, (format ["Moving _unit [%1] to Standing Position in _plane [%2]", _unit, _plane])] call RS_fnc_LoggingHelper;
		[_plane, _unit] call RS_INV_fnc_Client_JumpMoveToStand;
	};
	
	case "TODOOR": 
	{
		_plane = vehicle _unit;
		["RS_INV_fnc_Client_RemoteParaPlane", 3, (format ["Moving _unit [%1] to the Door in _plane [%2]", _unit, _plane])] call RS_fnc_LoggingHelper;
		[_plane, _unit] call RS_INV_fnc_Client_JumpMoveToDoor;
		
		sleep 4;
		
		[_plane, _unit] spawn LIB_fnc_deployStaticLine;
		
		if (missionNamespace getVariable ["RS_INV_MisDropItems_Run", true]) then
		{
			[_unit] spawn RS_INV_fnc_Client_MisDropItems;
		};

		waitUntil {
			sleep 0.1; 
			((getPos _unit select 2) < 1.5)
		};

		if (_unit == player) then
		{
			showHUD (_unit getVariable ["RS_INV_Hud", shownHUD]);
		};
	};
	
	default {
		["RS_INV_fnc_Client_RemoteParaPlane", 1, (format ["Unrecognised _type variable [%1] for _unit [%2]", _type, _unit])] call RS_fnc_LoggingHelper;
	};
};

/* 
	END
*/