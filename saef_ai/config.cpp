class CfgPatches
{
	class SAEF_TOOLBOX_AI
	{
		version=2;
		units[]=
		{
			"SAEF_ModulePhysicalArtillery"
		};
		weapons[]={};
		author="Rabid Squirrel";
		requiredVersion=0.1;
		requiredAddons[]=
		{
			"A3_Data_F",
			"SAEF_TOOLBOX_AUTOMATEDSPAWNING",
			"SAEF_TOOLBOX_DIAGNOSTICS",
			"A3_Modules_F"
		};
	};
};

class CfgFunctions
{
	class SAEF_AI
	{
		class AI
		{
			file = "saef_ai\Functions";
			class ModulePhysicalArtillery {};
			class PhysicalArtillery {};
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

	class SAEF_ModulePhysicalArtillery: Module_F
	{
		scope = 2;
		scopeCurator = 0;
		displayName = "Artillery - Physical";
		//icon = "\myTag_addonName\data\iconNuke_ca.paa";
		category = "SAEF_Modules";

		function = "SAEF_AI_fnc_ModulePhysicalArtillery";
		functionPriority = 1;
		isGlobal = 0;
		isTriggerActivated = 1;
		isDisposable = 1;
		is3DEN = 0;

		// Menu displayed when the module is placed or double-clicked on by Zeus
		//curatorInfoType = "RscDisplayAttributesSAEFSpawnArea";

		class Attributes: AttributesBase
		{
			class ShellType: Combo
			{
				property = "SAEF_ModulePhysicalArtillery_ShellType";
				displayName = "Shell Type";
				tooltip = "Type of shell to fire";
				typeName = "STRING";
				defaultValue = """explosive""";
				class Values
				{
					class Explosive		{ name = "Explosive";	value = "explosive"; };
					class Smoke         { name = "Smoke"; 	    value = "smoke"; };
					class Flare		    { name = "Flare"; 	    value = "flare"; };
				};
			};

			class Rounds: Combo
			{
				property = "SAEF_ModulePhysicalArtillery_Rounds";
				displayName = "Rounds";
				tooltip = "Number of rounds to fire";
				typeName = "NUMBER";
				defaultValue = "1";
				class Values
				{
					class One		{ name = "1";	value = 1; };
					class Two	    { name = "2"; 	value = 2; };
					class Four		{ name = "4"; 	value = 4; };
					class Six		{ name = "6"; 	value = 6; };
					class Eight		{ name = "8"; 	value = 8; };
				};
			};

            /*class Spread: Combo
			{
				property = "SAEF_ModulePhysicalArtillery_Spread";
				displayName = "Spread";
				tooltip = "Size of the area to spread the artillery in";
				typeName = "NUMBER";
				defaultValue = "0";
				class Values
				{
					class None		{ name = "0m";	    value = 0; };
					class Close	    { name = "25m"; 	value = 25; };
					class Medium	{ name = "50m"; 	value = 50; };
					class Far		{ name = "100m"; 	value = 100; };
					class VeryFar	{ name = "150m"; 	value = 150; };
					class Longest	{ name = "200m"; 	value = 200; };
				};
			};*/

			class ModuleDescription: ModuleDescription{};
		};

		class ModuleDescription: ModuleDescription
		{
			description = "Creates an artillery target that synchronised units will fire at";
			sync[] = {}; // Array of synced entities (can contain base classes)
		};
	};
};