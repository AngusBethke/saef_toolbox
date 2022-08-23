class CfgPatches
{
	class SAEF_TOOLBOX_AMBIENTCOMBAT
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
	class SAEF_AC
	{
		class AmbientCombat
		{
			file = "saef_ambientcombat\Functions";
			class AntiAir {};
			class Armor {};
			class Artillery {};
			class Helpers {};
			class Infantry {};
		};
	};
};