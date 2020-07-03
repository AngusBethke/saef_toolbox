/* 
	fn_Client_PlayerParaTouchDown.sqf 
	
	Description:
		Handles the parachute landing
	
	How to Call:
		[
			_unit,
			_para
		] spawn RS_INV_fnc_Client_PlayerParaTouchDown;
		
	Called by:
		fn_Client_MoveIn.sqf 
*/

params
[
	"_unit",
	"_para"
];

private
[
	"_landedChuteClass",
	"_parachuteObject"
];

waitUntil {
	sleep 0.5; 
	(_unit in _para)
};

_unit allowDamage false;
_para allowDamage false;

waitUntil {
	sleep 0.1; 
	((getPos _unit select 2) < 1.5)
};

if (_unit == player) then
{
	showHUD true;
};

deleteVehicle _para;

_unit switchMove "AmovPercMevaSrasWrflDf_AmovPknlMstpSrasWrflDnon";

if (_unit == player) then
{
	_landedChuteClass = switch (playerSide) do
	{
		case WEST : {
			"LIB_GER_ParachuteLanded"
		};
		
		case EAST : {
			"LIB_SOV_ParachuteLanded"
		};
		
		case RESISTANCE : {
			"LIB_US_ParachuteLanded"
		};
		
		default {
			"LIB_SOV_ParachuteLanded"
		};
	};

	_parachuteObject = _landedChuteClass createVehicle (getPos _unit);
	_parachuteObject addAction ["<t color='#FF0000'>Pack Parachute</t>","_this call LIB_fnc_packParachute"];
};

sleep 1;

_unit allowDamage true;

/* 
	END
*/