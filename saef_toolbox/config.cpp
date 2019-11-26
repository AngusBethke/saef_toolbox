class CfgPatches
{
	class SAEF_TOOLBOX
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
class CfgMods
{
	class Mod_Base;
	class SAEF_TOOLBOX: Mod_Base
	{
		author="Rabid Squirrel";
		picture="\saef_toolbox\Data\SAEF_logo_square.paa";
		logo="\saef_toolbox\Data\SAEF_logo_square.paa";
		logoOver="\saef_toolbox\Data\SAEF_logo_square.paa";
		logoSmall="\saef_toolbox\Data\SAEF_logo_square.paa";
		dlcColor[]={0,0,0,1};
		hideName=1;
		hidePicture=0;
		tooltip="SAEF";
		tooltipOwned="SAEF";
		name="SAEF Toolbox";
		overview="SAEF Scripting Toolbox";
		dir="saef_toolbox";
	};
	author="Rabid Squirrel";
};
