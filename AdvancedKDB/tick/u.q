/2008.09.09 .k -> .q
/2006.05.08 add

\d .u
init:{w::t!(count t::tables`.)#()}

/ Each of the .u.w dictionary contains the table names as the dictionary keys, in it, it would be an enlisted list (x;y),
/ where x refers to the ipc handle, while y refers to the sym subscribed to
del:{w[x]_:w[x;;0]?y};

.z.pc:{del[;x]each t};

sel:{$[`~y; x; select from x where sym in y]}

/ sel[x] w 1 would filter the data based on the specified sym 
pub:{[t;x] {[t;x;w] if[count x: sel[x] w 1; (neg first w) (`upd;t;x)]}[t;x]each w t}

add:{$[count[w x] > i: w[x;;0]?.z.w; .[`.u.w; (x;i;1); union; y]; w[x],: enlist(.z.w;y)];(x;$[99=type v:value x;sel[v]y;0#v])}

sub:{if[x~`; :sub[;y] each t]; if[not x in t;'x]; del[x] .z.w; add[x;y]}

end:{(neg union/[w[;;0]]) @\: (`.u.end;x)}
