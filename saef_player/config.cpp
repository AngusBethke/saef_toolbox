class CfgPatches
{
	class SAEF_TOOLBOX_PLAYER
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
	class RS_PLYR
	{
		class PlayerFunctions
		{
			file = "saef_player\Functions";
			class ForcefulPardon
			{
				postInit = 1;
			};
			class GetClosestPlayer {};
			class GetMarkerNearPlayer {};
			class TellServerPlayerMods {};
			class TogglePlayerHud {};
		};
	};
};