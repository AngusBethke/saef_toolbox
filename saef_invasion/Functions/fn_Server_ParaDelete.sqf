/**
	@namespace RS_INV
	@class Invasion
	@method RS_INV_fnc_Server_ParaDelete
	@file fn_Server_ParaDelete.sqf
	@summary Deletes the given parachute when it gets close to the ground
	
	@param object _para

	@usage ```[_para] spawn RS_INV_fnc_Server_ParaDelete;```
	
**/

/* 
	fn_Server_ParaDelete.sqf
	
	Description:
		Deletes the given parachute when it gets close to the ground
		
	How to Call:
		[
			_para
		] spawn RS_INV_fnc_Server_ParaDelete;
		
	Called by:
		fn_Server_AmbientAirDropPara.sqf
*/

params
[
	"_para"
];

waitUntil {
	sleep 5; 
	(((getPos _para) select 2) < 20)
};

deleteVehicle _para;

/*
	END
*/