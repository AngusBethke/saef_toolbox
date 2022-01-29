/**
	@namespace RS_INV
	@class Invasion
	@method RS_INV_fnc_Client_MisDropItems
	@file fn_Client_MisDropItems.sqf
	@summary Removes a random important item from the player's inventory
	
	@param unit _unit

	@usage ```[_unit] spawn RS_INV_fnc_Client_MisDropItems;```
	
**/

/* 
	fn_Client_MisDropItems.sqf 
	
	Description:
		Removes a random important item from the player's inventory
		
	How to call:
		[_unit] spawn RS_INV_fnc_Client_MisDropItems;
	
	Called by:
		fn_Client_RemoteParaPlane.sqf 
*/

params
[
	"_unit"
];

private
[
	"_unit",
	"_type",
	"_pWeap"
];

_type = (selectRandom ["map", "map", "map", "map", "none", "compass", "compass", "compass", "compass", "primaryWeapon"]);
_pWeap = primaryWeapon _unit;

sleep 3;

switch toUpper(_type) do
{
	case "MAP" : {
		_unit unlinkItem "ItemMap";
		_unit removeItem "ItemMap";
	};
	
	case "COMPASS" : {
		_unit unlinkItem "ItemCompass";
		_unit removeItem "ItemCompass";
	};
	
	case "PRIMARYWEAPON" : {
		_unit removeWeapon _pWeap;
	};
	
	default {
		// You got lucky bud
	};
};

waitUntil {
	sleep 1; 
	(((getPos _unit) select 2) < 1.5)
};

/* 
	END
*/