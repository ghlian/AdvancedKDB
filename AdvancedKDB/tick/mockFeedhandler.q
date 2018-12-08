// The command for this script is as follows
/q tick/feedhandler.q [host]:port[:usr:pwd] 

// Get the ticker plant ports, defaults are 5010
.u.x: .z.x, count[.z.x]_ enlist ":5010";

// Get the dfxTrade table stored on-disk
dfxTrade: `time`sym xcols get ` sv hsym[`$getenv `TICK_DATASET], `dfxTrade;

// Get the dfxQuote table stored on-disk
dfxQuote: `time`sym xcols get ` sv hsym[`$getenv `TICK_DATASET], `dfxQuote;

// Get the IPC handle for the tickerplant 
/ Put a protection evaluation to open the appropriate handle
`h set @[hopen; `$":", .u.x 0; {0}];

// Define a .u.upd function just in case it needs to call itself if the above handle open fails
.u.upd: {[x;y]};

// Makes the IPC handle call to ticker plant or its ownself 
/ calls the .u.upd function on the tickerplant to publish the Trade/Quotes
/ A protected evaluation is used to ensure that when the ticker goes down, there will no longer be an error message  
.z.ts: {@[h; (`.u.upd; `Trade; flip get each update time: .z.p from dfxTrade[-5?count dfxTrade]); {h:: 0}]; 
	@[h; (`.u.upd; `Quote; flip get each update time: .z.p from dfxQuote[-5?count dfxQuote]); {h:: 0}]};

// Set the timer to 1s, every 1s, it would publish 5 random Trade and Quote rows
system "t 1000"
