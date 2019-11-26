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
			class Init 
			{
				postInit = 1;
			};
			class ListenerEdit {};
			class MessageExecuter {};
			class MessageFetcher {};
			class MessageHandler {};
			class ParameterErrorMessage {};
			class Readme {};
		};
	};
};