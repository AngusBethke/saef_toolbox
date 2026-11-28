/*
	fn_HelicopterInsertion_EnsureDoorsAreOpen.sqf

	Description:
		Ensure vehicle doors are open when close to ground
*/

params
[
	"_vehicle"
];

private
[
	"_animationSources",
	"_doors"
];

_animationSources = configProperties [configfile >> "CfgVehicles" >> (typeOf _vehicle) >> "AnimationSources"];
_doors = [];

{
	private
	[
		"_name"
	];

	_name = configName _x;
	_text = getText (_x >> "source");

	if (["door", _text] call BIS_fnc_inString) then
	{
		_doors pushBack _name;
	};
} forEach _animationSources;

["SAEF Helicopter Insertion", 4, (format ["Vehicle [%1] doors: %2", _vehicle, _doors])] call RS_fnc_LoggingHelper;

if (!(_doors isEqualTo [])) then
{
	while {alive _vehicle} do
	{
		_height = (getPosATL _vehicle) select 2;

		if (_height <= 20) then
		{
			if (!(_vehicle getVariable ["SAEF_ASA_INS_DoorsOpen", false])) then
			{
				{
					_vehicle animateDoor [_x, 1];
				} forEach _doors;

				_vehicle setVariable ["SAEF_ASA_INS_DoorsOpen", true, true];
			};
		}
		else
		{
			if (_vehicle getVariable ["SAEF_ASA_INS_DoorsOpen", false]) then
			{
				{
					_vehicle animateDoor [_x, 0];
				} forEach _doors;

				_vehicle setVariable ["SAEF_ASA_INS_DoorsOpen", false, true];
			};
		};

		sleep 5;
	};
};