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
};