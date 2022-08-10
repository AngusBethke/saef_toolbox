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
		private
		[
			"_allUnits"
		];

		_allUnits = (allUnits - (entities "HeadlessClient_F"));

		{
			if ((toLower (typeOf _x)) != "virtualspectator_f") then
			{
				_targetPool pushBackUnique _x;
			};
		} forEach _allUnits;

		["SAEF_SPTR_fnc_Target", 4, (format ["Start O - Target pool: %1", _targetPool])] call RS_fnc_LoggingHelper;
	};

	// Remove ignored perspectives from the target pool
	private
	[
		"_ignorePool"
	];

	_ignorePool = [];
	{
		if (_x getVariable ["SAEF_SPTR_IgnoreMe", false]) then
		{
			_ignorePool pushBack _x;
		};
	} forEach _targetPool;

	_targetPool = _targetPool - _ignorePool;

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

		// If this unit is very close to the enemy
		if (["PROXIMITY_TO_ENEMY", [_unit, 10]] call SAEF_SPTR_fnc_Target) then
		{
			["SAEF_SPTR_fnc_Target", 4, (format ["Unit [%1] | Is in very close proximity to enemy (less than 10 meters)...", _unit])] call RS_fnc_LoggingHelper;

			for "_i" from 1 to 5 do
			{
				_useTargetPool pushBack _unit;
			};
		};

		// If this unit has been in a firefight in the last 30 seconds
		if (!(_firedNear isEqualTo [])) then
		{
			if ((["Difference", [_firedNear]] call SAEF_SPTR_fnc_Time) <= (30 * timeMultiplier)) then
			{
				["SAEF_SPTR_fnc_Target", 4, (format ["Unit [%1] | Gunfire has happened nearby in the last 30 seconds...", _unit])] call RS_fnc_LoggingHelper;

				// If this is infantry, we're going to increase the weight they have in the randomisation
				if ((vehicle _unit) == _unit) then
				{
					// If this unit is within the proximity range of bad guys, then we want to increase their weight in the pool
					if (["PROXIMITY_TO_ENEMY", [_unit]] call SAEF_SPTR_fnc_Target) then
					{
						["SAEF_SPTR_fnc_Target", 4, (format ["Unit [%1] | Is in close proximity to enemy...", _unit])] call RS_fnc_LoggingHelper;

						for "_i" from 1 to 5 do
						{
							_useTargetPool pushBack _unit;
						};
					}
					else
					{
						_useTargetPool pushBack _unit;
					};
				}
				else
				{
					["SAEF_SPTR_fnc_Target", 4, (format ["Unit [%1] | Is in a vehicle...", _unit])] call RS_fnc_LoggingHelper;

					_useTargetPool pushBack _unit;
				};
			};
		};

		// If this unit is travelling quickly and they're relatively low above the ground
		if ((((velocityModelSpace (vehicle _unit)) select 1) >= 30) && (((getPosATL (vehicle _unit)) select 2) <= 100)) then
		{
			["SAEF_SPTR_fnc_Target", 4, (format ["Unit [%1] | Is travelling quickly and low...", _unit])] call RS_fnc_LoggingHelper;

			// Prioritise the gunner, their view is more interesting
			for "_i" from 1 to 3 do
			{
				if (!(isNull (gunner (vehicle _unit)))) then
				{
					_useTargetPool pushBack (gunner (vehicle _unit));
				}
				else
				{
					_useTargetPool pushBack _unit;
				};
			};

			for "_i" from 1 to 2 do
			{
				_useTargetPool pushBack _unit;
			};
		};

		// If this unit is travelling very quickly
		if (((velocityModelSpace (vehicle _unit)) select 1) >= 100) then
		{
			["SAEF_SPTR_fnc_Target", 4, (format ["Unit [%1] | Is travelling very quickly...", _unit])] call RS_fnc_LoggingHelper;

			for "_i" from 1 to 3 do
			{
				_useTargetPool pushBack _unit;
			};
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
		if (_filterdUseTargetPool isEqualTo []) then
		{
			_useTargetPool = _targetPool;
		}
		else
		{
			_useTargetPool = _filterdUseTargetPool;
		};
	};

	["SAEF_SPTR_fnc_Target", 4, (format ["Final U - Target pool: %1", _useTargetPool])] call RS_fnc_LoggingHelper;
	["SAEF_SPTR_fnc_Target", 4, (format ["Final O - Target pool: %1", _targetPool])] call RS_fnc_LoggingHelper;

	// Return at random one of those targets
	private
	[
		"_target"
	];

	_target = (selectRandom _useTargetPool);
	missionNamespace setVariable ["SAEF_SPTR_MostRecentTarget", _target];

	["SAEF_SPTR_fnc_Target", 3, (format ["Chosen Target: %1", _target])] call RS_fnc_LoggingHelper;

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
		"_target"
	];

	private 
	[
		"_camera",
		"_camHelmet",
		"_camGunsLower",
		"_camGunsUpper"
	];

	_camHelmet = [0.18,-0.15,0.17];
	_camGunsLower = [[0.15,-0.45,0], [-0.15,-0.45,0]];
	_camGunsUpper = [[0.15,0.45,0], [-0.15,0.45,0]];

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
		// Manage night vision mode
		["MANAGE_NVG", [_target]] spawn SAEF_SPTR_fnc_Target;

		_camera = (["GetCamera"] call SPEC);

		// If this unit is in a vehicle
		if ((vehicle _target) != _target) exitWith
		{
			_camera switchCamera "Internal";

			// Gun camera for gunner of a vehicle
			if ((gunner (vehicle _target)) == _target) exitWith
			{
				private 
				[
					"_optics",
					"_gun"
				];

				_optics = getText (configfile >> "CfgVehicles" >> (typeOf (vehicle _target)) >> "Turrets" >> "MainTurret" >> "memoryPointGunnerOptics");
				_gun = getText (configfile >> "CfgVehicles" >> (typeOf (vehicle _target)) >> "Turrets" >> "MainTurret" >> "memoryPointGun");

				["SAEF_SPTR_fnc_Target", 4, (format ["Gun: %1 | Optics: %2", _gun, _optics])] call RS_fnc_LoggingHelper;

				_camera switchCamera "Internal";  

				// If the optics are an eye point, the _gun memory point will not work, we should default the vehicle view in this case
				if ((_gun != "") && ((toLower _optics) != "eye")) then
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
					_camera attachTo [(vehicle _target), (["GET_CAMERA_POSITION", [(vehicle _target)]] call SAEF_SPTR_fnc_Target)];
				};
			};

			// Default - Over the shoulder camera for vehicle
			_camera attachTo [(vehicle _target), (["GET_CAMERA_POSITION", [(vehicle _target)]] call SAEF_SPTR_fnc_Target)];
		};

		// Default - Helmet camera for infantry
		_camera switchCamera "Internal";  
		_camera attachTo [_target, _camHelmet, "head", true];
	};
};

