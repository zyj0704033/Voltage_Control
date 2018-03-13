clear
%% 数据获取
% %%负荷数据
% load1 = xlsread('发电负荷统计情况',1,'B2:B97')/1000;
% for i=1:96
%     load2(i) = load1(i)+3*(1+0.05*rand(1,1));
%     load3(i) = load1(i)-4*(1+0.05*rand(1,1));
%     load4(i) = load1(i)+5*(1+0.05*rand(1,1));
% end
% plot(1:96,load1);
% hold on;
% plot(1:96,load2);
% hold on;
% plot(1:96,load3);
% hold on;
% plot(1:96,load4);
% pause;
%%风场有功数据
%坝头风场
P_bt1=xlsread('26坝头风场',2,'G119500:G120939');
%长风风场
P_cf1=xlsread('27长风风场',2,'E74180:E75619');
%桃山湖风场
P_tsh1=xlsread('28桃山湖风场',2,'E119210:E120649');
%德润风场
P_dr1=xlsread('48德润风场',2,'E12596:E14035');
%杉源风场
P_sy1=xlsread('49杉源风场',2,'E91476:E92915');
%15分钟一个点
for i=1:96
    P_bt(i)=sum(P_bt1((15*(i-1)+1):(15*i)))/15;
    P_cf(i)=sum(P_cf1((15*(i-1)+1):(15*i)))/15;
    P_dr(i)=sum(P_dr1((15*(i-1)+1):(15*i)))/15;
    P_sy(i)=sum(P_sy1((15*(i-1)+1):(15*i)))/15;
    P_tsh(i)=sum(P_tsh1((15*(i-1)+1):(15*i)))/15;
end
%%风场无功出力，假设定功率因数控制
cos_theta=0.9;
%1分钟一个点
Q_bt1=sqrt(P_bt1.^2/cos_theta^2-P_bt1.^2);
Q_cf1=sqrt(P_cf1.^2/cos_theta^2-P_cf1.^2);
Q_dr1=sqrt(P_dr1.^2/cos_theta^2-P_dr1.^2);
Q_sy1=sqrt(P_sy1.^2/cos_theta^2-P_sy1.^2);
Q_tsh1=sqrt(P_tsh1.^2/cos_theta^2-P_tsh1.^2);
%15分钟一个点
Q_bt=sqrt(P_bt.^2/cos_theta^2-P_bt.^2);
Q_cf=sqrt(P_cf.^2/cos_theta^2-P_cf.^2);
Q_dr=sqrt(P_dr.^2/cos_theta^2-P_dr.^2);
Q_sy=sqrt(P_sy.^2/cos_theta^2-P_sy.^2);
Q_tsh=sqrt(P_tsh.^2/cos_theta^2-P_tsh.^2);
%% 潮流计算
%%没有加入电容，1,2,3,6,8为发电机，其中1为无穷大节点，2为PV节点传统电厂，其余为风场，加入固定负荷
mpc = loadcase('case14for3');
for i=1:96
    %mpc.gen(1,2)=P_bt(i);
    mpc.gen(2,2)=P_cf(i);
    mpc.gen(3,2)=P_dr(i);
    mpc.gen(4,2)=P_sy(i);
    mpc.gen(5,2)=P_tsh(i);
    %mpc.gen(1,3)=Q_bt(i);
    mpc.gen(2,3)=Q_cf(i);
    mpc.gen(3,3)=Q_dr(i);
    mpc.gen(4,3)=Q_sy(i);
    mpc.gen(5,3)=Q_tsh(i);
    opt = mpoption('ENFORCE_Q_LIMS',1,'PF_ALG',1);
    result = runpf(mpc,opt);
    V(:,i)=result.bus(:,8);
end
clf;
for i=1:14
    plot(1:96,V(i,:));
    if i~=14
        hold on
    end
end
xlabel('时间');ylabel('电压');title('电压时间曲线');
legend('节点1','节点2','节点3','节点4','节点5','节点6','节点7','节点8','节点9','节点10','节点11','节点12','节点13','节点14');
pause;
clf;
plot(1:96,V(9,:));xlabel('时间');ylabel('电压');title('节点9电压时间曲线');
hold on;
pause;
%%加入电容
mpc = loadcase('case14for3');
for k=1:5
    mpc.bus(9,6)=3*k-8;
    for i=1:96
        %mpc.gen(1,2)=P_bt(i);
        mpc.gen(2,2)=P_cf(i);
        mpc.gen(3,2)=P_dr(i);
        mpc.gen(4,2)=P_sy(i);
        mpc.gen(5,2)=P_tsh(i);
        %mpc.gen(1,3)=Q_bt(i);
        mpc.gen(2,3)=Q_cf(i);
        mpc.gen(3,3)=Q_dr(i);
        mpc.gen(4,3)=Q_sy(i);
        mpc.gen(5,3)=Q_tsh(i);
        opt = mpoption('ENFORCE_Q_LIMS',1,'PF_ALG',1);
        result = runpf(mpc,opt);
        V0(:,i)=result.bus(:,8);
    end
    plot(1:96,V0(9,:));
    if k~=3
        hold on;
    end
end
legend('电容0','电容-5','电容-2','电容1','电容4','电容7');
pause;
%有电容时其它节点的电压变化
clf;
mpc = loadcase('case14for3');
mpc.bus(9,6)=7;
for i=1:96
    %mpc.gen(1,2)=P_bt(i);
    mpc.gen(2,2)=P_cf(i);
    mpc.gen(3,2)=P_dr(i);
    mpc.gen(4,2)=P_sy(i);
    mpc.gen(5,2)=P_tsh(i);
    %mpc.gen(1,3)=Q_bt(i);
    mpc.gen(2,3)=Q_cf(i);
    mpc.gen(3,3)=Q_dr(i);
    mpc.gen(4,3)=Q_sy(i);
    mpc.gen(5,3)=Q_tsh(i);
    opt = mpoption('ENFORCE_Q_LIMS',1,'PF_ALG',1);
    result = runpf(mpc,opt);
    V(:,i)=result.bus(:,8);
end
for i=1:14
    plot(1:96,V(i,:)); 
    if i~=14
        hold on
    end
end
xlabel('时间');ylabel('电压');title('电压时间曲线(电容=7）');
legend('节点1','节点2','节点3','节点4','节点5','节点6','节点7','节点8','节点9','节点10','节点11','节点12','节点13','节点14');