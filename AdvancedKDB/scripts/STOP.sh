#!/usr/bin/bash

echo ""

tickProc=$(ps -ef | grep -v "grep" | grep -v "grep" | grep tick.q | wc -l)

if [ "$tickProc" = "1" ]; then
    echo "TICKERPLANT IS RUNNING. DO YOU WANT TO STOP IT (y/n)?"
    read tickStop
    if [ "$tickStop" = "y" ]; then
        ps aux | grep tick.q | grep -v grep | awk '{print $2}' | xargs -i kill -9 {}
        echo "TICKERPLANT IS STOPPED"
    fi
fi
echo ""

rdbAggProc=$(ps -ef | grep -v "grep" | grep -v "grep" | grep rdbAggregation.q | wc -l)

if [ "$rdbAggProc" = "1" ]; then
    echo "AGGREGATION RDB IS RUNNING. DO YOU WANT TO STOP IT (y/n)?"
    read rdbAggStop
    if [ "$rdbAggStop" = "y" ]; then
        ps aux | grep rdbAggregation.q | grep -v grep | awk '{print $2}' | xargs -i kill -9 {}
        echo "AGGREGATION RDB IS STOPPED"
    fi
fi
echo ""


rdbTQProc=$(ps -ef | grep -v "grep" | grep -v "grep" | grep rdbTradeQuote.q | wc -l)

if [ "$rdbTQProc" = "1" ]; then
    echo "TRADE/QUOTE RDB IS RUNNING. DO YOU WANT TO STOP IT (y/n)?"
    read rdbTQStop
    if [ "$rdbTQStop" = "y" ]; then
        ps aux | grep rdbTradeQuote.q | grep -v grep | awk '{print $2}' | xargs -i kill -9 {}
        echo "TRADE/QUOTE RDB IS STOPPED"
    fi

fi
echo ""

cepProc=$(ps -ef | grep -v "grep" | grep -v "grep" | grep CEP.q | wc -l)

if [ "$cepProc" = "1" ]; then
    echo "CEP IS RUNNING. DO YOU WANT TO STOP IT (y/n)?"
    read cepStop
    if [ "$cepStop" = "y" ]; then
        ps aux | grep CEP.q | grep -v grep | awk '{print $2}' | xargs -i kill -9 {}
        echo "CEP RDB IS STOPPED"
    fi    
fi
echo ""

fhProc=$(ps -ef | grep -v "grep" | grep -v "grep" | grep mockFeedhandler.q | wc -l)

if [ "$fhProc" = "1" ]; then
    echo "MOCK FEEDHANDLER IS RUNNING. DO YOU WANT TO STOP IT (y/n)?"
    read fhStop
    if [ "$fhStop" = "y" ]; then
        ps aux | grep mockFeedhandler.q | grep -v grep | awk '{print $2}' | xargs -i kill -9 {}
        echo "MOCK FEEDHANDLER RDB IS STOPPED"
    fi    
fi
echo ""
