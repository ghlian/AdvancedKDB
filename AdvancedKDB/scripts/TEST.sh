#!/usr/bin/bash

echo ""

tickProc=$(ps -ef | grep -v "grep" | grep -v "grep" | grep tick.q | wc -l)

if [ "$tickProc" = "1" ]; then
    echo "TICKERPLANT IS RUNNING"
fi

rdbAggProc=$(ps -ef | grep -v "grep" | grep -v "grep" | grep rdbAggregation.q | wc -l)

if [ "$rdbAggProc" = "1" ]; then
    echo "AGGREGATION RDB IS RUNNING"
fi

rdbTQProc=$(ps -ef | grep -v "grep" | grep -v "grep" | grep rdbTradeQuote.q | wc -l)

if [ "$rdbTQProc" = "1" ]; then
    echo "TRADE/QUOTE RDB IS RUNNING"
fi

cepProc=$(ps -ef | grep -v "grep" | grep -v "grep" | grep CEP.q | wc -l)

if [ "$cepProc" = "1" ]; then
    echo "CEP IS RUNNING"
fi

fhProc=$(ps -ef | grep -v "grep" | grep -v "grep" | grep mockFeedhandler.q | wc -l)

if [ "$fhProc" = "1" ]; then
    echo "MOCK FEEDHANDLER IS RUNNING"
fi

echo ""