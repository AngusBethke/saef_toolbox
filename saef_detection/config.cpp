class CfgPatches
{
	class SAEF_TOOLBOX_DETECTION
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

class CfgFunctions
{
	class SAEF_Detection
	{
		class Detection
		{
			file = "saef_detection\Functions";
			class Burst {};
			class EventHandler {};
			class Handler {};
			class Init {};
		};
	};
};