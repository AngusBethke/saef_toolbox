class CfgPatches
{
	class SAEF_TOOLBOX_DYNASPAWN
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
	class RS_DS
	{
		class DynaSpawn
		{
			file = "saef_dynaspawn\Functions";
			class DynaSpawn {};
			class Garrison {};
			class GetRandomFormation {};
			class HunterKiller {};
			class InitDS 
			{
				preInit = 1;
			};
			class ParaInsertion {};
			class PositionValidation {};
			class SpawnerGroup {};
			class UnitValidation {};
		};
	};
};