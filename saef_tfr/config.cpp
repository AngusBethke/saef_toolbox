class CfgPatches
{
	class SAEF_TOOLBOX_TFR
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
	class RS_TFR
	{
		class TFR
		{
			file = "saef_tfr\Functions";
			class JamTfrRadios {};
		};
	};
};