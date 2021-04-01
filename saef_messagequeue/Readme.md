## The Message Queue

## Primary Function:
To provide the user (in this case a scripter) with a way to manageably execute multiple scripts at the same time without stressing the client, server or headless with too many concurrent requests. This is specifically useful for executing scripts via a trigger or some other uncontrolled system where it is otherwise impossible to avoid processing more than one script at a time. While it is common knowledge that Arma's scripting engine has its own scheduling mechanism, it is very possible for the user to overload it given the frequency with which the engine processes scheduled scripts. It is the intention of this message queue to prevent concurrent processing where possible... though it may not eliminate it completely.

## Usage:
In order to utilise this function set the user must take two steps:
1. A message handler must be created, and there is now a function provided for doing so:
```
[
    "RS_ObjectiveQueue",    // Unique Queue Name
    ,"HC1"                  // (Optional) Target to run the queue on
    ,true                   // (Optional) Whether or not to fallback to the server if target is not found
] call RS_MQ_fnc_CreateQueue;
```

It is now also possible to create a distributed queue that automatically farms out processing to the headless clients, by default it evaluates the AI count on each headless client and utilises that as it's mechanism for distribution, but it can be customised to use a different set of functions for rebalancing. If you leave the setup as default, make sure that the first parameter of your message is the AI count that you would like to spawn (as this is what will be used for the rebalance). **Note:** A distributed queue must be created from the server.
```
[
    "RS_SpawnerQueue",      // Unique Queue Name
    ,"ALL_HEADLESS"         // This is the target you need to specifiy for distributed queue creation
    ,false                  // (Optional) This parameter is ignored by the distributed queue creation (but must still be supplied if you use the below parameter, can be false or true)
    ,[                      // (Optional) This is array of functions for rebalancing
        "SAEF_AS_fnc_EvaluationParameter",      // Function that should return an index (number) to the position of the unit count in your array (receives params ["_function"], which is the string name of the function that will be executed by the handler)
        "SAEF_AS_fnc_EvaluateAiCount",          // Function that evaluates the condition on each headless client (receives params ["_target"], which is the string name of the target that we will attempt to execute the message on), this should return an integer used for balancing
        "SAEF_AS_fnc_UpdateAiCount"             // Function that updates the condition while the message is being executed so that no duplication takes place (receives params ["_target", "_updateCount"], which is the string name of the target and the count reference by the index determined above)
    ]
] call RS_MQ_fnc_CreateQueue;
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

As you can see from the code snippet, the script is not executed directly, but rather you call a delegate function to add the message to the queue: 
```
["RS_SpawnerQueue", _params, "Scripts\Spawners\HandlerMain.sqf"] call RS_MQ_fnc_MessageEnqueue;
```
You can see that the first parameter of the function is the queue name, the second is the parameter array of your script, and the last parameter is the script you'd like to execute. 

The locality of queue insertion is not important, as they are loaded into variables that are accessed publicly (missionNamespace variables), which means that a client could add messages to these queues with little trouble. That being said, the size of the parameter list may come into play if the message is especially big. With this in mind, I have set up the queue-ing system to self clean messages after they have been executed, so that the missionNamespace variables are not holding onto large amounts of data for too long.

## Final Note
As you can see, the complexity of this system has been greatly reduced from it's last implementation (at least from the user's perspective), hopefully to allow more frequent usage. So far as I can tell, this has bettered the performance impact that spawning AI from multiple sources has on the headless client, which somewhat mitigates the "AI Jitter" that we might see when spawning AI while some are already active. However only time and usage will tell if this has any real benefit outside of this particular function. I do feel that with more time spent on bettering performance in mission crafting, the more likely we are to have a consitently enjoyable (and ultimately less frame-y) experience.
