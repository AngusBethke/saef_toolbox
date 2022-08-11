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
			class Init 
			{
				postInit = 1;
			};
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
	
	class SAEF_LOG
	{
		class Helpers
		{
			file = "saef_diagnostics\Functions";
			class JsonLogger {};
		};
	};
};