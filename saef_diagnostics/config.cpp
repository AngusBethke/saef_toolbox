class CfgPatches
{
	class SAEF_TOOLBOX_DIAGNOSTICS
	{
		version=2;
		units[]={};
		weapons[]={};
		author="Rabid Squirrel";
		requiredVersion=0.1;
		requiredAddons[]=
		{
			"A3_Data_F",
			"SAEF_TOOLBOX_PLAYER"
		};
	};
};

class CfgFunctions
{
	class RS_DIAG
	{
		class Diagnostics
		{
			file = "saef_diagnostics\Functions";
			class PersistentPerformanceCheck {};
		};
	};
	
	class RS
	{
		class Helpers
		{
			file = "saef_diagnostics\Functions";
			class LoggingHelper {};
			class GetGlobalVariableWithDefault {};
		};
	};
};