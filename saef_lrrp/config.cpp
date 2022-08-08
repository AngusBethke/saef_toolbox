class CfgPatches
{
	class SAEF_TOOLBOX_LRRP
	{
		version=2;
		units[]={};
		weapons[]={};
		author="Rabid Squirrel";
		requiredVersion=0.1;
		requiredAddons[]=
		{
			"A3_Data_F",
			"SAEF_TOOLBOX_DIAGNOSTICS"
		};
	};
};

class CfgFunctions
{
	class SAEF_LRRP
	{
		class LongRangeReconPatrol
		{
			file = "saef_lrrp\Functions";
			class CommandTent {};
			class Gear {};
			class Init {};
			class Loadout {};
			class Persistence {};
			class Sounds {};
			class Tent {};
		};
	};
};

class CfgSounds
{
	#include "Sounds\_Sounds.hpp"
};