/*
	fn_CustomCallsigns.sqf

	Description:
		Returns custom callsigns if any

	How to Call:
		[_callsigns] call SAEF_ASA_fnc_CustomCallsigns;
*/

params
[
	"_callsigns"
];

private
[
	"_scriptTag"
];

_scriptTag = "SAEF_ASA_fnc_CustomCallsigns";

if ((typeName _callsigns) == "STRING") exitWith
{
	private
	[
		"_callsignArray"
	];

	_callsignArray = [];
	switch (toUpper _callsigns) do
	{
		case "JET" :
		{
			_callsignArray =
			[
				"Anvil",
				"Banshee",
				"Chain",
				"Cobra",
				"Falcon",
				"Hammer",
				"Hawkeye",
				"Jaguar",
				"Jackal",
				"Mudhen",
				"Mustang",
				"Panther",
				"Plasma",
				"Rebel",
				"Satan",
				"Spade",
				"Stalk",
				"Viper",
				"Weasel"
			];
		};

		case "HELO" :
		{
			_callsignArray =
			[
				"Avalanche",
				"Blackjack",
				"Blade",
				"Buzzsaw",
				"Condor",
				"Dragon",
				"Griffon",
				"Gunrunner",
				"Gunfighter",
				"Husky",
				"Indian",
				"Jolly",
				"Mako",
				"Nomad",
				"Outcast",
				"Raven",
				"Ugly",
				"Wildman"
			];
		};

		default 
		{
			[_scriptTag, 2, (format ["Unrecognised Callsign Type: %1", _callsigns])] call RS_fnc_LoggingHelper;
			
			// Ensure something is returned
			_callsignArray = ["Support"];
		};
	};

	// Return the callsigns
	_callsignArray
};

if ((typeName _callsigns) == "ARRAY") exitWith
{
	// Just straight return the given array
	_callsigns
};