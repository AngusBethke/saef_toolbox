# SAEF Diagnostics Toolset
Provides some helpful functions that can be used to mission diagnostics

## Functions
### Logging Helper
This function enables logging for many of the saef toolbox toolsets. Note: Each log level includes all the levels below it, eg: 
- log level VERBOSE will only display verbose messages.
- log level ERROR will display verbose and error messages.
- log level WARNING will display verbose, error, and warning messages.
- log level INFO will display verbose, error, warning and info messages.
- log level DEBUG will display verbose, error, warning, info and debug messages.
	
**Log Levels:**
1. DEBUG 		= 4
2. INFO 		= 3
3. WARNING		= 2
4. ERROR		= 1
5. VERBOSE		= 0

#### Usage
```
// Example

[
	"Test Logging"			// The leading tag of the message
	,0				// The level we are logging at
	,"Hello World"			// The message to log
	,true				// (Optional) Do we want to log this on the server as well?
] call RS_fnc_LoggingHelper;
```

### Persistent Performance Check
(This is now started by default)
