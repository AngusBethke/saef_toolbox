class CfgPatches
{
	class SAEF_TOOLBOX_VEHICLE
	{
		version=2;
		units[]=
		{
			"SAEF_ModuleRearmAndRepair",
			"SAEF_ModuleRearmAndRepairVehicle",
			"SAEF_ModuleRearmAndRepairObject"
		};
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
	class SAEF_VEH
	{
		class RearmAndRepair
		{
			file = "saef_vehicle\Functions";
			class ModuleRearmAndRepair {};
			class RnR_ActionRearm {};
			class RnR_ActionRespawn {};
			class RnR_AddToInitQueue {};
			class RnR_GlobalRename {};
			class RnR_Init 
			{
				postInit = 1;
			};
			class RnR_InitQueueHandler {};
			class RnR_PlayerSetup {};
			class RnR_Rearm {};
			class RnR_Respawn {};
			class RnR_Setup {};
		};
	};
};

class CfgVehicles
{
	class Logic;

	class Module_F: Logic
	{
		class AttributesBase
		{
			class Default;
			class Edit;					// Default edit box (i.e., text input field)
			class Combo;				// Default combo box (i.e., drop-down menu)
			class Checkbox;				// Default checkbox (returned value is Boolean)
			class CheckboxNumber;		// Default checkbox (returned value is Number)
			class ModuleDescription;	// Module description
			class Units;				// Selection of units on which the module is applied
		};
		// Description base classes, for more information see below
		class ModuleDescription
		{
			class AnyBrain;
		};
	};

	class SAEF_ModuleRearmAndRepair: Module_F
	{
		scope = 2;
		scopeCurator = 0;
		displayName = "Vehicle - Rearm and Repair (Core)";
		category = "SAEF_Modules";

		function = "SAEF_VEH_fnc_ModuleRearmAndRepair";
		functionPriority = 1;
		isGlobal = 0;
		isTriggerActivated = 1;
		isDisposable = 1;
		is3DEN = 0;

		class Attributes: AttributesBase
		{
			class AllowedClassnames: Edit
			{
				property = "SAEF_ModuleRearmAndRepair_AllowedClassnames";
				displayName = "Allowed Classnames";
				tooltip = "(Optional) Classnames of units allowed to perform these actions (comma ',' delimited)";
				defaultValue = """""";
			};

			class AdditionalScripts: Edit
			{
				property = "SAEF_ModuleRearmAndRepair_AdditionalScripts";
				displayName = "Additional Scripts";
				tooltip = "(Optional) Nested array of additional scripts and parameters that will be executed against the vehicle";
				defaultValue = """""";
			};

			class ModuleDescription: ModuleDescription{};
		};

		class ModuleDescription: ModuleDescription
		{
			description = "Handles the creation of a vehicle rearm and repair handler";
			sync[] = {};
		};
	};

	class SAEF_ModuleRearmAndRepairVehicle: Module_F
	{
		scope = 2;
		scopeCurator = 0;
		displayName = "Vehicle - Rearm and Repair (Vehicle)";
		category = "SAEF_Modules";

		functionPriority = 1;
		isGlobal = 0;
		isTriggerActivated = 1;
		isDisposable = 1;
		is3DEN = 0;

		class Attributes: AttributesBase
		{
			class ModuleDescription: ModuleDescription{};
		};

		class ModuleDescription: ModuleDescription
		{
			description = "This should be synchronised to the vehicle you want to be able to rearm and repair";
			sync[] = {};
		};
	};

	class SAEF_ModuleRearmAndRepairObject: Module_F
	{
		scope = 2;
		scopeCurator = 0;
		displayName = "Vehicle - Rearm and Repair (Object)";
		category = "SAEF_Modules";

		functionPriority = 1;
		isGlobal = 0;
		isTriggerActivated = 1;
		isDisposable = 1;
		is3DEN = 0;

		class Attributes: AttributesBase
		{
			class ModuleDescription: ModuleDescription{};
		};

		class ModuleDescription: ModuleDescription
		{
			description = "This should be synchronised to the object you want to be able to rearm and repair from";
			sync[] = {};
		};
	};
};