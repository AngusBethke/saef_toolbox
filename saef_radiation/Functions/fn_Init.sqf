/*
	fn_Init.sqf
	Description: Initialise
	Author: Angus Bethke a.k.a. Rabid Squirrel
*/

_compatGasMasks = 
[
	["G_mas_idf_gasmask", "Gasmask_RoundEye"],
	["G_mas_idf_gasmask_C", "Gasmask_RoundEye"],
	["G_RegulatorMask_F", "RscCBRN_Regulator"],
	["G_AirPurifyingRespirator_02_black_F", "RscCBRN_APR_02"],
	["G_AirPurifyingRespirator_02_olive_F", "RscCBRN_APR_02"],
	["G_AirPurifyingRespirator_02_sand_F", "RscCBRN_APR_02"],
	["G_AirPurifyingRespirator_01_F", "RscCBRN_APR"],
	["G_AirPurifyingRespirator_01_nofilter_F", "RscCBRN_APR"]
];

// SP Debug
if (hasInterface && isServer) then
{
	missionNamespace setVariable ["RS_Radiation_CompatibleGasMasks", _compatGasMasks, true];
};

// Server
if (!hasInterface && isServer) then
{
	missionNamespace setVariable ["RS_Radiation_CompatibleGasMasks", _compatGasMasks, true];
};

// Player
if (hasInterface) then
{
	[] spawn RS_Radiation_fnc_DeferredInit;
};	
