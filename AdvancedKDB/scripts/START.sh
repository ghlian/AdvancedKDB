#!/usr/bin/bash

# Get environmental config variables temporarily
source ./env_config.sh

echo "Start Tickerplant (y/n)?"
read tickproc
echo ""

if [ "$tickproc" = "y" ]; then
    nohup ${Q_DIR} ${TICK_PROCESSES}/tick.q > ${TICK_LOG}/tick.log 2>&1 &
fi

echo "Start Trade/Quote RDB (y/n)?"
read tqRDBproc
echo ""

if [ "$tqRDBproc" = "y" ]; then
    nohup ${Q_DIR} ${TICK_PROCESSES}/rdbTradeQuote.q > ${TICK_LOG}/tqRDB.log 2>&1 &
    echo "Open HTML file for Trade Table queries for Trade/Quote RDB <select y if have chromium-browser> (y/n)?"
    read tqWebHTML
    echo ""
    if [ "$tqWebHTML" = "y" ]; then
        chromium-browser ${TICK_WEBSOCKET}/SimpleDemo.html
        echo ""
    fi
fi

echo "Start Aggregation RDB (y/n)?"
read aggRDBproc
echo ""

if [ "$aggRDBproc" = "y" ]; then
    nohup ${Q_DIR} ${TICK_PROCESSES}/rdbAggregation.q > ${TICK_LOG}/aggRDB.log 2>&1 &
fi

echo "Start CEP (y/n)?"
read CEPproc
echo ""

if [ "$CEPproc" = "y" ]; then
    nohup ${Q_DIR} ${TICK_PROCESSES}/CEP.q > ${TICK_LOG}/cep.log 2>&1 &
fi

echo "Start Mock Feedhandler (y/n)?"
read feedhandlerproc
echo ""

if [ "$feedhandlerproc" = "y" ]; then
    nohup ${Q_DIR} ${TICK_PROCESSES}/mockFeedhandler.q > ${TICK_LOG}/feedhandler.log 2>&1 &
fi

