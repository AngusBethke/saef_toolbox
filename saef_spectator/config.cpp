class CfgPatches
{
	class SAEF_TOOLBOX_SPECTATOR
	{
		version=2;
		units[]={};
		weapons[]={};
		author="Rabid Squirrel";
		requiredVersion=0.1;
		requiredAddons[]=
		{
			"A3_Data_F",
			"SAEF_TOOLBOX_PLAYER"
		};
	};
};

class CfgFunctions
{
	class SAEF_SPTR
	{
		class Spectator
		{
			file = "saef_spectator\Functions";
			class Init 
			{
				PostInit = 1;
			};
			class Action {};
			class EventHandler {};
			class Handler {};
			class Target {};
			class Time {};
			class View {};
		};
	};
};