class CfgPatches
{
	class SAEF_TOOLBOX_CIVILIANPRESENCE
	{
		version=2;
		units[]={};
		weapons[]={};
		author="Rabid Squirrel";
		requiredVersion=0.1;
		requiredAddons[]=
		{
			"A3_Data_F",
			"SAEF_TOOLBOX_LOCATIONS"
		};
	};
};

class CfgFunctions
{
	class RS
	{
		class CivilianPresence
		{
			file = "saef_civilianpresence\Functions";
			class CP_AddCustomLocations {};
			class CP_GetWhiteListedLocations {};
			class CP_Handler {};
			class CP_PreInit 
			{
				PreInit = 1;
			};
			class CP_SpawnPositionModule {};
			class CP_SpawnPresenceModule {};
			class CP_SpawnSafePointModule {};
			class CP_UnitInit {};
		};
	};
};