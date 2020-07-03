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
		[_plane, _unit] spawn LIB_cargoSwitchtoJumpMasterStatement;
	};
	
	case "TOSTAND": 
	{
		_plane = vehicle _unit;
		[_plane, _unit] spawn LIB_cargoStandUpStatement;
	};
	
	case "TODOOR": 
	{
		_plane = vehicle _unit;
		[_plane, _unit] spawn LIB_cargoMoveToDoorStatement;
		
		sleep 4;
		
		[_plane, _unit] spawn LIB_fnc_deployStaticLine;
		
		if (missionNamespace getVariable ["RS_INV_MisDropItems_Run", true]) then
		{
			[_unit] spawn RS_INV_fnc_Client_MisDropItems;
		};
	};
	
	default {
		["RS_INV_fnc_Client_RemoteParaPlane", 1, (format ["Unrecognised _type variable [%1] for _unit [%2]", _type, _unit]), true] call RS_fnc_LoggingHelper;
	};
};

/* 
	END
*/