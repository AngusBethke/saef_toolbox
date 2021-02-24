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
			"SAEF_TOOLBOX_STATTRACK",
			"SAEF_TOOLBOX_DIAGNOSTICS"
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
			class ForceRespawnSelf {};
			class Handler_TimedRespawn {};
			class Handler_WaveRespawn_PenaltyHandler {};
			class Handler_WaveRespawn_Player_PenaltyTime {};
			class Handler_WaveRespawn {};
			class InitRespawnHandler 
			{
				postInit = 1;
			};
			class PlayerOnKilled {};
			class RespawnDelayedStart {};
			class RespawnHints {};
			class RespawnInformation {};
			class RespawnPlayerHandler {};
			class RespawnPlayerInit {};
			class SpectatorHint {};
		};
	};
};