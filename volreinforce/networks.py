# -*- coding:utf-8 -*-
# author: zhangyujing@tsinghua
# email: zyj0704033@163.com

import torch.nn as nn

class ConvBody(nn.Module):
    def __init__(self):
        super(ConvBody, self).__init__()
        self.conv1 = nn.Conv2d(1,16,kernel_size=(2,9),padding=(1,4))
        self.bn1 = nn.BatchNorm2d(16)
        self.conv2 = nn.Conv2d(16,32,(2,7),padding=(0,3))
        self.bn2 = nn.BatchNorm2d(32)
        self.conv3 = nn.Conv2d(32,32,(2,7),padding=(0,3))
        self.bn3 = nn.BatchNorm2d(32)
        self.fc = nn.Linear(1024, 200)
        self.relu = nn.ReLU()

    def forward(self, x):
        y = self.bn1(self.conv1(x))
        y = self.relu(y)
        y = self.bn2(self.conv2(y))
        y = self.relu(y)
        y = self.bn3(self.conv3(y))
        y = self.relu(y)
        y = y.view(-1, 1024)
        y = self.fc(y)
        y = self.relu(y)
        return y



class ActorCriticNet(nn.Module):
    def __init__(self):
        super(ActorCriticNet, self).__init__()
        self.ConvBody = ConvBody()
        self.actornet = nn.Linear(200, 3)
        self.valuenet = nn.Linear(200, 1)
        self.sigmoid = nn.Sigmoid()

    def forward(self, x, action=None):
        y = self.ConvBody(x)
        a = self.sigmoid(self.actornet(y))
        v = self.valuenet(y)
        action_dist = torch.distributions.bernoulli.Bernoulli(probs=a)
        if action is None:
            action = action_dist.sample()
        log_prob = torch.sum(action_dist.log_prob(action), 1)
        entropy = torch.sum(action_dist.entropy(), 1)

        return {
            'action': action,
            'log_prob': log_prob,
            'entropy': entropy,
            'value': v
        }
