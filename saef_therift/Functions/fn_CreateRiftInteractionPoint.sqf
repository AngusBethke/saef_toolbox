/**
	@namespace RS_Rift
	@class TheRift
	@method RS_Rift_fnc_CreateRiftInteractionPoint
	@file fn_CreateRiftInteractionPoint.sqf
	@summary Creates position where a player can interact with the rift

	@param object _startObject
	@param string _type
	@param any _way

	@usages 
		```
		[this, "CTRL"] call RS_Rift_fnc_CreateRiftInteractionPoint;
		[this, "UCTRL", 1] call RS_Rift_fnc_CreateRiftInteractionPoint;
		```
	@endusages
**/

/*
	fn_CreateRiftInteractionPoint.sqf

	Description: 
		Creates position where a player can interact with the rift

	How to get objects for sites:
		_array = [];

		{
			_array pushBack [typeOf _x, [(_x distance player), (player getRelDir _x)], (getDir _x) - (getDir player)]; 
		} forEach (player nearObjects 10);

		diag_log _array; 

	How to Call:
		[this, "CTRL"] call RS_Rift_fnc_CreateRiftInteractionPoint;
		[this, "UCTRL", 1] call RS_Rift_fnc_CreateRiftInteractionPoint;
*/

params
[
	"_startObject",
	"_type",
	"_way"
];

_relDir = direction _startObject;

