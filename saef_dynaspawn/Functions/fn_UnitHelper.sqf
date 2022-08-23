/**
	@namespace RS_DS
	@class DynaSpawn
	@method RS_DS_fnc_UnitHelper
	@file fn_UnitHelper.sqf
	@summary Handles methods and functionality for units
	
	@param string _type Type of functionality to execute
	@param array _params Params for that function
	

**/

/*
	fn_UnitHelper.sqf

	Description:
		Handles methods and functionality for units

	[
		_type,						// Function type
		_params, 					// Parameters
	] call RS_DS_fnc_UnitHelper;
*/

params
[
	"_type",
	["_params", []]
];

// Set the script tag
private
[
	"_scriptTag"
];

_scriptTag = "RS DS Unit Helper";

/*
	---------------------
	-- ENSUREUNITMOVES --
	---------------------

	Ensures that a spawned unit moves
*/
if (toUpper(_type) == "ENSUREUNITMOVES") exitWith
{
	if (!canSuspend) exitWith
	{
		[_scriptTag, 1, "[EnsureUnitMoves] Requires suspension! Call with 'spawn'..."] call RS_fnc_LoggingHelper;
	};

	_params params
	[
		"_unit"
	];

	([(getPos _unit)] call RS_LC_fnc_InBuilding) params
	[
		"_inside",
		"_building"
	];

	private
	[
		"_buildingPositions",
		"_closestPlayer"
	];
	
	_buildingPositions = [];
	_closestPlayer = [(getPos _unit), 100] call RS_PLYR_fnc_GetClosestPlayerObject;

	if (_inside) then
	{
		// If this building has no building positions, exit with the given position
		if (!((_building buildingPos 0) isEqualTo [0,0,0])) then
		{
			// Get Building Positions for this Building
			private
			[
				"_tBuildingPositions",
				"_triedPositions"
			];

			_tBuildingPositions = [_building] call BIS_fnc_buildingPositions;
			_triedPositions = (_unit getVariable ["SAEF_DS_UnitHelper_TriedPositions", []]);

			{
				if (((_x distance (getPos _unit)) >= 2.5) && !(_x in _triedPositions)) then
				{
					_buildingPositions pushBack _x;
				};
			} forEach _tBuildingPositions;

			if (!(_buildingPositions isEqualTo [])) then
			{
				_unit doMove (selectRandom _buildingPositions);
			};
		};
	};

	// If we have been trying this for longer than two minutes, then just kill the unit
	if (((_unit getVariable ["SAEF_DS_UnitHelper_RepositionCount", 0]) >= 8) && (isNull _closestPlayer)) then
	{
		[_scriptTag, 2, (format ["[EnsureUnitMoves] Unit [%1] is a lost cause...", _unit])] call RS_fnc_LoggingHelper;
		
		_unit setDamage 1;
	};
	
	if (alive _unit) then
	{
		if (_buildingPositions isEqualTo []) then
		{
			_unit doMove (_unit getRelPos [5, (random(360))]);

			// Try and shimy the unit forward until it can move
			if ((_unit getVariable ["SAEF_DS_UnitHelper_RepositionCount", 0]) >= 1) then
			{
				_unit setPos (_unit getRelPos [0.5, 0]);
			};
		};

		// Evaluate for 15 seconds if the unit has moved
		private
		[
			"_startingPoint",
			"_control"
		];

		_startingPoint = (getPos _unit);

		_control = 0;
		waitUntil {
			sleep 1;
			_control = _control + 1;
			(((_unit distance _startingPoint) >= 2.5) || (_control >= 15))
		};

		// If the unit hasn't moved in the last 15 seconds then we're going to recursively call this method
		if (((_unit distance _startingPoint) < 2.5) && (alive _unit)) then
		{
			_closestPlayer = [(getPos _unit), 100] call RS_PLYR_fnc_GetClosestPlayerObject;

			private
			[
				"_repositionCount"
			];

			_repositionCount = _unit getVariable ["SAEF_DS_UnitHelper_RepositionCount", 0];
			_repositionCount = _repositionCount + 1;
			_unit setVariable ["SAEF_DS_UnitHelper_RepositionCount", _repositionCount, true];

			// If there is a different building position available and there is no player close by, move them there
			if (!(_buildingPositions isEqualTo []) && (isNull _closestPlayer)) then
			{
				private
				[
					"_buildingPosition",
					"_triedPositions"
				];

				_buildingPosition = (selectRandom _buildingPositions);

				// Increment tried positions
				_triedPositions = _unit getVariable ["SAEF_DS_UnitHelper_TriedPositions", []];
				_triedPositions pushBack _buildingPosition;
				_unit setVariable ["SAEF_DS_UnitHelper_TriedPositions", _triedPositions, true];

				_unit setPos _buildingPosition;
			};
			
			["EnsureUnitMoves", [_unit]] spawn RS_DS_fnc_UnitHelper;
		}
		else
		{
			// They've managed to move, we can clear the set variables
			_unit setVariable ["SAEF_DS_UnitHelper_TriedPositions", nil, true];
			_unit setVariable ["SAEF_DS_UnitHelper_RepositionCount", nil, true];

			["EnsureUnitMovesDoubleCheck", [_unit]] spawn RS_DS_fnc_UnitHelper;

			[_scriptTag, 4, (format ["[EnsureUnitMoves] for unit [%1] is complete...", _unit])] call RS_fnc_LoggingHelper;
		};
	};
};

