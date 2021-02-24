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
			class AddToolsAction
			{
				postInit = 1;
			};
			class ForcefulPardon {};
			class GetClosestPlayer {};
			class GetMarkerNearPlayer {};
			class TellServerPlayerMods {};
			class TogglePlayerHud {};
		};
	};
};

class Extended_PreInit_EventHandlers {
    class SAEF_Player_PreInitEvent {
        init = "call compile preprocessFileLineNumbers 'saef_player\Functions\XEH_preInit.sqf'";
    };
};