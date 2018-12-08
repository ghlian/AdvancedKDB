// Creating the .log.out function for stdout
.log.out: {[uname;message;details] -1 " " sv ("####"; raze string uname; "####"; message; "####"; .Q.s1 details);};

// Creating the .log.err function for stderr
.log.err: {[uname;message;details] -2 " " sv ("####"; raze string uname; "####"; message; "####"; .Q.s1 details);};

// To use the .log.out function to log to stdout when ports are opened
.z.po: {.log.out[.z.h; "Port Opened: ", string .z.w; .Q.w[]]};

// To use the .log.out function to log to stdout when ports are closed
.z.pc: {.log.out[.z.h; "Port Closed: ", string .z.w; .Q.w[]]};

