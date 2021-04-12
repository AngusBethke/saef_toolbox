class CfgPatches
{
	class SAEF_TOOLBOX_LOADOUTS
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
	class RS_LD
	{
		class Loadouts
		{
			file = "saef_loadouts\Functions";
			class AddBalancedItems {};
			class AddGearItem {};
			class AddToRandomisationPool {};
			class ApplyLoadout {};
			class FilterGearPool {};
			class GetItemManipulationCode {};
			class Init 
			{
				postInit = 1;
			};
			class MedicalInfantry {};
			class MedicalMedic {};
			class RemoveExistingItems {};
			class ReplaceMissingRadio {};
			class StandardItems {};
			class TryAddItems {};
		};
	};
};