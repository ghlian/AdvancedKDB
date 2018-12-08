First, run the following commands to pick up the necessary environmental variables necessary for the subsequent scripts

1) source env_config_Partitioned_HDB.sh


2) Then run the following q scripts to replay the sample tp_trades.log provided:

q scripts/saveToHDB.q


3) The script would automatically replay the sample tp_trades.log and set the various changes made to trade tables down onto the QHDB, 
compressing all columns except for sym and time

4) This would be similar to the EOD process observed for the EODs of the partitioned HDBs
