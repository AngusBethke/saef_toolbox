/*
	fn_Target.sqf

	Description:
		Acquires a target for spectating
*/

// Common spectator defines
#include "\A3\Functions_F_Exp_A\EGSpectatorCommonDefines.inc"

params
[
	"_type",
	["_params", []]
];

/*
	---------
	-- GET --
	---------

	Called by the main handler, gets a target based on likelihood of interesting footage
*/
if (toUpper(_type) == "GET") exitWith
{
	private
	[
		"_targetPool",
		"_useTargetPool",
		"_interruptRequester"
	];

	_interruptRequester = (missionNamespace getVariable ["SAEF_SPTR_InterruptRequester", objNull]);
	if (!(isNull _interruptRequester)) exitWith
	{
		missionNamespace setVariable ["SAEF_SPTR_InterruptInProgress", true, true];
		missionNamespace setVariable ["SAEF_SPTR_InterruptRequester", objNull, true];

		// Return the interrupt requester as the target
		[_interruptRequester]
	};

	// Get an accurate target pool
	_targetPool = ([] call RS_PLYR_fnc_GetTruePlayers);

	// If this is the server, then we're going to source all units for the target instead
	if (isServer) then
	{
		_targetPool = (allUnits - (entities "HeadlessClient_F") - (entities "VirtualSpectator_F"));
	};

	// Filter the target pool based on current conditions of given target
	_useTargetPool = [];

	{
		private 
		[
			"_unit",
			"_firedNear"
		];

		_unit = _x;
		_firedNear = _unit getVariable ["SAEF_SPTR_EH_FiredNear_Time", []];

		// If this unit has been in a firefight in the last 30 seconds
		if (!(_firedNear isEqualTo [])) then
		{

			if ((["Difference", [_firedNear]] call SAEF_SPTR_fnc_Time) <= (30 * timeMultiplier)) then
			{
				// If this is infantry, we're going to increase the weight they have in the randomisation
				if ((vehicle _unit) == _unit) then
				{
					for "_i" from 0 to 4 do
					{
						_useTargetPool pushBack _unit;
					};
				}
				else
				{
					_useTargetPool pushBack _unit;
				};
			};
		};

		["SAEF_SPTR_fnc_Target", 4, (format ["Unit [%1] | Velocity: %2 | Position: %3", _unit, (velocityModelSpace (vehicle _unit)), (getPosATL (vehicle _unit))])] call RS_fnc_LoggingHelper;

		// If this unit is travelling quickly and they're relatively low above the ground
		if ((((velocityModelSpace (vehicle _unit)) select 1) >= 30) && (((getPosATL (vehicle _unit)) select 2) <= 100)) then
		{
			for "_i" from 0 to 4 do
			{
				_useTargetPool pushBack (gunner (vehicle _unit));
			}
		};

		// If this unit is travelling very quickly
		if (((velocityModelSpace (vehicle _unit)) select 1) >= 100) then
		{
			for "_i" from 0 to 2 do
			{
				_useTargetPool pushBack _unit;
			}
		};
	} forEach _targetPool;

	if (_useTargetPool isEqualTo []) then
	{
		_useTargetPool = _targetPool;
	};

	// Filter out the most recently used target (so as not to duplicate views)
	private
	[
		"_mostRecentTarget"
	];

	_mostRecentTarget = (missionNamespace getVariable ["SAEF_SPTR_MostRecentTarget", objNull]);

	if (!(isNull _mostRecentTarget)) then
	{
		private
		[
			"_filterdUseTargetPool"
		];

		_filterdUseTargetPool = _useTargetPool - [_mostRecentTarget];

		// If this unit is the only option, rather default to the full pool
		if (!(_filterdUseTargetPool isEqualTo [])) then
		{
			_useTargetPool = _targetPool;
		};
	};

	["SAEF_SPTR_fnc_Target", 4, (format ["Target pool: %1", _useTargetPool])] call RS_fnc_LoggingHelper;

	// Return at random one of those targets
	private
	[
		"_target"
	];

	_target = (selectRandom _useTargetPool);
	missionNamespace setVariable ["SAEF_SPTR_MostRecentTarget", _target];

	// Return target
	[_target]
};

/*
	----------------
	-- TRANSITION --
	----------------

	Smoothly transition camera to new target
*/
if (toUpper(_type) == "TRANSITION") exitWith
{
	_params params
	[
		"_currentTarget",
		"_target"
	];

	private 
	[
		"_camera",
		"_camHelmet",
		"_camGunsLower",
		"_camGunsUpper",
		"_camShoulders"
	];

	_camHelmet = [0.18,-0.15,0.17];
	_camGunsLower = [[0.15,-0.45,0], [-0.15,-0.45,0]];
	_camGunsUpper = [[0.15,0.45,0], [-0.15,0.45,0]];
	_camShoulders = [[2.5,-2.5,1.5], [-2.5,-2.5,1.5]];

	// Lock the camera to it's new owner
	["SetFocus", [_target]] call DISPLAY;

	["SetCameraMode", [(["GETVIEWMODE"] call SAEF_SPTR_fnc_View)]] call CAM;

	if ((["GetCameraMode"] call CAM) == MODE_FOLLOW) then
	{
		_camera = (["GetCamera"] call SPEC);
		_camera cameraEffect ["Terminate", "BACK"];
	};

	if ((["GetCameraMode"] call CAM) == MODE_FPS) then
	{
		_camera = (["GetCamera"] call SPEC);

		// Helmet camera for infantry
		if ((vehicle _target) == _target) exitWith
		{
			_camera switchCamera "Internal";  
			_camera attachTo [_target, _camHelmet, "head", true];
		};

		// Over the should camera for driver of a vehicle
		if (((driver (vehicle _target)) == _target) || ((commander (vehicle _target)) == _target)) exitWith
		{
			_camera switchCamera "Internal";  
			_camera attachTo [(vehicle _target), (selectRandom _camShoulders)];
		};

		// Gun camera for gunner of a vehicle
		if ((gunner (vehicle _target)) == _target) exitWith
		{
			private 
			[
				"_gun"
			];

			_gun = getText (configfile >> "CfgVehicles" >> (typeOf (vehicle _target)) >> "Turrets" >> "MainTurret" >> "memoryPointGun");

			["SAEF_SPTR_fnc_Target", 4, (format ["Gun: %1", _gun])] call RS_fnc_LoggingHelper;

			_camera switchCamera "Internal";  

			if ((format ["%1", _gun]) != "") then
			{
				if ((typeOf (vehicle _target)) isKindOf ["LandVehicle", configFile >> "CfgVehicles"]) then
				{
					_camera attachTo [(vehicle _target), (selectRandom _camGunsUpper), _gun, true];
				}
				else
				{
					_camera attachTo [(vehicle _target), (selectRandom _camGunsLower), _gun, true];
				};
			}
			else
			{
				_camera attachTo [(vehicle _target), (selectRandom _camShoulders)];
			};
		};
	};
};

// Log warning if type is not recognised
["SAEF_SPTR_fnc_Target", 2, (format ["Unrecognised type [%1], nothing is being executed!", _type])] call RS_fnc_LoggingHelper;