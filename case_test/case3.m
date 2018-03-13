clear
%% ���ݻ�ȡ
% %%��������
% load1 = xlsread('���縺��ͳ�����',1,'B2:B97')/1000;
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
%%�糡�й�����
%��ͷ�糡
P_bt1=xlsread('26��ͷ�糡',2,'G119500:G120939');
%����糡
P_cf1=xlsread('27����糡',2,'E74180:E75619');
%��ɽ���糡
P_tsh1=xlsread('28��ɽ���糡',2,'E119210:E120649');
%����糡
P_dr1=xlsread('48����糡',2,'E12596:E14035');
%ɼԴ�糡
P_sy1=xlsread('49ɼԴ�糡',2,'E91476:E92915');
%15����һ����
for i=1:96
    P_bt(i)=sum(P_bt1((15*(i-1)+1):(15*i)))/15;
    P_cf(i)=sum(P_cf1((15*(i-1)+1):(15*i)))/15;
    P_dr(i)=sum(P_dr1((15*(i-1)+1):(15*i)))/15;
    P_sy(i)=sum(P_sy1((15*(i-1)+1):(15*i)))/15;
    P_tsh(i)=sum(P_tsh1((15*(i-1)+1):(15*i)))/15;
end
%%�糡�޹����������趨������������
cos_theta=0.9;
%1����һ����
Q_bt1=sqrt(P_bt1.^2/cos_theta^2-P_bt1.^2);
Q_cf1=sqrt(P_cf1.^2/cos_theta^2-P_cf1.^2);
Q_dr1=sqrt(P_dr1.^2/cos_theta^2-P_dr1.^2);
Q_sy1=sqrt(P_sy1.^2/cos_theta^2-P_sy1.^2);
Q_tsh1=sqrt(P_tsh1.^2/cos_theta^2-P_tsh1.^2);
%15����һ����
Q_bt=sqrt(P_bt.^2/cos_theta^2-P_bt.^2);
Q_cf=sqrt(P_cf.^2/cos_theta^2-P_cf.^2);
Q_dr=sqrt(P_dr.^2/cos_theta^2-P_dr.^2);
Q_sy=sqrt(P_sy.^2/cos_theta^2-P_sy.^2);
Q_tsh=sqrt(P_tsh.^2/cos_theta^2-P_tsh.^2);
%% ��������
%%û�м�����ݣ�1,2,3,6,8Ϊ�����������1Ϊ�����ڵ㣬2ΪPV�ڵ㴫ͳ�糧������Ϊ�糡������̶�����
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
xlabel('ʱ��');ylabel('��ѹ');title('��ѹʱ������');
legend('�ڵ�1','�ڵ�2','�ڵ�3','�ڵ�4','�ڵ�5','�ڵ�6','�ڵ�7','�ڵ�8','�ڵ�9','�ڵ�10','�ڵ�11','�ڵ�12','�ڵ�13','�ڵ�14');
pause;
clf;
plot(1:96,V(9,:));xlabel('ʱ��');ylabel('��ѹ');title('�ڵ�9��ѹʱ������');
hold on;
pause;
%%�������
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
legend('����0','����-5','����-2','����1','����4','����7');
pause;
%�е���ʱ�����ڵ�ĵ�ѹ�仯
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
xlabel('ʱ��');ylabel('��ѹ');title('��ѹʱ������(����=7��');
legend('�ڵ�1','�ڵ�2','�ڵ�3','�ڵ�4','�ڵ�5','�ڵ�6','�ڵ�7','�ڵ�8','�ڵ�9','�ڵ�10','�ڵ�11','�ڵ�12','�ڵ�13','�ڵ�14');