/*
	--------------------------------
	-- ENSUREUNITMOVESDOUBLECHECK --
	--------------------------------

	Double checks that a spawned unit is moving
*/
if (toUpper(_type) == "ENSUREUNITMOVESDOUBLECHECK") exitWith
{
	if (!canSuspend) exitWith
	{
		[_scriptTag, 1, "[EnsureUnitMovesDoubleCheck] Requires suspension! Call with 'spawn'..."] call RS_fnc_LoggingHelper;
	};

	_params params
	[
		"_unit"
	];

	private
	[
		"_unitHasMoved"
	];

	_unitHasMoved = 0;

	while {(alive _unit)} do
	{
		// If this unit has been moving for more than 2 minutes then our double check is complete
		if (_unitHasMoved >= 8) exitWith {};
		
		private
		[
			"_startingPoint"
		];

		_startingPoint = (getPos _unit);

		sleep 15;

		// If the unit hasn't moved fall back into the main loop
		if ((_unit distance _startingPoint) < 2.5) exitWith
		{
			["EnsureUnitMoves", [_unit]] spawn RS_DS_fnc_UnitHelper;
		};

		_unitHasMoved = _unitHasMoved + 1;
	};

	[_scriptTag, 4, (format ["[EnsureUnitMovesDoubleCheck] for unit [%1] is complete...", _unit])] call RS_fnc_LoggingHelper;
};

/*
	---------------------
	-- SPAWNPROTECTION --
	---------------------

	Gives the AI 10 seconds of spawn protection to ensure they don't die right after they have spawned
*/
if (toUpper(_type) == "SPAWNPROTECTION") exitWith
{
	if (!canSuspend) exitWith
	{
		[_scriptTag, 2, "[SpawnProtection] Requires suspension! Call with 'spawn'..."] call RS_fnc_LoggingHelper;
	};

	_params params
	[
		"_unit"
	];

	private
	[
		"_closestPlayer"
	];

	// If a player is close by, we don't want to give the AI spawn protection, could lead to some frustrating deaths
	_closestPlayer = [(getPos _unit), 100] call RS_PLYR_fnc_GetClosestPlayerObject;

	if ((isDamageAllowed _unit) && (isNull _closestPlayer)) then
	{
		_unit allowDamage false;

		if ((vehicle _unit) != _unit) then
		{
			(vehicle _unit) allowDamage false;
		};

		sleep 10;

		_unit allowDamage true;

		if ((vehicle _unit) != _unit) then
		{
			(vehicle _unit) allowDamage true;
		};
	};
};

// Log warning if type is not recognised
[_scriptTag, 2, (format ["Unrecognised type [%1], nothing is being executed!", _type])] call RS_fnc_LoggingHelper;