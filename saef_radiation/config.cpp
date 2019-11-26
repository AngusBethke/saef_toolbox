class CfgPatches
{
	class SAEF_TOOLBOX_RADIATION
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
	class RS_Radiation
	{
		class Radiation
		{
			file = "saef_radiation\Functions";
			class DeferredInit {};
			class GasMaskEventHandler 
			{
				postInit = 1;
			};
			class GasMaskHandler {};
			class GasMaskSound {};
			class GetGridInfo {};
			class Init 
			{
				postInit = 1;
			};
			class Zone {};
			class Handler {};
			class MarkerHandler {};
			class MarkerAceAction {};
			class Markers {};
		};
	};
};

class CfgSounds
{
	#include "Sounds\_Sounds.hpp"
};

class RscTitles
{
	#include "Images\_RscTitles.hpp"
};