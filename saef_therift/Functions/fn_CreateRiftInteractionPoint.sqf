/*
	fn_CreateRiftInteractionPoint.sqf
	Description: Creates position where a player can interact with the rift
	[this, "CTRL"] call RS_Rift_fnc_CreateRiftInteractionPoint;
	[this, "UCTRL", 1] call RS_Rift_fnc_CreateRiftInteractionPoint;
*/

_startObject = _this select 0;
_type = _this select 1;
_way = _this select 2;
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
		
		[[_camera, _camObjects, _focCamera], RS_Rift_fnc_CreateRiftInteractionCamera] remoteExecCall ["call", 0, true];
		
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
		
		// Make it so that this cannot be created twice
		_startObject setVariable ["RS_Rift_InteractionPointObject_Created", true, true];
	};
	default
	{
		diag_log format ["[RS Rift] [CreateRiftInteractionPoint] [ERROR] Unrecognised rift interaction point type %1", _type];
	};
};