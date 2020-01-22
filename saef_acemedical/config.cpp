class CfgPatches
{
	class SAEF_TOOLBOX_ACEMEDICAL
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
		class PreventFullHeal
		{
			file = "saef_acemedical\Functions";
			class PFH_ApplyDamage {};
			class PFH_Init 
			{
				//postInit = 1;
			};
			class PFH_Prevent {};
			class PFH_ServerDamageDistribution {};
			class PFH_ServerInit 
			{
				//postInit = 1;
			};
		};
	};
};
