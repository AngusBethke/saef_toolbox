class CfgPatches
{
	class SAEF_TOOLBOX_AMBVOICES
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
	class SAEF_AB
	{
		class AmbientVoices
		{
			file = "saef_ambvoices\Functions";
			class Voices {};
		};
	};
};