/q tick/r.q [host]:port[:usr:pwd] [host]:port[:usr:pwd] [port]
/2008.09.09 .k ->.q

if[not "w"=first string .z.o;system "sleep 1"];

upd:{if[x in `Trade`Quote; x insert y]};

// Initiate the RDB with a specific port number for the web-socket connection to run query on the Trade Tables
/ This is designated to be port 5014, which can be changed here
@[system; "p ", getenv `RDB_WEBSOCKET_PORT; {-1 "Error starting up the port"}];

/ Specify the .z.ws function in order to allow one to query the Trade Table from the HTML demo
.z.ws: {neg[.z.w] .Q.s @[value;x;{`$ "'",x}]};

.u.end:{t: tables`.;
	t@:where `g=attr each t@\:`sym;
	.Q.hdpf[`$":", getenv `HDB_PORT;`:.;x;`sym];
	@[;`sym;`g#] each t;};

.u.rep:{(set[;].) each x;
		if[null first y;:()];
		-11!y;
		system "cd ", getenv `TICK_HDB};

// Connect to tickerplant port
tPort: hopen "J"$ getenv `TICKERPLANT_PORT;

/ connect to ticker plant for (schema;(logcount;log))
.u.rep . tPort "(.u.sub[;`] each `Trade`Quote;`.u `i`L)";
