class CfgPatches
{
	class SAEF_TOOLBOX_BODYCLEANUP
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
	class RS_BC
	{
		class BodyCleanup
		{
			file = "saef_bodycleanup\Functions";
			class DeadBodyCleanUpPersitent {};
			class GetOrderedDeadArray {};
		};
	};
};