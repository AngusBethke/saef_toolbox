/* 
	To Include in config.cpp:
	
	#include "saef_radiation\Images\_RscTitles.hpp"
*/

class RscPicture
{
    access = 0;
    idc = -1;
    type = 0;
    style = 48;
    colorBackground[] = {0,0,0,0};
    colorText[] = {1,1,1,1};
    font = "PuristaLight";
    sizeEx = 1;
    lineSpacing = 0;
    text = "";
    fixedWidth = 0;
    shadow = 0;
};

class Gasmask_RoundEye {
	idd = -1;
	movingEnable = 0;
	duration = 10000;
	fadein = 0;
	fadeout = 0;	
	name = "Gasmask_RoundEye";
	controls[] = {"Picture"};
	class Picture: RscPicture
	{
		x=safeZoneX; y=safeZoneY; w=safeZoneW; h=safeZoneH;
		idc = 1200;
		text = "saef_radiation\Images\Gasmask_RoundEye.paa";
	};
};

class Gasmask_FlatEye {
	idd = -1;
	movingEnable = 0;
	duration = 10000;
	fadein = 0;
	fadeout = 0;	
	name = "Gasmask_FlatEye";
	controls[] = {"Picture"};
	class Picture: RscPicture
	{
		x=safeZoneX; y=safeZoneY; w=safeZoneW; h=safeZoneH;
		idc = 1200;
		text = "saef_radiation\Images\Gasmask_FlatEye.paa";
	};
};