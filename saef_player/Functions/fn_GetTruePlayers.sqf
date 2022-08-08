/**
	@namespace RS_PLYR
	@class PlayerFunctions
	@method RS_PLYR_fnc_GetTruePlayers
	@file fn_GetTruePlayers.sqf
	@summary Returns an array of "true" players

	@todo Params not listed but are required?

	@param ?bool _includeDead
	@param ?bool _includeUnconcious

	@return array _players Returns closest player position within given radius

	@usage ```[] call RS_PLYR_fnc_GetTruePlayers;```

**/

/*
	fn_GetTruePlayers.sqf

	Description: 
		Returns an array of "true" players

	How to Call: 
		[] call RS_PLYR_fnc_GetTruePlayers;
*/

params
[
	["_includeDead", false],
	["_includeUnconcious", false]
];

private
[
	"_params",
	"_players",
	"_truePlayers",
	"_validationCode"
];

_params = _this;
_players = (allPlayers - (entities "HeadlessClient_F"));
_truePlayers = [];

_validationCode = {
	params
	[
		"_unit",
		["_includeDead", false],
		["_includeUnconcious", false]
	];

	private
	[
		"_success"
	];

	_success = true;

	if (!_includeDead) then
	{
		if (!(alive _unit)) then
		{
			_success = false;
		};
	};

	if (!_includeUnconcious) then
	{
		if (_unit getVariable ["ACE_isUnconscious", false]) then
		{
			_success = false;
		};
	};

	// Return Success
	_success
};

{
	if (!((typeOf _x) == "VirtualSpectator_F")) then
	{
		private
		[
			"_tParams"
		];

		_tParams = [_x] + _params;

		// If unit passes validation, return them
		if (_tParams call _validationCode) then
		{
			_truePlayers pushBack _x;
		};
	};
} forEach _players;

// Return the array of true players
_truePlayers