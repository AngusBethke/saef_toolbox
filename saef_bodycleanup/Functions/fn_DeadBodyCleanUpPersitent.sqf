/*
	fn_DeadBodyCleanUpPersitent.sqf
	Description: Cleans up dead bodies continuosly until switch off. Should prioritise dead bodies further away.
	How to Call: [<bodyLimit: int>, <checkInterval: int>, <instCleanDist: int>] spawn RS_BC_fnc_DeadBodyCleanUpPersitent;
	How to Stop: missionNamespace setVariable ["RS_DeadBodyCleanup", false, true];
*/

private
[
	"_debug"
];

// Default Debug, and Change it is the Global Debug Variable is found
_debug = false;
if (!isNil{missionNamespace getVariable "RS_GlobalDebug"}) then
{
	_debug = missionNamespace getVariable "RS_GlobalDebug";
};

missionNamespace setVariable ["RS_DeadBodyCleanup", true, true];
_bodyLimit = _this select 0;
_checkInterval = _this select 1;
_instCleanDist = _this select 2;

/* Clean Up Dead Units */
while {missionNamespace getVariable "RS_DeadBodyCleanup"} do
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
		
		if (_debug) then
		{
			diag_log format ["[DeadBodyCleanUpPersitent] %1 dead bodies more than %2m away from players have been deleted", _deleteNum, _instCleanDist];
		};
		
		if (_countDead > _bodyLimit) then
		{
			_deleteNum = _countDead - _bodyLimit;
			
			for "_i" from 0 to (_deleteNum - 1) do
			{
				_nul = (_deadUnits select _i) spawn 
				{
					hideBody _this;
					sleep 5;
					deleteVehicle _this;
				};
			};
			
			if (_debug) then
			{
				diag_log format ["[DeadBodyCleanUpPersitent] %1 dead bodies have been deleted", _deleteNum];
			};
		};
	};
	
	sleep _checkInterval;
};

/*
	END
*/