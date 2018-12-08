For this ticker-plant to work, one would need to configure the following
1) Ensure qpython library is installed for the pyfeedhandler to work
2) Configure the env_config.sh in the scripts directory with the respective directories etc
3) In the same env_config.sh, one can configure the ports of the various process instances

For the remaining of the Advanced KDB questions
1) Question 2 can be found in the Question2_Answers directory
2) For the EOD process, a sample QHDB as well as a q-script necessary to replay the tplog and save down to the HDB (with compressed columns except for sym and time) are found in Question1_EOD_Process directory
3) Question 1, for the 10th sub-question, answers can be found in the word document located under Question1_10_Answers directory

For the HTML5 query interface to work,
1) One would need to install chromium-browser library in order to start it from the START.sh script
2) Alternatively, one can run the START.sh script to ensure the Trade/Quote RDB is started up
3) Based off the port specified in the env_config.sh file under RDB_WEBSOCKET_PORT, the SimpleDemo.html would need to be adjusted to connect to that same port
4) From the SimpleDemo.html, one would be able to directly enter the q query in the input box to elicit the desired results from the Trade Table or otherwise, a place-holder is provided to show how a query by symbol input can be typed to elicit the desired results

For the reading of csvs and publishing to ticker-plant:
1) cd into the scripts directory and run the CSV_PUBLISH.sh script in order to select the various language to publish to TickerPlant, i.e. C or Python or Q

