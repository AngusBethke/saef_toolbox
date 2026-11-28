class CfgPatches
{
	class SAEF_TOOLBOX_TASKS
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
	class SAEF_TSK
	{
		class Tasks
		{
			file = "saef_tasks\Functions";
			class Init 
			{
				postInit = 1;
			};
			class Create {};
			class Handle {};
		};
	};

	// Compatibility: the SAEF Mission Framework's former mission-side copy of these helpers
	class SAEF_TSK_CUS
	{
		class Tasks
		{
			file = "saef_tasks\Functions";
			class Create { file = "saef_tasks\Functions\fn_CUS_Create.sqf"; };
			class Handle { file = "saef_tasks\Functions\fn_CUS_Handle.sqf"; };
		};
	};
};