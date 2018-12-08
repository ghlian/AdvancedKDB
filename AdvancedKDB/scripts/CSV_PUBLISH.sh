#!/usr/bin/bash

# Get environmental config variables temporarily
source ./env_config.sh

echo "Read in Quote csv with C script to publish to tickerplant (y/n)?"
read CAPI
echo ""

if [ "$CAPI" = "y" ]; then
    echo "Compiling C code..."
    gcc -DKXVER=3 -o ${TICK_SCRIPTS}/C_csv/main ${TICK_SCRIPTS}/C_csv/main.c ${TICK_SCRIPTS}/C_csv/c.o -lpthread
    echo "Compiling completed..."

    echo "Running C code to read csv and publish to tickerplant..."
    ${TICK_SCRIPTS}/C_csv/main
    echo "Reading csv and publishing to tickerplant complete..."
    echo ""
fi

echo "Read in Quote csv with Python script to publish to tickerplant (y/n)?"
read PyAPI
echo ""

if [ "$PyAPI" = "y" ]; then
    echo "Running Python code to read csv and publish to tickerplant..."
    python ${TICK_SCRIPTS}/Python_csv/pyFeedhandler.py 
    echo "Reading csv and publishing to tickerplant complete..."
    echo ""
fi

echo "Read in Quote csv with Q script to publish to tickerplant (y/n)?"
read QAPI
echo ""

if [ "$QAPI" = "y" ]; then
    echo "Running Q Script to read csv and publish to tickerplant..."
    ~/q/l64/q ${TICK_SCRIPTS}/Q_csv/qFeedhandler.q 
    echo "Reading csv and publishing to tickerplant complete..."
    echo ""
fi