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
			class Admin_3denHelper {};
			class Admin_AddActions 
			{
				postInit = 1;
			};
			class Admin_AddMissionAction {};
			class Admin_CheckAdmin {};
			class Admin_CheckTrigger {};
			class Admin_CheckTrigger_SearchString {};
			class Admin_CreateRespawnPos {};
			class Admin_Init
			{
				postInit = 1;
			};
			class Admin_MissionMakerHelper {};
			class Admin_RunScriptOnServer {};
		};
	};
};

class Cfg3DEN
{
	class EventHandlers
	{
		class RS_3DEN_EventHandlers
		{
			OnMissionSave = "[] call RS_fnc_Admin_3denHelper;";
		};
	};
};