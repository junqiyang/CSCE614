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
'blackscholes_8c_simlarge',
'bodytrack_8c_simlarge',
'canneal_8c_simlarge',
'dedup_8c_simlarge',
'freqmine_8c_simlarge',
'fluidanimate_8c_simlarge',
'streamcluster_8c_simlarge',
'swaptions_8c_simlarge',
'x264_8c_simlarge'
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
        mGETS = np.sum(dset[-1]['l3']['mGETS'])
        mGETXIM = np.sum(dset[-1]['l3']['mGETXIM'])
        mGETXSM = np.sum(dset[-1]['l3']['mGETXSM'])
        totle_miss = mGETS+mGETXIM+mGETXSM
        instrs = np.sum(dset[-1]['westmere']['instrs'])
        
        max_cycle = np.amax(dset[-1]['westmere']['cycles']+dset[-1]['westmere']['cCycles'])
        mis_kilo= float(totle_miss) / float(instrs) * 1000
        result1 = str(mis_kilo) + ','
        result2 = str(max_cycle) + ','
        print result2
    print "];"


# OK, now go bananas!

