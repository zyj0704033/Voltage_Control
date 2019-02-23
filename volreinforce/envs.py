# -*- coding:utf-8 -*-
# author: zhangyujing@tsinghua
# email: zyj0704033@163.com

import matlab
import matlab.engine
import numpy as np
from multiprocessing import Pool,Pipe,Process
import multiprocessing
import time


class Task:
    EXIT = -2
    RESET = -1
    MAX_STEP = 24480
    EXIT_SEND = [EXIT, 0]
    RESET_SEND = [RESET, 0]

    def __init__(self, name='graduate', envs_num=16, reset_flag = True):
        self.name = name
        self.envs_num = envs_num
        self.start_index = np.arange(envs_num) * 1440
        self.total_step = 0
        self.all_step = 0
        self.reset_flag = reset_flag
        if envs_num > 16:
            print("# WARNING: TOO MUCH ENVS, NOTICE MEMORY!")
        if envs_num > multiprocessing.cpu_count():
            print("# WARNING: MORE ENVS THAN CPU CORES!")
        self.envs_pool = []
        self.pipes = []
        for i in range(envs_num):
            sp, rp = Pipe(True)
            sp2, rp2 = Pipe(True)
            self.pipes.append([sp, rp, sp2, rp2])
            p = Process(target=self.eng_step, args=([rp, sp2], self.start_index[i]))
            self.envs_pool.append(p)
            p.start()


    def step(self, action):
        for i, pipe in enumerate(self.pipes):
            sp, rp, sp2, rp2 = pipe
            sp.send([self.total_step, action[i,:]])
        for pipe in self.pipes:
            sp, rp, sp2, rp2 = pipe
            print(rp2.recv())
        self.total_step += 1
        self.all_step = self.total_step * self.envs_num

    def get_stepnum(self):
        return self.total_step, self.all_step

    def reset(self):
        self.total_step = 0
        self.all_step = 0
        for pipe in self.pipes:
            sp, rp, sp2, rp2 = pipe
            sp.send(self.RESET_SEND)

    def close(self):
        for pipe in self.pipes:
            sp, rp, sp2, rp2 = pipe
            sp.send(self.EXIT_SEND)
        for p in self.envs_pool:
            p.join()

    def eng_step(self, pipe, start_index=1):
        eng = matlab.engine.start_matlab()  #start matlab in python
        print("start matlab in subprocess!")
        eng.addpath("/home/t630/Voltage_Control/test3", nargout=0)  #add voltage control path to the matlab workspace
        eng.start_matpower()  #start up matpower
        eng.load_data(nargout = 0)
        eng.env_init(nargout = 0)
        rp, sp2 = pipe
        while True:
            try:
                step_index, action =  rp.recv()
                if step_index == self.EXIT:
                    break
                if step_index == self.RESET:
                    eng.envreset(nargout = 0)
                step_index = int(step_index)
                step_index += start_index
                step_index = step_index % self.MAX_STEP
                if step_index == start_index and self.reset_flag:
                    eng.envreset(nargout = 0)
                step_index += 1
                eng.workspace['action_flag'] = list(action)
                eng.workspace['i'] = step_index
                eng.action(nargout = 0)
                eng.save_result(nargout = 0)
                message_send = eng.workspace['i']
                sp2.send(message_send)

            except EOFError:
                break

        eng.quit()


if __name__ == '__main__':
    task = Task(envs_num=1)
    start = time.time()
    for i in range(1440):
        task.step(np.random.binomial(1, 0.7, size=(task.envs_num,6)))
    task.close()
    end = time.time()
    print("TOTAL USE TIME %s" %(end-start))
    print("%s STEPS/s" %(24480 / (end-start)))
