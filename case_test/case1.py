#-*-conding:utf8-*-
from matlab import engine
import os
eng = engine.start_matlab()
eng.startup_matpower(nargout=0)
eng.loaddata(nargout=0)
eng.case1(nargout=0)
os.system("pause")