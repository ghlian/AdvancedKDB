/q tick/r.q [host]:port[:usr:pwd] [host]:port[:usr:pwd]
/2008.09.09 .k ->.q

if[not "w"=first string .z.o;system "sleep 1"];

upd:{if[x in `Aggregation; x insert y]};

// Start a port so one can connect to the process to check any info
@[system; "p ", getenv `RDB_AGG_PORT; {-1 "Error starting up the port"}];

/ end of day: save, clear, hdb reload
/ remove all tables that does not have grouped attribute applied to the sym columns
/ The tables attributes would be cleared on .Q.hdpf, therefore we would need to reapply the sym attribute  
.u.end:{t: tables`.;
	t@:where `g=attr each t@\:`sym;
	.Q.hdpf[`$":", getenv `HDB_PORT;`:.;x;`sym];
	@[;`sym;`g#] each t;};

.u.rep:{set[;] . x;
		if[null first y;:()];
		-11!y;
		system "cd ", getenv `TICK_HDB};

// Connect to tickerplant port
tPort: hopen "J"$ getenv `TICKERPLANT_PORT;

/ connect to ticker plant for (schema;(logcount;log))
.u.rep . tPort "(.u.sub[`Aggregation;`];`.u `i`L)";
