/**
	@namespace RS_DS
	@class DynaSpawn
	@method RS_DS_fnc_GetRandomFormation
	@file fn_GetRandomFormation.sqf
	@summary Returns a random formation from all available formations
	
	@return string _formation
**/

/*	
	fn_GetRandomFormation.sqf
	Author: Angus Bethke
	Description: 
		Returns a random formation from all available formations
*/

private
[
	"_formations"
	,"_formation"
];

_formations = 
[
	"COLUMN"
	,"STAG COLUMN"
	,"WEDGE"
	,"ECH LEFT"
	,"ECH RIGHT"
	,"VEE"
	,"LINE"
	,"FILE"
	,"DIAMOND"
];

_formation = (selectRandom _formations);

// Returns : String - Formation
_formation

/*
	END
*/