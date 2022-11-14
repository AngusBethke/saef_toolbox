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

	private
	[
		"_startingPoint"
	];

	_startingPoint = (getPos _unit);

	// Wait two minutes
	sleep 120;
	
	if (alive _unit) then
	{
		// If the unit hasn't moved in the last two minutes then we're going to end them
		if ((_unit distance _startingPoint) < 2.5) then
		{
			[_scriptTag, 2, (format ["[EnsureUnitMoves] Unit [%1] is a lost cause...", _unit])] call RS_fnc_LoggingHelper;
			_unit setDamage 1;
		};
	};
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