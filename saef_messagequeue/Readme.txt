/*
	fn_Readme.sqf
	Description: Adds readme info to player journal on how to implement this function set
	Author: Angus Bethke a.k.a. Rabid Squirrel
*/

/*
	What is this for?
	
	Well... that's a great question. I should lead with: "It is very situational": Sometimes, specifically in a multiplayer environment, you may need to execute functions/code in a certain order, or perhaps combat a problem of execution timing. This can all prove to be quite difficult when it comes to multiple players with a variety of connection speeds and the server itself.
	
	Now, the above is quite technical, so let's provide an example:
	About two years ago I put together this Awesome (if I do say so myself) function set called "Invasion", the purpose of this function set was to create an airborne invasion for WW2 missions using the C-47 planes and their useful functions from the IFA3 mod. I slaved over it, nearly 24 hours of work, and I had done it, this function moves all players into a plane or set of planes, moves them to the DZ and then deposits them neatly into the AO with cool extras, like... moving to the door, red/green light.

	This all worked perfectly in Singleplayer, and even fine in testing with 2 or 3 players in MP. So... where did the problem arise. Well... when we loaded the server with more players, suddenly everything started to come apart at the seams. Some players weren't moved to the right plane, some players weren't moved to a plane at all. It was a huge mess. Which is frustrating.
	
	
	What does it do then?

	Essentially, it provides a solution the problem above, and could also allow for a variety of different uses, depending on your needs. The basic concept, is that it is a message queue system. Now if you're not a developer, and the above is making no sense... I'll try break it down as best I can.
	
	The straight through is that:
	1. You register a message to the queue (so that the handler knows to process it)
	2. You setup the message on the server and the players (and link them if necessary)
	3. You trigger the message processing event
	
	Register Message Type > Create Message > Trigger Message Processing
	
	
	What is a message?
	
	In the above process it is a code block, that can take certain parameters (defined in the fn_Init.sqf). You can use those parameters for a couple useful purposes, but primarily, it provides an ordered list of players for message execution, so you have full control of what messages are executed for the player and when they are executed.
	
	An important note: At present, due to the message being a code block, it is recommend that you keep the code block relatively short and quick to execute. If you need to, call a seperate script or function from within the code block to save on message size :)
	
	How do I setup a message?
	
	For the Server:
	// First you need to register the message
	[
		"RSMQ_BoardHelo1", 		// The message name, this message must be as unique as you can make it (this can be re-used later in the mission if it has already been used)
		"ADD"					// Whether to add or remove (RMV) the message
	] call RS_MQ_fnc_ListenerEdit;
	
	// Then, you need to create the actual message
	_params = [helo_1];
	
	_codeBlock = 
	{
		params (missionNamespace getVariable "RS_MessageHandler_MessageParams");
		_helo = _params select 0;
		
		{
			_player = _x select 0;
			_order = _x select 1;
			
			[[_helo, _order], "Scripts\Player\MoveInCargo.sqf"] remoteExec ["execVM", _player, false];
		} forEach _messageOrder;
	};
	missionNamespace setVariable ["RSMQ_BoardHelo1", [_codeBlock, _params, "SERVER"], true];
	
	// Peek inside "Scripts\Player\MoveInCargo.sqf";
	_helo = _this select 0;
	_order = _this select 1;
	
	player assignAsCargoIndex [_helo, _order];
	player moveInCargo _helo;
	
	
	For the Player:
	
	// You need to link the message - note the 4th parameter, this specifies whether or not to link to the server message, and this is REQUIRED for all player messages
	player setVariable ["RSMQ_BoardHelo1", [{}, [], "SERVER", true], true];
	
	
	Finally, to trigger the message:
	missionNamespace setVariable ["RS_MessageHandler_Execute", true, true];
	
	
	Why would I ever need this?
	
	I imagine right now, you've read all of this, and you're scratching your head, wondering why I went to all this trouble for a simple script to board players into a Helicopter... and you'd be right, there are a million easier ways to accomplish the above. However, I used the simplest of examples above for demonstration purposes. 
	
	So I'll list some examples of other uses for this:
	1. Say you need to execute a mission event on the player, such as perhaps triggering a multiplayer cutscene, you can wire up the messages ahead of time for the player, then hook it up to the server and fire it on everyone on the server without needing to faff about with anything other than a few variables.
	2. Perhaps you wanted to set up a full missions worth of counter attacks, intel, objectives - the works. You could build a message chain that builds new messages when firing the current message, and essentially just flip the switch each time a new objective needs to be started.
	
	I'm sure there are many other uses for the message queue, and I really hope you end up using it, providing feedback... and well, that it makes your life easier.
	
	Cheers,
	Angus.
	
*/

/*
	END
*/