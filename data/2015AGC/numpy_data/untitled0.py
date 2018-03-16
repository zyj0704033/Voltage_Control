#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Mar 16 14:04:38 2018

@author: zyj0704033
"""

import numpy as np
import matplotlib.pyplot as plt
a = np.load('4单晶河(一期)风场.npy')
fig = plt.figure()
ax = fig.add_subplot(1,1,1)
ax.plot(range(100),a[1,:100])
xtickslists = [0,25,50,75,100]
ax.set_xticks(xtickslists)
ax.set_xticklabels(a[0,[0,25,50,75,100]],rotation=30)
plt.show()