// Get the relevant IPC for the tickerplant 
`h set hopen "J"$ getenv `TICKERPLANT_PORT;

// A dummy .u.upd function to call when tickerplant is down
.u.upd: {[x;y]};

// Compared to the r.q upd function, this one is different, since the CEP would need to republish the data
/ We only take the syms that are in the Trade Tables, meaning they have a full set of data to c
upd: {if[not x in `Trade`Quote; :()];
		x insert y; 
		TradeAgg: select tvolume: sum[price*size], maxtpx: max price, mintpx: min price by sym from Trade;
		QuoteAgg: select maxbpx: max bid, minbpx: min ask, baspread: max[bid] - min[ask] by sym from Quote;
		AggTab: `time`sym xcols update time:.z.p from 0!TradeAgg lj QuoteAgg;
		@[h; (`.u.upd; `Aggregation; flip get each AggTab); {h::0}]};

/ end of day: save, clear tables and reapply sym attributes;
.u.end:{t: tables`.;
	@[`.; t; 0#];	
	@[;`sym;`g#] each t;};

/ Similar to those seen for r.q, the cep.q will behave in similar format
/ initialise schemas for Trade, Quote, makes the relevant calculation and republish back to the tickerplant
/ Except that it doesnt have the cd commands etc, since it doesnt run .Q.hdpf
.u.rep:{(set[;].) each x;
	if[null first y;:()];
	-11!y};

/connect to ticker plant for (schema;(logcount;log))
.u.rep . h "(.u.sub[;`] each `Trade`Quote;`.u `i`L)";
