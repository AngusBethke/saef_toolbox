/*
	fn_Handler.sqf

	Description:
		Handles the spectator
*/

// Common spectator defines
#include "\A3\Functions_F_Exp_A\EGSpectatorCommonDefines.inc"

params
[
	"_type",
	["_params", []]
];

/*
	---------------
	-- SPECTATOR --
	---------------

	Runs the spectator handler
*/
if (toUpper(_type) == "SPECTATOR") exitWith
{
	// Mark that this player (spectator entity) should run the main loop
	player setVariable ["SAEF_Spectator_Run", true, true];

	// Specific settings for the spectator object
	["SPECTATOR_ENTITY_ADJUSTMENTS"] call SAEF_SPTR_fnc_Handler;

	["SAEF_SPTR_fnc_Handler", 0, "Initialising the spectator handler..."] call RS_fnc_LoggingHelper;

	// Get rid of the UI
	if (missionNamespace getVariable ["SAEF_SPTR_Destroy_UI", false]) then
	{
		["DestroyDisplay"] spawn SPEC;
	};

	// Wait a few seconds
	sleep 2;

	// If we're currently in third person, adjust the camera
	if ((["GetCameraMode"] call CAM) == MODE_FOLLOW) then
	{
		(["GetCamera"] call SPEC) cameraEffect ["Terminate", "BACK"];
	};

	// Main loop picks a new target to look at every x seconds
	while {(player getVariable ["SAEF_Spectator_Run", false])} do
	{
		(["Get"] call SAEF_SPTR_fnc_Target) params
		[
			["_target", objNull]
		];
		
		if (!(isNull _target)) then
		{
			// Set the current spectator target
			private "_currentTarget";
			_currentTarget = (["GetFocus"] call DISPLAY);

			if (_currentTarget != _target) then
			{
				["Transition", [_target]] spawn SAEF_SPTR_fnc_Target;
				player attachTo [_target, [0,0,5]];
			};
		};
		
		// Manage the delay with interrupt functionality
		private
		[
			"_delay",
			"_sleepTime",
			"_currentVehicle",
			"_i"
		];

		_sleepTime = 0.25;
		_delay = ((["GETSWITCHDELAY"] call SAEF_SPTR_fnc_View) / _sleepTime);
		_currentVehicle = (vehicle _target);

		_i = 1;
		while {_i <= _delay} do
		{
			// If the target dies we need to reset
			if (!(alive _target) || !(alive (vehicle _target)) || (_target getVariable ["ACE_isUnconscious", false])) then
			{
				_i = _delay;
				sleep 3;
			};

			// If the target's vehicle changes we should shift perspective
			if (_currentVehicle != (vehicle _target)) then
			{
				["Transition", [_target]] spawn SAEF_SPTR_fnc_Target;
				_currentVehicle = (vehicle _target);
			};

			if (!(missionNamespace getVariable ["SAEF_SPTR_InterruptInProgress", false])) then
			{
				// If someone requests an interrupt then we need to reset
				private
				[
					"_interruptRequester"
				];

				_interruptRequester = (missionNamespace getVariable ["SAEF_SPTR_InterruptRequester", objNull]);
				if (!(isNull _interruptRequester)) then
				{
					_i = _delay;
				};
			};

			// Manage the delay
			sleep _sleepTime;
			_i = _i + 1;
		};

		// If we complete the loop, we need to ensure interrupt is no longer in progress
		missionNamespace setVariable ["SAEF_SPTR_InterruptInProgress", false, true];
	};

	["SAEF_SPTR_fnc_Handler", 0, "Ending the spectator handler..."] call RS_fnc_LoggingHelper;
};

/*
	----------------------------------
	-- SPECTATOR_ENTITY_ADJUSTMENTS --
	----------------------------------

	Gets the preferred view mode
*/
if (toUpper(_type) == "SPECTATOR_ENTITY_ADJUSTMENTS") exitWith
{
	// Ensure that this spectator is no-longer an ace player
	ACE_player = objNull;

	// Set necessary variables for this spectator
	missionNamespace setVariable ["saef_spectator_isSet", player];

	// Apply changes to this spectator object
	player allowDamage false;
	player enableSimulationGlobal false;
	player enableFatigue false;
	player enableStamina false;
	[player, true] remoteExec ["hideObjectGlobal", 2, true];

	// Register this camera as the saef spectator
	_result = ["saef_spectator", {!isNull (missionNamespace getVariable ["saef_spectator_isSet", objNull])}] call CBA_fnc_registerFeatureCamera;

	if (!_result) then
	{
		["SAEF_SPTR_fnc_Handler", 2, "Unable to register the [saef_spectator] camera with the CBA_fnc_registerFeatureCamera"] call RS_fnc_LoggingHelper;
	};
};

/*
	-------------------------
	-- DEBUG_LOG_VARIABLES --
	-------------------------

	Logs all variables with given key
*/
if (toUpper(_type) == "DEBUG_LOG_VARIABLES") exitWith
{
	_params params
	[
		"_variableKey"
	];

	{
		if ([_variableKey, _x] call BIS_fnc_inString) then
		{
			["SAEF_SPTR_fnc_Handler", 0, (format ["%1 variable: [%2, %3]", _variableKey, _x, (player getVariable _x)])] call RS_fnc_LoggingHelper;
		};
	} forEach (allVariables player);
};

/*
	-------------------
	-- GETSPECTATORS --
	-------------------

	Gets the preferred view mode
*/
if (toUpper(_type) == "GETSPECTATORS") exitWith
{
	private
	[
		"_spectators"
	];

	_spectators = [];

	{
		if ((typeOf _x) == "VirtualSpectator_F") then
		{
			_spectators pushBack _x;
		};
	} forEach allPlayers;

	// Return spectators
	_spectators
};

// Log warning if type is not recognised
["SAEF_SPTR_fnc_Handler", 2, (format ["Unrecognised type [%1], nothing is being executed!", _type])] call RS_fnc_LoggingHelper;