/*
	fn_Voices.sqf
	Author: Fritz
	Edits: Angus (29-11-2019)
	Version: 0.3
	Description: Plays some custom voices from Menwar (Men of War: Assault Squad 2) in our WW2 Arma Missions
	Execution: 
		[<faction>, <time>] spawn SAEF_AB_fnc_Voices;
		faction - String: "UK", "US", "GER", "RUS", "JAP"	|	Any other entered string will result in the end of the script and an error message
		time - Int: Time in seconds bigger than 30			|	Any integer smaller than 30 will be defaulted to 30 seconds
		
		Execution should be conducted via Script or initServer
*/

if !(isServer) exitWith {};

/* Some Variable Declerations */
_faction = _this select 0;
_time = _this select 1;
_voicesArray = [];
_default = false;

/* Make Faction Lower Case */
_faction = toLower(_faction);

/* Fix time (Smallest amount of time between each voice play) */
if (_time < 30) then
{
	diag_log format ["[fn_voices.sqf] || WARNING !! Time Provided (%1) is too short, changing it to 30 seconds !!", _time];
	_time = 30;
};

/* Get our Voice Arrays from Faction */
switch (_faction) do
{
	case "uk":	{
		_voicesArray = 
		[
			"saef_ambvoices\Sounds\uk\1.ogg", "saef_ambvoices\Sounds\uk\2.ogg", 
			"saef_ambvoices\Sounds\uk\3.ogg", "saef_ambvoices\Sounds\uk\4.ogg", 
			"saef_ambvoices\Sounds\uk\5.ogg", "saef_ambvoices\Sounds\uk\6.ogg", 
			"saef_ambvoices\Sounds\uk\7.ogg", "saef_ambvoices\Sounds\uk\8.ogg", 
			"saef_ambvoices\Sounds\uk\9.ogg", "saef_ambvoices\Sounds\uk\10.ogg", 
			"saef_ambvoices\Sounds\uk\11.ogg"
		];
	};
	
	case "us":	{
		_voicesArray = 
		[
			"saef_ambvoices\Sounds\us\1.ogg", "saef_ambvoices\Sounds\us\2.ogg", 
			"saef_ambvoices\Sounds\us\3.ogg", "saef_ambvoices\Sounds\us\4.ogg", 
			"saef_ambvoices\Sounds\us\5.ogg", "saef_ambvoices\Sounds\us\6.ogg", 
			"saef_ambvoices\Sounds\us\7.ogg", "saef_ambvoices\Sounds\us\8.ogg", 
			"saef_ambvoices\Sounds\us\9.ogg", "saef_ambvoices\Sounds\us\10.ogg", 
			"saef_ambvoices\Sounds\us\11.ogg", "saef_ambvoices\Sounds\us\12.ogg", 
			"saef_ambvoices\Sounds\us\13.ogg", "saef_ambvoices\Sounds\us\14.ogg"
		];
	};
	
	case "ger":	{
		_voicesArray = 
		[
			"saef_ambvoices\Sounds\ger\1.ogg", "saef_ambvoices\Sounds\ger\2.ogg", 
			"saef_ambvoices\Sounds\ger\3.ogg", "saef_ambvoices\Sounds\ger\4.ogg", 
			"saef_ambvoices\Sounds\ger\5.ogg", "saef_ambvoices\Sounds\ger\6.ogg", 
			"saef_ambvoices\Sounds\ger\7.ogg", "saef_ambvoices\Sounds\ger\8.ogg", 
			"saef_ambvoices\Sounds\ger\9.ogg", "saef_ambvoices\Sounds\ger\10.ogg", 
			"saef_ambvoices\Sounds\ger\11.ogg", "saef_ambvoices\Sounds\ger\12.ogg", 
			"saef_ambvoices\Sounds\ger\13.ogg", "saef_ambvoices\Sounds\ger\14.ogg", 
			"saef_ambvoices\Sounds\ger\15.ogg", "saef_ambvoices\Sounds\ger\16.ogg", 
			"saef_ambvoices\Sounds\ger\17.ogg", "saef_ambvoices\Sounds\ger\18.ogg", 
			"saef_ambvoices\Sounds\ger\19.ogg", "saef_ambvoices\Sounds\ger\20.ogg"
		];
	};
	
	case "rus":	{
		_voicesArray = 
		[
			"saef_ambvoices\Sounds\rus\1.ogg", "saef_ambvoices\Sounds\rus\2.ogg", 
			"saef_ambvoices\Sounds\rus\3.ogg", "saef_ambvoices\Sounds\rus\4.ogg", 
			"saef_ambvoices\Sounds\rus\5.ogg", "saef_ambvoices\Sounds\rus\6.ogg", 
			"saef_ambvoices\Sounds\rus\7.ogg", "saef_ambvoices\Sounds\rus\8.ogg", 
			"saef_ambvoices\Sounds\rus\9.ogg", "saef_ambvoices\Sounds\rus\10.ogg", 
			"saef_ambvoices\Sounds\rus\11.ogg", "saef_ambvoices\Sounds\rus\12.ogg", 
			"saef_ambvoices\Sounds\rus\13.ogg", "saef_ambvoices\Sounds\rus\14.ogg", 
			"saef_ambvoices\Sounds\rus\15.ogg", "saef_ambvoices\Sounds\rus\16.ogg", 
			"saef_ambvoices\Sounds\rus\17.ogg", "saef_ambvoices\Sounds\rus\18.ogg", 
			"saef_ambvoices\Sounds\rus\19.ogg", "saef_ambvoices\Sounds\rus\20.ogg", 
			"saef_ambvoices\Sounds\rus\21.ogg"
		];
	};
	
	case "jap":	{
		_voicesArray = 
		[
			"saef_ambvoices\Sounds\jap\1.ogg", "saef_ambvoices\Sounds\jap\2.ogg", 
			"saef_ambvoices\Sounds\jap\3.ogg", "saef_ambvoices\Sounds\jap\4.ogg", 
			"saef_ambvoices\Sounds\jap\5.ogg", "saef_ambvoices\Sounds\jap\6.ogg", 
			"saef_ambvoices\Sounds\jap\7.ogg", "saef_ambvoices\Sounds\jap\8.ogg", 
			"saef_ambvoices\Sounds\jap\9.ogg", "saef_ambvoices\Sounds\jap\10.ogg", 
			"saef_ambvoices\Sounds\jap\11.ogg", "saef_ambvoices\Sounds\jap\12.ogg", 
			"saef_ambvoices\Sounds\jap\13.ogg", "saef_ambvoices\Sounds\jap\14.ogg"
		];
	};
	
	default {
		_default = true
	};
};

