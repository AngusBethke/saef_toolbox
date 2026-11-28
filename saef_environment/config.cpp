class CfgPatches
{
	class SAEF_TOOLBOX_ENVIRONMENT
	{
		version=2;
		units[]={};
		weapons[]={};
		author="Rabid Squirrel";
		requiredVersion=0.1;
		requiredAddons[]=
		{
			"A3_Data_F"
		};
	};
};

/*
	Environment helpers moved from the SAEF Mission Framework (Scripts\Utility\Weather.sqf,
	Scripts\Utility\TurnOffRainTextures.sqf).
*/
class CfgFunctions
{
	class SAEF_ENV
	{
		class Environment
		{
			file = "saef_environment\Functions";
			class WeatherHandler {};
			class DisableRainTextures {};
		};
	};
};