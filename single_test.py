#!/usr/bin/python
# zsim stats README
# Author: Daniel Sanchez <sanchezd@stanford.edu>
# Date: May 3 2011
#
# Stats are now saved in HDF5, and you should never need to write a stats
# parser. This README explains how to access them in python using h5py. It
# doubles as a python script, so you can just execute it with "python
# README.stats" and see how everything works (after you have generated a stats
# file).
#

import h5py # presents HDF5 files as numpy arrays
import numpy as np

filename = [
'bzip2',
'gcc',
'mcf',
'hmmer',
'sjeng',
'libquantum',
'xalan',
'milc',
'cactusADM',
'leslie3d',
'namd',
'soplex',
'calculix',
'lbm'
]

folder = ['SRRIP','LRU','LFU']

for names in folder:
    title = names + "= [ "
    print title
    for item in filename:
        
        filepath = names+'/'+item + '/zsim-ev.h5'
        f = h5py.File(filepath, 'r')
        # Get the single dataset in the file
        dset = f["stats"]["root"]
        mGETS = dset[-1]['l3']['mGETS']
        mGETXIM = dset[-1]['l3']['mGETXIM']
        mGETXSM = dset[-1]['l3']['mGETXSM']
        totle_miss = mGETS+mGETXIM+mGETXSM
        instrs = dset[-1]['westmere']['instrs']
        cycles = float(dset[-1]['westmere']['cycles']+dset[-1]['westmere']['cCycles'])
        mis_kilo= float(totle_miss) / float(instrs) * 1000
        result1 = str(mis_kilo) + ','
        result2 = str(cycles)+','
        print result2
    print "];"






#        result2 = "time: "+ str(cycles);


# OK, now go bananas!

