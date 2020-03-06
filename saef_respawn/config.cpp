class CfgPatches
{
	class SAEF_TOOLBOX_RESPAWN
	{
		version=2;
		units[]={};
		weapons[]={};
		author="Rabid Squirrel";
		requiredVersion=0.1;
		requiredAddons[]=
		{
			"A3_Data_F",
			"SAEF_TOOLBOX_ADMIN",
			"SAEF_TOOLBOX_STATTRACK"
		};
	};
};

class CfgFunctions
{
	class RS
	{
		class Respawn
		{
			file = "saef_respawn\Functions";
			class InitRespawnHandler 
			{
				postInit = 1;
			};
			class PlayerEventHandlers {};
			class PlayerOnKilled {};
			class RespawnHints {};
			class RespawnDelayedStart {};
			class SpectatorHint {};
		};
	};
};