/* Will Exit the Script if this condition is met, in the case that an incorrect faction is entered */
if (_default) exitWith
{
	diag_log format ["[fn_Voices.sqf] || ERROR !! Faction Provided (%1) does not Exist !!", _faction];
};


/* Changed from a For Loop to While to make it Last as long as we need, also provided a control to terminate the script if necessary */
missionNamespace setVariable ["FN_Voices_Run", true, true];

while {missionNamespace getVariable ["FN_Voices_Run", false]} do
{
	/*
		I've added this to the while loop so that the pool of players gets updated with each attempted run,
		to include players that have joined in progress and exclude players that have disconnected from the server.
	*/
	_allHCs = entities "HeadlessClient_F";   
	_allHPs = allPlayers - _allHCs;

	/* Select Random Voice Clip */
	_randomvoice = selectRandom _voicesArray;
	
	/* Some String modifications to get the sound to play */
	_soundPath = [(str missionConfigFile), 0, -15] call BIS_fnc_trimString;
	_soundToPlay = _soundPath + _randomvoice;

	/* Play the Sound */
	_sourceObject = selectRandom _allHPs;
	playSound3D [_soundToPlay, _sourceObject, false, getPos _sourceObject, 5, 1, 80]; //Volume db+10, volume drops off to 0 at 50 meters from _sourceObject

	/* Sleep for '_time' before playing next sound */
	sleep _time;
};

/*
	END
*/