switch toUpper(_type) do
{
	case "CTRL": 
	{
		_objects = 
		[
			["Land_Cargo20_military_green_F",[9.13346,48.7063],90],
			["Tarp_01_Large_Black_F",[5.59661,1.02981],0],
			["DeconShower_02_F",[9.77582,0.538026],0],
			["Land_PortableLight_02_double_olive_F",[2.41632,267.035],-213],
			["Land_PortableLight_02_double_olive_F",[2.49026,86.4026],-151],
			["Land_PortableGenerator_01_F",[3.83065,94.5914],-328],
			["Land_PortableWeatherStation_01_olive_F",[5.27852,230.254],-213],
			["DeconShower_02_F",[1.85625,1.6581],-360],
			["RoadCone_F",[5.72612,284.136],0],
			["RoadCone_F",[7.84888,306.653],0],
			["RoadCone_F",[9.42387,318.041],0],
			["RoadCone_F",[11.7499,330.674],0],
			["Land_TripodScreen_01_dual_v1_F",[2.82084,257.402],-143],
			//["B_T_LSV_01_unarmed_F",[7.43256,119.243],-154],
			["Land_TripodScreen_01_large_F",[2.79214,95.902],-201],
			["RoadBarrier_F",[9.97546,327.363],-103],
			["RoadBarrier_F",[6.23903,298.679],-79],
			["RoadBarrier_small_F",[8.15459,315.247],-88]
			//["B_T_Truck_01_box_F",[9.13346,48.7063],0]
		];
		
		_camera = objNull;
		_camObjects = [];
		_focCamera = objNull;

		_control = 0;
		{
			// Declare variables
			_object = _x select 0;
			_position = _x select 1;
			_rotation = _x select 2;
			
			// Get out relative position
			_relPos = _startObject getRelPos [(_position select 0), (_position select 1)];
			
			// Create our object at the relative position
			_obj = createVehicle [_object, _relPos, [], 0, "CAN_COLLIDE"];
			
			// Set direction
			_obj setDir (_relDir - _rotation);
			
			// Get the camera objects
			if (_object == "Land_TripodScreen_01_large_F") then
			{
				_camObjects = _camObjects + [_obj];
			};
			
			if (_object == "Land_TripodScreen_01_dual_v1_F") then
			{
				_camObjects = _camObjects + [_obj];
			};
			
			// Create the particle effect if this is a certain object type
			if (_object == "DeconShower_02_F") then
			{
				[_obj] remoteExecCall ["RS_Rift_fnc_CreateRiftParticleEffect", 0, true];
				[_obj, _control, "REC"] remoteExecCall ["RS_Rift_fnc_CreateRiftInteractionTrigger", 0, true];
				[_obj] spawn RS_Rift_fnc_CreateRiftInteractionSounds;
				
				if (_control > 0) then
				{
					_camera = _obj;
				}
				else
				{
					_focCamera = _obj;
				};
				
				_control = _control + 1;
			};
			
			// Set vehicle specific parameters
			if (_object in ["B_T_Truck_01_box_F", "B_T_LSV_01_unarmed_F"]) then
			{
				_obj setVehicleLock "LOCKEDPLAYER";
				_obj setFuel 0;
			};
			
			if (canSuspend) then
			{
				sleep 1;
			};
			
		} forEach _objects;
		
		[_camera, _camObjects, _focCamera] remoteExecCall ["RS_Rift_fnc_CreateRiftInteractionCamera", 0, true];

		// Register the point
		[_startObject, toUpper(_type)] remoteExecCall ["RS_Rift_fnc_RegisterRiftInteractionPoint", 2, false];
		
		// Make it so that this cannot be created twice
		_startObject setVariable ["RS_Rift_InteractionPointObject_Created", true, true];
	};
	case "UCTRL":
	{
		_objects =
		[
				["Land_ShellCrater_02_debris_F",[0.384062,282.907],357],
				["Land_ShellCrater_02_large_F",[0.477171,325.104],357],
				["Land_W_sharpStone_02",[6.59579,97.4186],357],
				["CUP_kmen_1_buk",[5.57254,311.747],41],
				["CUP_kmen_1_buk",[5.70331,54.9927],122],
				["CUP_kmen_1_buk",[5.0102,197.987],330],
				["CUP_kmen_1_buk",[4.46199,157.183],217]
		];
		
		{
			// Declare variables
			_object = _x select 0;
			_position = _x select 1;
			_rotation = _x select 2;
			
			// Get out relative position
			_relPos = _startObject getRelPos [(_position select 0), (_position select 1)];
			
			// Create our object at the relative position
			_obj = createVehicle [_object, _relPos, [], 0, "CAN_COLLIDE"];
			
			// Set direction
			_obj setDir (_relDir - _rotation);
			
			// Create the particle effect if this is a certain object type
			if (_object == "Land_ShellCrater_02_debris_F") then
			{
				[_obj] remoteExecCall ["RS_Rift_fnc_CreateRiftParticleEffect", 0, true];
				[_obj, _way, "CRL"] remoteExecCall ["RS_Rift_fnc_CreateRiftInteractionTrigger", 0, true];
				[_obj] spawn RS_Rift_fnc_CreateRiftInteractionSounds;
			};
		} forEach _objects;

		// Register the point
		[_startObject, toUpper(_type)] remoteExecCall ["RS_Rift_fnc_RegisterRiftInteractionPoint", 2, false];
		
		// Make it so that this cannot be created twice
		_startObject setVariable ["RS_Rift_InteractionPointObject_Created", true, true];
	};
	case "CPOINT":
	{
		_objects = 
		[
			["Land_Decal_ScorchMark_01_small_F", [0,0], 0, 1.5],
			["PowerCable_01_Roll_F", [2.6624,84.4819], 270],
			["PowerCable_01_Roll_F", [2.76606,200.125], 15],
			["PowerCable_01_Roll_F", [2.5795,308.355], 120],
			["Land_BatteryPack_01_closed_black_F", [2.53954,95.5261], 209.999],
			["Land_BatteryPack_01_closed_black_F", [2.73694,210.872], 315.003],
			["Land_BatteryPack_01_closed_black_F", [2.5836,319.822], 60.0015],
			["SatelliteAntenna_01_Small_Black_F", [2.53324,75.931], 255.002],
			["SatelliteAntenna_01_Small_Black_F", [2.63895,193.25], 15.0044],
			["SatelliteAntenna_01_Small_Black_F", [2.47925,300.402], 120]
		];

		{
			// Declare variables
			_x params
			[
				"_object",
				"_position",
				"_rotation",
				["_height", 0]
			];
			
			// Get out relative position
			_relPos = _startObject getRelPos [(_position select 0), (_position select 1)];
			
			// Set Height
			_relPos = [(_relPos select 0), (_relPos select 1), ((_relPos select 2) + _height)];
			
			// Create our object at the relative position
			_obj = createVehicle [_object, _relPos, [], 0, "CAN_COLLIDE"];

			// Set height if start object is a decent height above the ground
			if (((getPosATL _startObject) select 2) > 0.5) then
			{
				_obj setPosASL [((getPosASL _obj) select 0), ((getPosASL _obj) select 1), (((getPosASL _startObject) select 2) + _height)];
			};
			
			// Set direction
			_obj setDir (_relDir - _rotation);

			// Disable simulation
			_obj enableSimulationGlobal false;
			
			// Create the particle effect if this is a certain object type
			if (_object == "Land_Decal_ScorchMark_01_small_F") then
			{
				[_obj] remoteExecCall ["RS_Rift_fnc_CreateRiftParticleEffect", 0, true];
				[_obj] spawn RS_Rift_fnc_CreateRiftInteractionSounds;
			};
			
			if (canSuspend) then
			{
				sleep 1;
			};
		} forEach _objects;

		// Register the point
		[_startObject, toUpper(_type)] remoteExecCall ["RS_Rift_fnc_RegisterRiftInteractionPoint", 2, false];
		
		// Make it so that this cannot be created twice
		_startObject setVariable ["RS_Rift_InteractionPointObject_Created", true, true];
	};
	case "POINT":
	{
		// Create the particle effect
		[_startObject] remoteExecCall ["RS_Rift_fnc_CreateRiftParticleEffect", 0, true];
		[_startObject] spawn RS_Rift_fnc_CreateRiftInteractionSounds;

		// Register the point
		[_startObject, toUpper(_type)] remoteExecCall ["RS_Rift_fnc_RegisterRiftInteractionPoint", 2, false];
		
		// Make it so that this cannot be created twice
		_startObject setVariable ["RS_Rift_InteractionPointObject_Created", true, true];
	};
	default
	{
		diag_log format ["[RS Rift] [CreateRiftInteractionPoint] [ERROR] Unrecognised rift interaction point type %1", _type];
	};
};