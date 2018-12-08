// Get the schema file
system "l ", getenv[`TICK_PROCESSES], "/", getenv `TICKERPLANT_SCHEMA;

// Set the port of tickerplant
system "p ", getenv `TICKERPLANT_PORT;

// Get the u,q functions defined 
system "l ", getenv[`TICK_PROCESSES], "/u.q";

// Load the logging.q functions 
system "l ", getenv[`TICK_SCRIPTS], "/logging.q";

\c 200 200

// Enter into .u namespace
\d .u

// For the tick replay log
ld:{if[not type key L:: `$string[L], string x; .[L;();:;()]]; 
	i::j:: -11!(-2;L); 
	if[0 <= type i; -2 string[L]," is a corrupt log. Truncate to length ", string[last i], " and restart"; exit 1];
	hopen L};

// This is called in the tick initialisation function to open the handle to the replay log
/ A timer variable .u.timer is initialised for the eventual logging of subscription details
tick:{init[];
	if[not min (`time`sym ~ 2# key flip value @) each t; '`timesym];
	@[; `sym; `g#] each t;
	d:: .z.D;
	timer:: 0f;
	L:: .Q.dd[hsym `$ getenv `TICK_LOG; `tp_replaylog_]; l:: ld d};

// The end of day function to "crossover" the replay log
endofday:{end d; d+:1; if[l; hclose l; l:: 0(`.u.ld; d)]};
ts:{if[d < x; if[d < x - 1; system "t 0"; '"more than one day?"]; endofday[]]};

// Set .z.ts crontab timer to run every sec, unless otherwise specified
if[not system "t"; system "t 1000"];

// Set the crontab timer to check for the next day process
/ Also it would be used to log out the message details
.z.ts: {timer+:system["t"]%1000; 
		if[timer >= 60; timer:: timer mod 60; .log.out[.z.h; string[i], " Message(s) Processed."; w]]; 
		ts .z.D};

// Assume that non-batching mode is always used, that tickerplant will publish to its sub ticker plant
/ This is the .u.upd function called by the publishing mechanism 
upd: {[t;x] ts "d"$ a:.z.P;
	if[not -12 = type first first x; x: $[0 > type first x; a, x; enlist[count[first x] # a],x]];
	f: key flip value t;
	pub[t; $[0 > type first x; enlist f!x; flip f!x]];
	if[l; l enlist (`upd; t; x); i+:1];
	};

\d .

// Start the tickerplant process
.u.tick[];

