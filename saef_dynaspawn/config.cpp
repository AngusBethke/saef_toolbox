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
			class AddGroupToZeus {};
			class DynamicGarrison {};
			class DynamicGarrisonHandler {};
			class DynaSpawn {};
			class DynaSpawnValidation {};
			class Garrison {};
			class GetClosePositionInBuilding {};
			class GetGarrisonPositions {};
			class GetRandomFormation {};
			class HunterKiller {};
			class ParaInsertion {};
			class PositionValidation {};
			class SpawnerGroup {};
			class TaskPatrol {};
			class UnitValidation {};
		};
	};
};

class Extended_PreInit_EventHandlers {
    class SAEF_DynaSpawn_PreInitEvent {
        init = "call compile preprocessFileLineNumbers 'saef_dynaspawn\Functions\XEH_preInit.sqf'";
    };
};