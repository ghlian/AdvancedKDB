// This script would load in the existing tickerplant log and filter it to contain ibm.n only
/ To use this script, simply run the following q command
/ system "l ", getenv[`TICK_SCRIPTS], "/Log_Replay_IBM/ibmTPLogFilter.q" 
/ to activate this script

// .u.L would hold the log path
/ Check if it contains anything first, if nothing, exit the script
// If .u.L contains something, we can go ahead and filter the tp_log on ibm.n
/ Functional amend to get the proper filtered tplog tables
/ Return a std-out message to feedback the successful execution of the setting of log message
/ We would need to fix the data if it happens to be in a list format without being a dictionary format
$[not count get .u.L; 
	-1 "WARNING: The tp replay log files have no updates, Nothing to filter on!";
	[
	fdata: {$[98h = type x[2]; x; 99h = type x[2]; @[x; 2; flip]; @[x; 2; :; flip cols[x 1]!x 2]]} each get .u.L;
	h: hopen .[`$string[.u.L], "_ibm.n"; (); :; ()];
	h .[fdata; (::; 2); {[x;y] select from y where sym = x}[`ibm.n]];
	hclose h;
	-1 "MESSAGE: Successfully filter tp replay log files to contain only ibm.n"		
	]];









