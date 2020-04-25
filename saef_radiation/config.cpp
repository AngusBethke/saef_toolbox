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
			class ChemicalDetector {};
			class DeferredInit {};
			class GasMaskEventHandler 
			{
				postInit = 1;
			};
			class GasMaskHandler {};
			class GasMaskSound {};
			class GetClosestMarker {};
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

class CfgMarkerBrushes
{
	class CUBISM {
		name="Cubism";
		texture="saef_radiation\Markers\Brushes\cubism.paa";
		drawBorder=0;
		scope=0;
	};
};