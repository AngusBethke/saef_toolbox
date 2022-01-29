/**
	@namespace RS_BC
	@class BodyCleanup
	@method RS_BC_fnc_DeadBodyCleanUpPersitent
	@file fn_DeadBodyCleanUpPersitent.sqf
	@summary Cleans up dead bodies continuosly until switch off. Should prioritise dead bodies further away.

	@param int _bodyLimit
	@param int _checkInterval
	@param int _instCleanDist

	@note How to Stop: missionNamespace setVariable ["RS_DeadBodyCleanup", false, true];
**/
/*
	fn_DeadBodyCleanUpPersitent.sqf
	Description: Cleans up dead bodies continuosly until switch off. Should prioritise dead bodies further away.
	How to Call: [<bodyLimit: int>, <checkInterval: int>, <instCleanDist: int>] spawn RS_BC_fnc_DeadBodyCleanUpPersitent;
	How to Stop: missionNamespace setVariable ["RS_DeadBodyCleanup", false, true];
*/

params
[
	["_bodyLimit", 20]
	,["_checkInterval", 120]
	,["_instCleanDist", 500]
];

private
[
	"_logName"
	,"_deadUnitArray"
	,"_delNow"
	,"_deadUnits"
	,"_countDead"
	,"_countInsDead"
	,"_countAllDead"
	,"_deleteNum"
];

_logName = "DeadBodyCleanUpPersitent";

// Clean Up Dead Units
while {missionNamespace getVariable ["RS_DeadBodyCleanup", true]} do
{
	// Get our ordered dead body arrays
	_deadUnitArray = [_instCleanDist] call RS_BC_fnc_GetOrderedDeadArray;
	_delNow = _deadUnitArray select 0;
	_deadUnits = _deadUnitArray select 1;
	
	// Counting
	_countDead = (count _deadUnits);
	_countInsDead = (count _delNow);
	_countAllDead = _countDead + _countInsDead;
	_deleteNum = 0;

	// Takes care of the bodies closer to the players
	if (_countAllDead > _bodyLimit) then
	{
		// Immediately takes care of Bodies further away than the threshold for preserving bodies
		{
			deleteVehicle _x;
			_deleteNum = _deleteNum + 1;
		} forEach _delNow;

		[_logName, 3, (format ["%1 dead bodies more than %2m away from players have been deleted", _deleteNum, _instCleanDist])] call RS_fnc_LoggingHelper;
		
		if (_countDead > _bodyLimit) then
		{
			_deleteNum = _countDead - _bodyLimit;
			
			for "_i" from 0 to (_deleteNum - 1) do
			{
				deleteVehicle (_deadUnits select _i);
			};

			[_logName, 3, (format ["%1 dead bodies have been deleted", _deleteNum])] call RS_fnc_LoggingHelper;
		};
	};
	
	sleep _checkInterval;
};

/*
	END
*/