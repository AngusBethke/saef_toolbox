class CfgPatches
{
	class SAEF_TOOLBOX_AIDIRECTOR
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
	class SAEF_AID
	{
		class AiDirector
		{
			file = "saef_aidirector\Functions";
			class Difficulty {};
			class Director {};
			class Player {};
		};
	};
};