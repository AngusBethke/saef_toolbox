class CfgPatches
{
	class SAEF_TOOLBOX_ADMIN
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
		class Admin
		{
			file = "saef_admin\Functions";
			class Admin_AddActions 
			{
				postInit = 1;
			};
			class Admin_AddMissionAction {};
			class Admin_CheckAdmin {};
			class Admin_CreateRespawnPos {};
			class Admin_Init
			{
				postInit = 1;
			};
			class Admin_RunScriptOnServer {};
		};
	};
};