/*
	----------------
	-- MANAGE_NVG --
	----------------

	Manages night vision
*/
if (toUpper(_type) == "MANAGE_NVG") exitWith
{
	_params params
	[
		"_target"
	];

	while {_target == (["GetFocus"] call DISPLAY)} do
	{
		// Set night vision mode
		if (["USE_NVG", [_target]] call SAEF_SPTR_fnc_View) then
		{
			if (!(player getVariable ["SAEF_SPTR_UsingNVG", false])) then
			{
				player setVariable ["SAEF_SPTR_UsingNVG", true, true];

				camUseNVG true;
				["SET_NVG_COLORCORRECTIONS", [true]] call SAEF_SPTR_fnc_View;
			};
		}
		else
		{
			if (player getVariable ["SAEF_SPTR_UsingNVG", false]) then
			{
				player setVariable ["SAEF_SPTR_UsingNVG", false, true];

				camUseNVG false;
				["SET_NVG_COLORCORRECTIONS", [false]] call SAEF_SPTR_fnc_View;
			};
		};

		sleep 0.25;
	};

	player setVariable ["SAEF_SPTR_UsingNVG", nil, true];
};

/*
	-------------------------
	-- GET_CAMERA_POSITION --
	-------------------------

	Returns appropriate camera position for given vehicle
*/
if (toUpper(_type) == "GET_CAMERA_POSITION") exitWith
{
	_params params
	[
		"_vehicle"
	];

	(["GET_BOUNDING_BOX", [_vehicle]] call SAEF_SPTR_fnc_Target) params
	[
		"_width",
		"_length",
		"_height"
	];

	private
	[
		"_shoulderPositions",
		"_heightFactor"
	];

	_heightFactor = 0.215;

	if (_height <= 4) then
	{
		_heightFactor = 0.35;
	};

	_shoulderPositions =
	[
		[(_width * 0.5), (_length * -0.5), (_height * 0.15)],
		[-(_width * 0.5), (_length * -0.5), (_height * 0.15)]
	];

	if ((typeOf _vehicle) isKindOf ["Air", configFile >> "CfgVehicles"]) then
	{
		_shoulderPositions =
		[
			[(_width * 0.15), (_length * -0.2), (_height * 0.15)],
			[-(_width * 0.15), (_length * -0.2), (_height * 0.15)]
		];
	};

	if ((typeOf _vehicle) isKindOf ["Plane", configFile >> "CfgVehicles"]) then
	{
		_shoulderPositions =
		[
			[(_width * 0.225), (_length * -0.25), (_height * 0.35)],
			[-(_width * 0.225), (_length * -0.25), (_height * 0.35)]
		];
	};

	if (((typeOf _vehicle) isKindOf ["Tank", configFile >> "CfgVehicles"]) 
		|| ((typeOf _vehicle) isKindOf ["Wheeled_Apc_F", configFile >> "CfgVehicles"])) then
	{
		_shoulderPositions =
		[
			[(_width * 0.3), (_length * -0.5), (_height * _heightFactor)],
			[-(_width * 0.3), (_length * -0.5), (_height * _heightFactor)]
		];
	};

	// Return camera position
	(selectRandom _shoulderPositions)
};

