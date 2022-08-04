/*
	fn_Time.sqf

	Description:
		Handles time related functions
*/

params
[
	"_type",
	["_params", []]
];

/*
	---------
	-- GET --
	---------

	Gets the current time in the format [hour, minute, second]
*/
if (toUpper(_type) == "GET") exitWith
{
	private
	[
		"_daytime",
		"_hours",
		"_minutes",
		"_seconds"
	];

	_daytime = dayTime;
	_hours = floor _daytime;
	_minutes = floor ((_daytime - _hours) * 60);
	_seconds = floor ((((_daytime - _hours) * 60) - _minutes) * 60);

	// Returns
	[_hours, _minutes, _seconds]
};

/*
	----------------
	-- DIFFERENCE --
	----------------

	Returns the difference in seconds between a time and the current time
*/
if (toUpper(_type) == "DIFFERENCE") exitWith
{
	_params params ["_timeToCompare"];

	private
	[
		"_ctTotalSeconds",
		"_tcTotalSeconds"
	];

	(["GET"] call SAEF_SPTR_fnc_Time) params ["_ctHours", "_ctMinutes", "_ctSeconds"];
	_ctTotalSeconds = (_ctHours * 60 * 60) + (_ctMinutes * 60) + _ctSeconds;

	_timeToCompare params ["_tcHours", "_tcMinutes", "_tcSeconds"];
	_tcTotalSeconds = (_tcHours * 60 * 60) + (_tcMinutes * 60) + _tcSeconds;

	private
	[
		"_differenceInSeconds"
	];

	_differenceInSeconds = _ctTotalSeconds - _tcTotalSeconds;

	if (_differenceInSeconds < 0) then
	{
		_differenceInSeconds = (24 * 60 * 60) + _differenceInSeconds;
	};

	// Return the difference in seconds
	_differenceInSeconds
};

// Log warning if type is not recognised
["SAEF_SPTR_fnc_Time", 2, (format ["Unrecognised type [%1], nothing is being executed!", _type])] call RS_fnc_LoggingHelper;