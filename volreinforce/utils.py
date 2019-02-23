# -*- coding:utf-8 -*-
# author: zhangyujing@tsinghua
# email: zyj0704033@163.com
import scipy
import numpy


class Normlizer(object):
    def __init__(self, file_path='../test3/PQV.mat', filename='PVQ', eps=0.1):
        super(Normlizer, self).__init__()
        self.PQVdata = scipy.io.loadmat(file_path)[filename]
        self.dmean = np.mean(self.PQVdata)
        self.dstd = np.std(self.PQVdata)
        self.eps = eps

    def meanstdnorm(self, state):
        return (state - self.dmean) / (self.dstd + self.eps)
