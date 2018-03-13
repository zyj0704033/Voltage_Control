clear
run('startup_matpower.m')
P_bt1=xlsread('26batou',2,'G119500:G120939');
P_cf1=xlsread('27changfeng',2,'E74180:E75619');
P_tsh1=xlsread('28taoshanhu',2,'E119210:E120649');
P_dr1=xlsread('48derun',2,'E12596:E14035');
P_sy1=xlsread('49shanyuan',2,'E91476:E92915');
disp('load finish')