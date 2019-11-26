class CfgPatches
{
	class SAEF_TOOLBOX_STATTRACK
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
	class RS_ST
	{
		class StatTrack
		{
			file = "saef_stattrack\Functions";
			class Handler {};
			class InitStatTrack 
			{
				postInit = 1;
			};
			class LogInfo {};
			class LogOnEnd {};
			class TrackDeaths {};
			class TrackPlayers {};
		};
	};
};