// Load the schema for the trades table
system "l ", getenv[`PARTITIONED_HDB_SCHEMA], "/trade.q";

// Define the upd function necessary to replay the tp_trades.log into the trades table
upd: {[tab;data] tab upsert data};

// Replay the sample tplog provided, which would update the trades table
-11! hsym `$ getenv[`PARTITIONED_HDB_LOG], "/tp_trades.log";

// Get the QHDB directory as a variable in string format
QHDBDIR: getenv `PARTITIONED_HDB_HDBDIR; 

// The following command is to obtain the column names that would be compressed, i.e. except for sym and time
colsCompressed: (), cols[trade] except `sym`time;

// This is to create the dictionary to specify the columns to be compressed and the type of compression
compressSpecs: colsCompressed!((17;2;6);(17;2;6));

// This is to set the replayed data onto disk 
(hsym `$ QHDBDIR, "/", string[.z.d], "/trade/"; compressSpecs) set .Q.en[hsym `$ QHDBDIR] trade;

// Pass to stdout that the script have been completed
-1 "QHDB has been successfully set from tplog replay";

