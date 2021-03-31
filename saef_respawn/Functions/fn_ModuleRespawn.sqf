/*
	fn_ModuleRespawn.sqf

	Description:
		Handles module functionality for physical artillery
*/

if (!isServer) exitWith {};

if (is3DEN) exitWith {};

private
[
	"_scriptTag"
];
_scriptTag = "RS_fnc_ModuleRespawn";

// Debug full parameter logging
[_scriptTag, 4, (format ["Debug Parameters: %1", _this])] call RS_fnc_LoggingHelper;

params
[
	 ["_logic", objNull, [objNull]]
	,["_units", [], [[]]]
	,["_activated", true, [true]]
];

// If our module is active then we execute
if (_activated) then 
{
	private
	[
		"_type"
		,"_time"
		,"_holdTime"
		,"_maxTime"
		,"_playerThreshold"
		,"_penaltyTime"
	];

	// Load our variables from the module
	_type = _logic getVariable ["Type", "wave"]; 
	_time = _logic getVariable ["Time", 300]; 
	_holdTime = _logic getVariable ["HoldTime", 30];
	_maxTime = _logic getVariable ["MaxTime", 900];
	_playerThreshold = _logic getVariable ["PlayerThreshold", 5];
	_penaltyTime = _logic getVariable ["PenaltyTime", 0];

	if (toLower(_type) == "wave") then
	{
		// Get our synchronised objects
		private
		[
			"_syncedObjects"
		];

		_syncedObjects = (synchronizedObjects _logic);

		// Get the penalty modules from those synchronised objects
		private
		[
			"_penaltyModules"
		];

		_penaltyModules = [];
		{
			_x params ["_syncedObject"];

			if ((typeOf _syncedObject) == "RS_ModuleRespawnPenalty") then
			{
				_penaltyModules pushBack _syncedObject;
			};

		} forEach _syncedObjects;

		// Loop through the penalty modules and add the penalties
		private
		[
			"_classSpecificPenalties"
		];

		_classSpecificPenalties = [];
		{
			_x params ["_penaltyModule"];

			private
			[
				"_syncedUnits",
				"_penaltyFactor"
			];

			_syncedUnits = (synchronizedObjects _penaltyModule);
			_penaltyFactor = _penaltyModule getVariable ["PenaltyFactor", 0.5];

			{
				_x params ["_syncedUnit"];

				if ((typeOf _syncedUnit) isKindOf ["Man", configFile >> "CfgVehicles"]) then
				{
					_classSpecificPenalties pushBack [(typeOf _syncedUnit), _penaltyFactor];
				};

				// Cleanup the unit when we're done
				deleteVehicle _syncedUnit;

			} forEach _syncedUnits;

			// Cleanup the module when we're done
			deleteVehicle _penaltyModule;

		} forEach _penaltyModules;

		// Kick off the wave handler
		[
			_time,									// Optional: The minimum time for respawn
			_maxTime,								// Optional: The maximum time for respawn
			_holdTime,								// Optional: The time the respawn is held open for
			_playerThreshold,						// Optional: The amount of players required to force the respawn
			_penaltyTime,							// Optional: The base penalty time applied to players for dying
			_classSpecificPenalties					// Optional: An array with penalty indicators to multiply penalties for certain classes
		] spawn RS_fnc_Handler_WaveRespawn;
	};

	if (toLower(_type) == "time") then
	{
		// Kick off the timed handler
		[
			_time,									// Optional: The time between respawn waves
			_holdTime								// Optional: The time the respawn is held open for
		] spawn RS_fnc_Handler_TimedRespawn;
	};
};

// We are going to cleanup the module at this point
deleteVehicle _logic;

// Return Function Success
true