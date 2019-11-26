class CfgPatches
{
	class SAEF_TOOLBOX_HEADLESS
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
	class RS
	{
		class Headless
		{
			file = "saef_headless\Functions";
			class ExecScriptHandler {};
		};
	};
};