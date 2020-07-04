/* 
	fn_Client_MoveIn.sqf 
	
	Description:
		Moves the unit into the plane
		
	How to Call:
		[
			_type,
			_unit,
			_scripts
		] call RS_INV_fnc_Client_MoveIn;
		
	Called by:
		fn_Client_MountPlayers.sqf
*/

params
[
	"_type",
	"_unit",
	"_scripts"
];

["RS_INV_fnc_Client_MoveIn", 4, (format ["<IN> Parameters: %1", _this]), true] call RS_fnc_LoggingHelper;

// Run any additional scripts
{
	_script = _x;
	[_type, _unit] execVM _script;
} forEach _scripts;

// We do some stuff based on the type given
switch toUpper(_type) do
{
	case "PLANE" : {
		_plane = _unit getVariable "RS_INV_AssignedPlane";
		_unit moveInCargo _plane;
		showHUD false;
		
		if (missionNamespace getVariable ["RS_INV_Flak_Run", true]) then
		{
			[_unit] spawn RS_INV_fnc_Client_Flak;
		};
	};
	
	case "PARA" : {
		_para = _this select 1;
		_unit moveInDriver _para;
		[_unit, _para] spawn RS_INV_fnc_Client_PlayerParaTouchDown;
		
		if (missionNamespace getVariable ["RS_INV_Flak_Run", true]) then
		{
			[_unit] spawn RS_INV_fnc_Client_Flak;
		};
	};
	
	default {
		["RS_INV_fnc_Client_MoveIn", 1, (format ["Unrecognised _type variable [%1] for _unit [%2]", _type, _unit]), true] call RS_fnc_LoggingHelper;
	};
};

["RS_INV_fnc_Client_MoveIn", 4, (format ["<OUT> Parameters: %1", _this]), true] call RS_fnc_LoggingHelper;

/* 
	END 
*/