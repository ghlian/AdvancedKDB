/ Read the csv file into the q table
Quote: ("PSSFFIIPSSPP"; enlist csv) 0: .Q.dd[hsym `$getenv `TICK_DATASET; `Quote.csv];

/ Open the port to the q kdb+ tickerplant
/ Default to itself, if the port isnt available for connection
h: @[hopen; "J"$ getenv `TICKERPLANT_PORT; {0}];

/ Publish to the tickerplant with protected evaluation
@[h; (`.u.upd; `Quote; flip get each Quote); {x}];



