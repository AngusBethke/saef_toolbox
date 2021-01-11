## README: The Message Queue

## Primary Function:
To provide the user (in this case a scripter) with a way to manageably execute multiple scripts at the same time without stressing the client, server or headless with too many concurrent requests. This is specifically useful for executing scripts via a trigger or some other uncontrolled system where it is otherwise impossible to avoid processing more than one script at a time. While it is common knowledge that Arma's scripting engine has its own scheduling mechanism, it is very possible for the user to overload it given the frequency with which the engine processes scheduled scripts. It is the intention of this message queue to prevent concurrent processing where possible... though it may not eliminate it completely.

## Usage:
In order to utilise this function set the user must take two steps:
1. A message handler must be initialised with a unique queue name on the specific client you'd like to process the queue for. There is currently no validation around this, so it is up to the implementer to make sure they do not accidentaly create more than one handler with the same queue name, as this could result in "stolen messages" if one queue processes before the other.

As an example, if you would like the Headless client to handle a queue specifically for spawn processing, you could initialise it like this (must be executed from server locality "initServer.sqf" or similar):
```
[["RS_SpawnerQueue"], "RS_MQ_fnc_MessageHandler", "spawn"] spawn RS_fnc_ExecScriptHandler;
```

Similarly, if you would like only the server to handle a queue specifically for objective processing, you could initialise it like this (must be executed from server locality "initServer.sqf" or similar):
```
["RS_ObjectiveQueue"] spawn RS_MQ_fnc_MessageHandler;
```

2. Once the message handler has been initialised, you can then add your messages to the queue and have them be processed. Note: You don't need to initialise the handler first, you can safely add messages to a queue without the handler running, and them simply engage the handler once all your messages are present.

Using our first example from the step above here is a snippet from my Hunter Killer Spawner:
```
_groupCode = 
{
    _x enableFatigue false;
    [_x] execVM "Loadouts\Core.sqf";
};
 
// Hunter Killer Spawns
_parameters =
[
    ["", "HK", "RS_EnemyUnits", "RS_EnemySide", 2, "", 4000, 0, _groupCode, false, "", 1, "<variable_not_found>", {true}, "", "RS_RunHunterKiller"],
    ["", "HK", "RS_EnemyUnits", "RS_EnemySide", 2, "", 4000, 0, _groupCode, false, "", 1, "<variable_not_found>", {true}, "", "RS_RunHunterKiller"],
    ["", "HK", "RS_EnemyUnits", "RS_EnemySide", 2, "", 4000, 0, _groupCode, false, "", 1, "<variable_not_found>", {true}, "", "RS_RunHunterKiller"],
    ["", "HK", "RS_EnemyUnits", "RS_EnemySide", 2, "", 4000, 0, _groupCode, false, "", 1, "<variable_not_found>", {true}, "", "RS_RunHunterKiller"]
];
 
// Spawn the groups
{
    _params = _x;
 
    // Add our spawn script to the spawner queue
    ["RS_SpawnerQueue", _params, "Scripts\Spawners\HandlerMain.sqf"] call RS_MQ_fnc_MessageEnqueue;
} forEach _parameters;
```
As you can see from the code snippet, the script is not executed directly, but rather you call a delegate function to add the message to the queue. You can see that the first parameter of the function is the queue name, the second is the parameter array of your script, and the last parameter is the script you'd like to execute. 

The locality of queue insertion is not important, as they are loaded into variables that are accessed publicly (missionNamespace variables), which means that a client could add messages to these queues with little trouble. That being said, the size of the parameter list may come into play if the message is especially big. With this in mind, I have set up the queue-ing system to self clean messages after they have been executed, so that the missionNamespace variables are not holding onto large amounts of data for too long.

## Final Note
As you can see, the complexity of this system has been greatly reduced from it's last implementation (at least from the user's perspective), hopefully to allow more frequent usage. So far as I can tell, this has bettered the performance impact that spawning AI from multiple sources has on the headless client, which somewhat mitigates the "AI Jitter" that we might see when spawning AI while some are already active. However only time and usage will tell if this has any real benefit outside of this particular function. I do feel that with more time spent on bettering performance in mission crafting, the more likely we are to have a consitently enjoyable (and ultimately less frame-y) experience.
