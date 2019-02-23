# -*- coding:utf-8 -*-
# author: zhangyujing@tsinghua
# email: zyj0704033@163.com

import torch
import numpy as np
from networks import *
from envs import *
from reply import Storage
from utils import Normlizer

class A2CAgent(object):
    """docstring for A2CAgent."""
    def __init__(self):
        super(A2CAgent, self).__init__()
        self.network = ActorCriticNet()
        self.env = Task()
        self.optimizer = torch.optim.RMSprop(self.network.parameters(), lr=1e-4, alpha=0.99, eps=1e-5)
        self.total_step = 0
        self.rollout = 30
        self.states = Task()
        self.state_norm = Normlizer()

    def step(self):
        storage = Storage(self.rollout)
        state = self.states
        for _ in range(self.rollout):
            prediction = self.network(self.state_norm.meanstdnorm(state))
            next_states,


    def pretrain(self):
        pass

    def eval(self):
        pass
