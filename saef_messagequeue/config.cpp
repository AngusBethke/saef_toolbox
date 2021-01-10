class CfgPatches
{
	class SAEF_TOOLBOX_MESSAGEQUEUE
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
	class RS_MQ
	{
		class MessageQueue
		{
			file = "saef_messagequeue\Functions";
			class MessageDequeue {};
			class MessageExecuter {};
			class MessageEnqueue {};
			class MessageHandler {};
		};
	};
};