/*
	----------------------
	-- GET_BOUNDING_BOX --
	----------------------

	Gets the bounding box of the vehicle
*/
if (toUpper(_type) == "GET_BOUNDING_BOX") exitWith
{
	_params params
	[
		"_vehicle"
	];

	private
	[
		"_setBoundingBoxes",
		"_vehicleSize"
	];

	_setBoundingBoxes = missionNamespace getVariable ["SAEF_SPTR_BoundingBox_Vehicles", []];
	_vehicleSize = [];

	if ((typeOf _vehicle) in _setBoundingBoxes) then
	{
		_vehicleSize = missionNamespace getVariable [(format ["SAEF_SPTR_BoundingBox_%1", (typeOf _vehicle)]), []];
	}
	else
	{
		_vehicleSize = ["SET_BOUNDING_BOX", [_vehicle]] call SAEF_SPTR_fnc_Target;
	};

	if (_vehicleSize isEqualTo []) exitWith
	{
		["SAEF_SPTR_fnc_Target", 2, (format ["Could not find bounding box size for vehicle [%1]!", (typeOf _vehicle)])] call RS_fnc_LoggingHelper;

		// Return 1x1x1 cube size as default
		[1,1,1]
	};

	["SAEF_SPTR_fnc_Target", 4, (format ["Vehicle [%1] width, length, and height %2", (typeOf _vehicle), _vehicleSize])] call RS_fnc_LoggingHelper;

	// Return the vehicle size
	_vehicleSize
};

/*
	----------------------
	-- SET_BOUNDING_BOX --
	----------------------

	Sets the bounding box of the vehicle
*/
if (toUpper(_type) == "SET_BOUNDING_BOX") exitWith
{
	_params params
	[
		"_vehicle"
	];

	private
	[
		"_localVehicle",
		"_boundingBox"
	];

	_localVehicle = (typeOf _vehicle) createVehicleLocal [0,0,0];
	_localVehicle allowDamage false;
	hideObject _localVehicle;

	(boundingBoxReal _localVehicle) params ["_arg1","_arg2"];
	_boundingBox = [(abs ((_arg2 select 0) - (_arg1 select 0))), (abs ((_arg2 select 1) - (_arg1 select 1))), (abs ((_arg2 select 2) - (_arg1 select 2)))];
	deleteVehicle _localVehicle;

	// Set the variable so that we need not do this calculation again
	missionNamespace setVariable [(format ["SAEF_SPTR_BoundingBox_%1", (typeOf _vehicle)]), _boundingBox, true];

	// Return the vehicle bounding box
	_boundingBox
};

/*
	------------------------
	-- PROXIMITY_TO_ENEMY --
	------------------------

	Called by get target, checks unit's proximity to enemy
*/
if (toUpper(_type) == "PROXIMITY_TO_ENEMY") exitWith
{
	_params params
	[
		"_unit",
		["_proximity", 690]
	];

	private
	[
		"_side",
		"_sides",
		"_enemySides"
	];

	_side = side _unit;
	_sides = [WEST, EAST, INDEPENDENT];
	_enemySides = [];

	{
		if ([_x, _side] call BIS_fnc_sideIsEnemy) then
		{
			_enemySides pushBack _x;
		};
	} forEach _sides;

	private
	[
		"_enemyInProximity"
	];

	_enemyInProximity = false;
	{
		if ((_x distance _unit) <= _proximity) then
		{
			if ((side _x) in _enemySides) then
			{
				_enemyInProximity = true;
			};
		};
	} forEach allUnits;

	// Return whether or not an enemy is in proximity
	_enemyInProximity
};

// Log warning if type is not recognised
["SAEF_SPTR_fnc_Target", 2, (format ["Unrecognised type [%1], nothing is being executed!", _type])] call RS_fnc_LoggingHelper;