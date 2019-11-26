/*
	fn_Handler.sqf
	Description: Handles the radiation
	[_markerList, _size, _unit, _variable] spawn RS_Radiation_fnc_Handler;
*/

private
[
	 "_pos"
	,"_size"
	,"_unit"
	,"_variable"
	,"_selections"
	,"_infCtr"
	,"_message"
	,"_localSize"
	,"_marker"
];

_markerList = _this select 0;
_size = _this select 1;
_unit = _this select 2;
_variable = _this select 3;

// Debug
_localSize = _size;

_selections = 
[
	 "head"
	,"body"
	//,"arm_r"
	//,"arm_l"
	,"leg_r"
	,"leg_l"
];

// Log load to server
_message = format ["[RS] [Radiation] [INFO] Handler started with parameters: %1", [_size, _unit, _variable]];
diag_log _message;
_message remoteExecCall ["diag_log", 2, false]; 

while { (_unit getVariable [_variable, false]) && (alive _unit) } do
{
	if (_size != _localSize) then
	{
		_size = _localSize;
	};
	
	// Get our closest marker
	_marker = "";
	{
		if ((_unit distance (markerPos _x)) < (_unit distance (markerPos _marker))) then
		{
			_marker = _x;
		};
	} forEach _markerList;

	// Set the position for radiation checks
	_pos = markerPos _marker;
	
	//hint format ["Distance %1m away from marker: %2", (_unit distance _pos), _marker];
	
	// Reset Radiation Damage
	{
		_hitPoint = format ["RS_Rad_Damage_%1", _x];
		_unit setVariable [_hitPoint, 0, true];
	} forEach _selections;

	// Light Radiation Zone
	if (((_unit distance _pos) <= _size) && ((_unit distance _pos) > (_size / 2)) && (_unit getVariable [_variable, false]) && (alive _unit)) then
	{
		while { ((_unit distance _pos) <= _size) && ((_unit distance _pos) > (_size / 2)) && (_unit getVariable [_variable, false]) && (alive _unit) } do
		{
			// If our player is not wearing a gasmask, we need to start doing damage to them
			if (!(_unit getVariable ["RS_Radiation_Wearing_Gasmask", false])) then
			{
				//_unit setDamage ((damage _unit) + 0.1);
				{
					_hitPoint = format ["RS_Rad_Damage_%1", _x];
					_damage = (_unit getVariable [_hitPoint, 0]) + 0.1;
					_unit setVariable [_hitPoint, _damage, true];
					
					[_unit, _damage, _x, "backblast"] call ace_medical_fnc_addDamageToUnit;
				} forEach _selections;
			};
			
			// Play Radiation Sound
			[] spawn {
				for "_i" from 1 to 1 do 
				{
					playsound "geiger_counter";
					sleep 0.5;
				};
			};
			
			sleep 12;
		};
	};
	
	// Medium Radiation Zone
	if (((_unit distance _pos) <= (_size / 2)) && ((_unit distance _pos) > (_size / 4)) && (_unit getVariable [_variable, false]) && (alive _unit)) then
	{
		while { ((_unit distance _pos) <= (_size / 2)) && ((_unit distance _pos) > (_size / 4)) && (_unit getVariable [_variable, false]) && (alive _unit) } do
		{
			// If our player is not wearing a gasmask, we need to start doing damage to them
			if (!(_unit getVariable ["RS_Radiation_Wearing_Gasmask", false])) then
			{
				//_unit setDamage ((damage _unit) + 0.25);
				{
					_hitPoint = format ["RS_Rad_Damage_%1", _x];
					_damage = (_unit getVariable [_hitPoint, 0]) + 0.25;
					_unit setVariable [_hitPoint, _damage, true];
					
					[_unit, _damage, _x, "backblast"] call ace_medical_fnc_addDamageToUnit;
				} forEach _selections;
			}
			else
			{
				//_unit setDamage ((damage _unit) + 0.1);
				{
					_hitPoint = format ["RS_Rad_Damage_%1", _x];
					_damage = (_unit getVariable [_hitPoint, 0]) + 0.1;
					_unit setVariable [_hitPoint, _damage, true];
					
					[_unit, _damage, _x, "backblast"] call ace_medical_fnc_addDamageToUnit;
				} forEach _selections;
			};
			
			// Play Radiation Sound
			[] spawn {
				for "_i" from 1 to 3 do 
				{
					playsound "geiger_counter";
					sleep 0.5;
				};
			};
			
			sleep 12;
		};
	};
	
	// Heavy Radiation Zone
	if ((_unit distance _pos) <= (_size / 4) && (_unit getVariable [_variable, false]) && (alive _unit)) then
	{
		while { ((_unit distance _pos) <= (_size / 4)) && (_unit getVariable [_variable, false]) && (alive _unit) } do
		{
			// If our player is not wearing a gasmask, we need to start doing damage to them
			if (!(_unit getVariable ["RS_Radiation_Wearing_Gasmask", false])) then
			{
				//_unit setDamage ((damage _unit) + 1);
				{
					_hitPoint = format ["RS_Rad_Damage_%1", _x];
					_damage = (_unit getVariable [_hitPoint, 0]) + 1;
					_unit setVariable [_hitPoint, _damage, true];
					
					[_unit, _damage, _x, "backblast"] call ace_medical_fnc_addDamageToUnit;
				} forEach _selections;
			}
			else
			{
				//_unit setDamage ((damage _unit) + 0.5);
				{
					_hitPoint = format ["RS_Rad_Damage_%1", _x];
					_damage = (_unit getVariable [_hitPoint, 0]) + 0.5;
					_unit setVariable [_hitPoint, _damage, true];
					
					[_unit, _damage, _x, "backblast"] call ace_medical_fnc_addDamageToUnit;
				} forEach _selections;
			};
			
			// Play Radiation Sound
			[] spawn {
				for "_i" from 1 to 6 do 
				{
					playsound "geiger_counter";
					sleep 0.5;
				};
			};
			
			sleep 12;
		};
	};
	
	sleep 5;
};

diag_log format ["[RS] [Radiation] [INFO] Handler stopped for variable: %1", _variable];

// Make sure if the unit dies and the variable is still active that we restart the handler
waitUntil {
	sleep 10;
	(alive player)
};

if (_unit != player) then
{
	diag_log format ["[RS] [Radiation] [INFO] Unit: %1 is not Player: %2", _unit, player];
	_unit = player;
};

// Restart
if (_unit getVariable [_variable, false]) then
{
	diag_log format ["[RS] [Radiation] [INFO] Handler restarting for variable: %1", _variable];
	[_markerList, _size, _unit, _variable] spawn RS_Radiation_fnc_Handler;
};