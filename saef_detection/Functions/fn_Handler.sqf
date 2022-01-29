/**
	@namespace SAEF_Detection
	@class Detection
	@method SAEF_Detection_fnc_Handler
	@file fn_Handler.sqf
	@summary Handles the detection radius and conditions
	
	@param side _detSide The side(s) of those you want to detect you
	@param ?bool _envIflc Whether or not the environment influences detection (optional)
	@param ?int _standVar The standing radius of detection (optional)
	@param ?int _crouchVar The crouching radius of detection (optional)
	@param ?int _proneVar The proning radius of detection (optional)
	@param ?code _condition Code Code that can be used to interrupt processing

	@note Original Author: Fritz
	@note Modified by: Angus Bethke
**/
/*
	fn_Handler.sqf
	Description: Handles the detection radius and conditions
	Original Author: Fritz
	Modified by: Angus Bethke
	
	How to Call:
		[
			[EAST],	// The side(s) of those you want to detect you
			true,	// Whether or not the environment influences detection (optional)
			30,		// The standing radius of detection (optional)
			10,		// The crouching radius of detection (optional)
			2,		// The proning radius of detection (optional)
			{true}	// Code that can be used to interrupt processing
		] spawn SAEF_Detection_fnc_Handler;
		
	Examples:
		[[EAST], true] spawn SAEF_Detection_fnc_Handler;
		[[EAST, INDEPENDENT], false] spawn SAEF_Detection_fnc_Handler;
*/

params
[
	"_detSide"
	,["_envIflc", false]
	,["_standVar", 30]
	,["_crouchVar", 10]
	,["_proneVar", 2]
	,["_conditionCode", {true}]
];

// Player variable inisialisation
player setVariable ["SAEF_Burst_Over", true, true];
player setVariable ["SAEF_Detection_Run", true, true];
player setVariable ["SAEF_Detection_Debug", false, true];
player setVariable ["SAEF_Player_Detected", false, true];

while {player getVariable ["SAEF_Detection_Run", false]} do 
{
	_check = [player] call _conditionCode;
	if (_check) then
	{
		// If the "Burst" is over we want to run our regular detection process
		if (player getVariable ["SAEF_Burst_Over", true]) then
		{
			_radius = 0;
			_envFac = 1;
			
			if (_envIflc) then
			{
				_hour = floor daytime;
				_hourFac = 0;
				
				// Between 22:00 and 02:00
				if ((_hour <= 2) || (_hour >= 22)) then
				{
					_hourFac = 4 * 1;
				};
				
				// Between 02:00 and 04:00, as well as between 20:00 and 22:00
				if (((_hour > 2) && (_hour <= 4)) || ((_hour >= 20) && (_hour < 22))) then
				{
					_hourFac = 4 * 0.75;
				};
				
				// Between 04:00 and 06:00, as well as between 18:00 and 20:00
				if (((_hour > 4) && (_hour <= 6)) || ((_hour >= 18) && (_hour < 20))) then
				{
					_hourFac = 4 * 0.5;
				};
				
				// Environmental factor can be a max of 5 and a min of 1
				_envFac = 5 - (fog + rain + overcast + _hourFac);
				
				if (_envFac < 1) then
				{
					_envFac = 1;
				};
			};
			
			switch (stance player) do
			{
				case "STAND":
				{
					_radius = (_standVar + ceil(random(ceil(_standVar / 2)))) * _envFac;		// Max-Default: 200 (With Environmental Factor)
				};
				case "CROUCH":
				{
					_radius = (_crouchVar + ceil(random(ceil(_crouchVar / 2)))) * _envFac;		// Max-Default: 75 (With Environmental Factor)
				};
				case "PRONE":
				{
					_radius = (_proneVar + ceil(random(ceil(_proneVar / 2)))) * _envFac;		// Max-Default: 20 (With Environmental Factor)
				};
				
				// Note: if the stance is undetermined, I'm going to use the crouch value
				default 
				{
					_radius = (_crouchVar + ceil(random(ceil(_crouchVar / 2)))) * _envFac;
				};
			};
			
			_nearUnits = (nearestObjects [player, ["Man"], _radius]) select {(side _x) in _detSide};
			if (count _nearUnits > 0) then
			{
				player setCaptive false;
				player setVariable ["SAEF_Player_Detected", true, true];
				
				if (player getVariable "SAEF_Detection_Debug") then
				{
					hint "[SAEF] [Detection] You are in the Detection Radius";
				};
				
				sleep 60;
			}
			else
			{
				player setCaptive true;
				player setVariable ["SAEF_Player_Detected", false, true];
			};
		};
	};
	
	sleep 0.5;
};

/*
	END
*/