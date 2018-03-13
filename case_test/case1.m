% clear
for i=1:96
    P_bt(i)=sum(P_bt1((15*(i-1)+1):(15*i)))/15;
    P_cf(i)=sum(P_cf1((15*(i-1)+1):(15*i)))/15;
    P_dr(i)=sum(P_dr1((15*(i-1)+1):(15*i)))/15;
    P_sy(i)=sum(P_sy1((15*(i-1)+1):(15*i)))/15;
    P_tsh(i)=sum(P_tsh1((15*(i-1)+1):(15*i)))/15;
end
clf;
figure(1)
plot(1:96,P_cf,1:96,P_dr,1:96,P_sy,1:96,P_tsh);
pause;
cos_theta=0.9;
Q_bt1=sqrt(P_bt1.^2/cos_theta^2-P_bt1.^2);
Q_cf1=sqrt(P_cf1.^2/cos_theta^2-P_cf1.^2);
Q_dr1=sqrt(P_dr1.^2/cos_theta^2-P_dr1.^2);
Q_sy1=sqrt(P_sy1.^2/cos_theta^2-P_sy1.^2);
Q_tsh1=sqrt(P_tsh1.^2/cos_theta^2-P_tsh1.^2);
Q_bt=sqrt(P_bt.^2/cos_theta^2-P_bt.^2);
Q_cf=sqrt(P_cf.^2/cos_theta^2-P_cf.^2);
Q_dr=sqrt(P_dr.^2/cos_theta^2-P_dr.^2);
Q_sy=sqrt(P_sy.^2/cos_theta^2-P_sy.^2);
Q_tsh=sqrt(P_tsh.^2/cos_theta^2-P_tsh.^2);
mpc = loadcase('case14for1');
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
    opt = mpoption('ENFORCE_Q_LIMS',1,'PF_ALG',1,'VERBOSE',0,'OUT_ALL',0);
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
%xlabel('ʱ��');ylabel('��ѹ');title('��ѹʱ������');
%legend('�ڵ�1','�ڵ�2','�ڵ�3','�ڵ�4','�ڵ�5','�ڵ�6','�ڵ�7','�ڵ�8','�ڵ�9','�ڵ�10','�ڵ�11','�ڵ�12','�ڵ�13','�ڵ�14');
pause;
clf;
plot(1:96,V(9,:));
%xlabel('ʱ��');ylabel('��ѹ');title('�ڵ�9��ѹʱ������');
hold on;
pause;
%�������
mpc = loadcase('case14for1');
for k=1:5
    mpc.bus(9,6)=-5*k;
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
        opt = mpoption('ENFORCE_Q_LIMS',1,'PF_ALG',1,'VERBOSE',0,'OUT_ALL',0);
        result = runpf(mpc,opt);
        V0(:,i)=result.bus(:,8);
    end
    plot(1:96,V0(9,:));
    if k~=3
        hold on;
    end
end
%legend('����0','����-5','����-10','����-15','����-20','����-25');
pause;
%�е���ʱ����ڵ�ĵ�ѹ�仯
clf;
mpc = loadcase('case14for1');
mpc.bus(9,6)=-25;
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
    opt = mpoption('ENFORCE_Q_LIMS',1,'PF_ALG',1,'VERBOSE',0,'OUT_ALL',0);
    result = runpf(mpc,opt);
    V(:,i)=result.bus(:,8);
end
for i=1:14
    plot(1:96,V(i,:));
    if i~=14
        hold on
    end
end
%xlabel('ʱ��');ylabel('��ѹ');title('��ѹʱ������');
%legend('�ڵ�1','�ڵ�2','�ڵ�3','�ڵ�4','�ڵ�5','�ڵ�6','�ڵ�7','�ڵ�8','�ڵ�9','�ڵ�10','�ڵ�11','�ڵ�12','�ڵ�13','�ڵ�14');

