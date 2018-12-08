def read_csv(csv_file):
    data = []
    with open(csv_file, 'r') as f:

        # create a list of rows in the CSV file
        rows = f.readlines()

        # strip white-space and newlines
        rows = list(map(lambda x:x.strip(), rows))
        
        # remove the header
        rows.pop(0)

        for row in rows:

            # further split each row into columns assuming delimiter is comma 
            row = row.split(',')

            # append to data-frame our new row-object with columns
            data.append(row)

    return data

import os

data = read_csv('/'.join([os.environ.get('TICK_DATASET'), 'Quote.csv']))

# Transpose the list
# Then split them into individual columns
# The time should be updated with newest value so the time and srcTime wouldnt need to be used
timecol,sym,src,bid,ask,bsize,asize,srcTime,cond,layer,expiryTime,msgrcv = list(map(list, zip(*data)))

import datetime
import numpy
import random
import sys
import time

from qpython import qconnection
from qpython.qcollection import qlist
from qpython.qtype import QException, QTIMESTAMP_LIST, QSYMBOL_LIST, QDOUBLE_LIST, QINT_LIST

f = "%Y-%m-%dD%H:%M:%S.%f000" # Get the format of the timestamp column in the excel csv file

# Generate the latest timestamp as we would have done either way in the q feedhandler
qstarttime = numpy.datetime64(datetime.datetime(1970, 1, 1, 0, 0), 'ns') # Q starting date is 1970, so we should reference that as zero

# Parse the timestamp column in the csv
timecol = [numpy.timedelta64(numpy.datetime64(datetime.datetime.strptime(x,f)) - qstarttime, 'ns') for x in timecol]
srcTime = [numpy.timedelta64(numpy.datetime64(datetime.datetime.strptime(x,f)) - qstarttime, 'ns') for x in srcTime]
expiryTime = [numpy.timedelta64(numpy.datetime64(datetime.datetime.strptime(x,f)) - qstarttime, 'ns') for x in expiryTime]
msgrcv = [numpy.timedelta64(numpy.datetime64(datetime.datetime.strptime(x,f)) - qstarttime, 'ns') for x in msgrcv]


data = [qlist(timecol, qtype=QTIMESTAMP_LIST), 
        qlist(sym, qtype=QSYMBOL_LIST), 
        qlist(src, qtype=QSYMBOL_LIST), 
        qlist(bid, qtype=QDOUBLE_LIST), 
        qlist(ask, qtype=QDOUBLE_LIST), 
        qlist(bsize, qtype=QINT_LIST), 
        qlist(asize, qtype=QINT_LIST), 
        qlist(srcTime, qtype=QTIMESTAMP_LIST), 
        qlist(cond, qtype=QSYMBOL_LIST), 
        qlist(layer, qtype=QSYMBOL_LIST),
        qlist(expiryTime, qtype=QTIMESTAMP_LIST),
        qlist(msgrcv, qtype=QTIMESTAMP_LIST)]

# create connection object
q = qconnection.QConnection(host='localhost', port=5010)

# initialize connection
q.open()

print('IPC version: %s. Is connected: %s' % (q.protocol_version, q.is_connected()))

# simple query execution via: QConnection.sync
q.sync('.u.upd', numpy.string_('Quote'), data)

print('Published to q tickerplant successfully')

# close connection
q.close()

