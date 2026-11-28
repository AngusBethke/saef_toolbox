/*
	
	fn_TimeUntilGivenTime.sqf

	Description:	
		Sets (returns success boolean) or gets (returns time) time until a given time for various display purposes (in minutes and seconds).
		
	How to Call:	
		[
			_set, 		// Boolean: Whether or not to get or set
			_time,		// Integer: Time in seconds when setting
			_var		// String: Variable we are setting or getting from
		] call SAEF_ASA_fnc_TimeUntilGivenTime;
*/

params
[
	"_set",
	"_time",
	"_var"
];

private
[
	"_availableTime",
	"_min",
	"_sec"
];

if (_set) then
{
	// Is it singleplayer? Set the time remaining
	if (isServer && hasInterface) then
	{
		_availableTime = time + _time;
		missionNamespace setVariable [_var, _availableTime, true];
	}
	else
	{
		_availableTime = serverTime + _time;
		missionNamespace setVariable [_var, _availableTime, true];
	};
	
	// Returns: Booelan Success
	if (true) exitWith {true};
}
else
{
	// Is it singleplayer? Derive the time remaining
	if (isServer && hasInterface) then
	{
		_availableTime = missionNamespace getVariable _var;
		_min = floor((_availableTime - time) / 60);
		_sec = round((_availableTime - time) mod 60);
	}
	else
	{
		_availableTime = missionNamespace getVariable _var;
		_min = floor((_availableTime - serverTime) / 60);
		_sec = round((_availableTime - serverTime) mod 60);
	};
	
	// Returns: Array with Rounded Minutes and Seconds
	if (true) exitWith {[_min, _sec]};
};