/*
	Moved to saef_toolbox from the SAEF Mission Framework (Scripts\Utility\Weather.sqf).
*/

/*
	Weather.sqf
	Version: 0.1

	[] spawn SAEF_ENV_fnc_WeatherHandler;
*/

if !(isServer) exitWith {};

private
[
	"_overcast",
	"_rain",
	"_fogParams"
];

// Get our default settings
_overcast = overcast;
_rain = rain;
_fogParams = fogParams;

0 setOvercast _overcast;
0 setRain _rain;
0 setFog _fogParams;
forceWeatherChange;

["Scripts\Utility\Weather.sqf", 0, (format ["Starting weather handler with variable [RS_Run_WeatherHandler]: %1", [overcast, rain, fogParams]])] call RS_fnc_LoggingHelper;

// Long Cycle
while {missionNamespace getVariable ["RS_Run_WeatherHandler", true]} do
{
	private
	[
		"_timeFactor"
	];

	_timeFactor = 600 + Random(600);
	
	// Half our overall weather impact
	_timeFactor setOvercast (_overcast / 2);
	_timeFactor setRain (_rain / 2);
	_timeFactor setFog _fogParams;

	sleep _timeFactor;
	
	// Reset weather values
	_timeFactor setOvercast _overcast;
	_timeFactor setRain _rain;
	_timeFactor setFog _fogParams;

	sleep _timeFactor;
};