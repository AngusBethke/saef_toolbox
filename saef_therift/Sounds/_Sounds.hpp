/* 
	To Include in config.cpp:
	
	#include "saef_therift\Sounds\_Sounds.hpp"
	
	name 		- how the sound is referred to in the editor (e.g. trigger effects)
	sound[]		- filename, volume, pitch, distance
	titles[]	- subtitle delay in seconds, subtitle text
*/

class emp_phase
{
	name = "emp_phase";
	sound[] = {"saef_therift\Sounds\emp_phase.ogg", 1, 1.0};
	titles[] = {0,""};
};

class emp_rift
{
	name = "emp_rift";
	sound[] = {"saef_therift\Sounds\emp_rift.wss", 1, 1.0};
	titles[] = {0,""};
};

class emp_rift_ogg
{
	name = "emp_rift_ogg";
	sound[] = {"saef_therift\Sounds\emp_rift.ogg", 1, 1.0};
	titles[] = {0,""};
};

class emp_boom
{
	name = "emp_boom";
	sound[] = {"saef_therift\Sounds\emp_boom.ogg", 1, 1.0};
	titles[] = {0,""};
};