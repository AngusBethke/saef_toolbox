class CfgPatches
{
	class SAEF_TOOLBOX_INSURGENCY
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
	class RS_INS
	{
		class Insurgency
		{
			file = "saef_insurgency\Functions";
			class AddWeapons {};
			class CreateInsurgencyPoint {};
			class InsurgencyHandler {};
			class PlaceIeds {};
			class SpawnInsurgent {};
			class SpawnInsurgents {};
			class SwitchToInsurgent {};
			class SwitchToInsurgent_Individual {};
		};
	};
};