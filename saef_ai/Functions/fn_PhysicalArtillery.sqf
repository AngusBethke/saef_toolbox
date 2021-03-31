/*
	fn_PhysicalArtillery.sqf

	Description: 
		Gets specified vehicles to fire at a given location with a specified amount of rounds

	How to Call: 
		[
			_vehicles,			// Vehicles that are firing at these positions
			_positions, 		// Positions being fired at
			_rounds,			// Number of rounds fired per position
			_shellType,			// (Optional) Type of shell to fire in the salvo
			_spread				// (Optional) The spread in meters for the artillery target
		] spawn SAEF_AI_fnc_PhysicalArtillery;
*/

params
[
	"_vehicles",
	"_positions",
	"_rounds",
	["_shellType", "explosive"],
	["_spread", 0]
];

private
[
	"_scriptTag"
];
_scriptTag = "SAEF_AI_fnc_PhysicalArtillery";

{
	_x params ["_vehicle"];

	{
		private
		[
			"_position"
		];

		_position = _x;

		// Validate the ammo
		private
		[
			"_ammoArray"
		];

		_vehicle setVehicleAmmo 1;
		_ammoArray = (getArtilleryAmmo [(vehicle _vehicle)]);

		if (_ammoArray isEqualTo []) exitWith
		{
			[_scriptTag, 2, (format["Unable to find artillery ammo for vehicle [%1], artillery will not fire!", _vehicle])] call RS_fnc_LoggingHelper;
		};

		// Find the shell type
		private
		[
			"_ammo",
			"_foundAmmoType"
		];

		// Get default ammo
		_ammo = (_ammoArray select 0);
		_foundAmmoType = true;

		// Set the shell type
		if (toLower(_shellType) != "explosive") then
		{
			_foundAmmoType = false;
			{
				if ([_shellType, _x] call BIS_fnc_inString) exitWith
				{
					_foundAmmoType = true;
					_ammo = _x;
				};
			} forEach _ammoArray;
		};

		if (!_foundAmmoType) exitWith
		{
			[_scriptTag, 2, (format["Unable to find ammo type for vehicle [%1] with shell type [%2], artillery will not fire!", _vehicle, _shellType])] call RS_fnc_LoggingHelper;
		};

		// Validate the range
		private
		[
			"_isInRange"
		];

		_isInRange = _position inRangeOfArtillery [[_vehicle], _ammo];

		if (!_isInRange) exitWith
		{
			[_scriptTag, 2, (format["Position [%1] is not in range of vehicle [%2], artillery will not fire!", _position, _vehicle])] call RS_fnc_LoggingHelper;
		};

		// Get the group leader
		private
		[
			"_groupLeader"
		];

		_groupLeader = (leader ((crew _vehicle) select 0));

		// Fire the gun
		[_scriptTag, 4, (format["Vehicle [%1] firing at position %2 with ammo [%3], round count [%4] and spread [%5] ...", _vehicle, _position, _ammo, _rounds, _spread])] call RS_fnc_LoggingHelper;

		if (_spread > 0) then
		{
			for "_i" from 1 to _rounds do
			{
				private
				[
					"_modPos"
				];

				_modPos = [(((_position select 0) - _spread) + random (_spread * 2)), (((_position select 1) - _spread) + random (_spread * 2)), 0];

				// Check locality for the order
				if (local _groupLeader) then
				{
					_vehicle commandArtilleryFire [_position, _ammo, 1];
				}
				else
				{
					[_vehicle, [_position, _ammo, 1]] remoteExecCall ["commandArtilleryFire", (owner _groupLeader), false];
				};
			};
		}
		else
		{
			// Check locality for the order
			if (local _groupLeader) then
			{
				_vehicle commandArtilleryFire [_position, _ammo, _rounds];
			}
			else
			{
				[_vehicle, [_position, _ammo, _rounds]] remoteExecCall ["commandArtilleryFire", (owner _groupLeader), false];
			};
		};
		
	} forEach _positions;

} forEach _vehicles;
