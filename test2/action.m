% one voltage control action in matpower
%setup V_ref
mpc = loadcase('mycase');
load('PV.mat');
PV = PV / 1;
opt = mpoption('ENFORCE_Q_LIMS',1,'PF_ALG',1,'VERBOSE',0,'OUT_ALL',0);
Vref_29 = [];
N=3000;
Vref_29 = ones(1,N);

dQ = [];
dV = [];
P3 = zeros(10,N);
Q3 = zeros(10,N);
dQ_list = [];

main_node = [1,6,25,12,23,25,29];
contorl_node = [1,6,30,32,35,37,38];
PV_node = [41, 46, 66, 59, 62];
PV_num = 5;
[m, node_num] =size(main_node);
dQsum = zeros(1,7);
dQsum2 = 0;
cscv = 0;
for i=1:N
    dQsum
    dQ_store(:,i) = dQsum';
    mpc.gen(1,2)=P_windgen30(i);
    mpc.gen(3,2)=P_windgen32(i);
    mpc.gen(6,2)=P_windgen35(i);
    mpc.gen(7,2)=P_windgen36(i);
    mpc.gen(8,2)=P_windgen37(i);
    mpc.gen(9,2)=P_windgen38(i);
    mpc.gen(1,3)=Q_windgen30(i);
    mpc.gen(3,3)=Q_windgen32(i);
    mpc.gen(6,3)=Q_windgen35(i);
    mpc.gen(7,3)=Q_windgen36(i);
    mpc.gen(8,3)=Q_windgen37(i);
    mpc.gen(9,3)=Q_windgen38(i);
    
    mpc.bus(1,3)=P_load1(i);
    mpc.bus(1,4)=Q_load1(i)- dQsum(1)+120;
    mpc.bus(3,3)=P_load3(i);
    mpc.bus(3,4)=Q_load3(i);
    mpc.bus(4,3)=P_load4(i);
    mpc.bus(4,4)=Q_load4(i);
    mpc.bus(6,3)=P_load6(i);
    mpc.bus(6,4)=Q_load6(i)- dQsum(2)+300;
    mpc.bus(7,3)=P_load7(i);
    mpc.bus(7,4)=Q_load7(i);
    mpc.bus(8,3)=P_load8(i);
    mpc.bus(8,4)=Q_load8(i);
    mpc.bus(9,3)=P_load9(i);
    mpc.bus(9,4)=Q_load9(i);
    mpc.bus(10,3)=P_load10(i);
    mpc.bus(10,4)=Q_load10(i);
    mpc.bus(11,3)=P_load11(i);
    mpc.bus(11,4)=Q_load11(i);
    mpc.bus(12,3)=P_load12(i);
    mpc.bus(12,4)=Q_load12(i);
    mpc.bus(15,3)=P_load15(i);
    mpc.bus(15,4)=Q_load15(i);
    mpc.bus(16,3)=P_load16(i);
    mpc.bus(16,4)=Q_load16(i);
    mpc.bus(18,3)=P_load18(i);
    mpc.bus(18,4)=Q_load18(i);
    mpc.bus(20,3)=P_load20(i);
    mpc.bus(20,4)=Q_load20(i);
    mpc.bus(21,3)=P_load21(i);
    mpc.bus(21,4)=Q_load21(i);
    mpc.bus(23,3)=P_load23(i);
    mpc.bus(23,4)=Q_load23(i);
    mpc.bus(24,3)=P_load24(i);
    mpc.bus(24,4)=Q_load24(i);
    mpc.bus(25,3)=P_load25(i);
    mpc.bus(25,4)=Q_load25(i);
    mpc.bus(26,3)=P_load26(i);
    mpc.bus(26,4)=Q_load26(i);
    mpc.bus(27,3)=P_load27(i);
    mpc.bus(27,4)=Q_load27(i);
    mpc.bus(28,3)=P_load28(i);
    mpc.bus(28,4)=Q_load28(i);
    mpc.bus(29,3)=P_load29(i);
    mpc.bus(29,4)=Q_load29(i);
    mpc.bus(39,3)=P_load39(i);
    mpc.bus(39,4)=Q_load39(i);
    
    mpc.bus(30,4)=-15 -dQsum(3);
    mpc.bus(32,4)=-450 -dQsum(4);
    mpc.bus(35,4)=-7 -dQsum(5);
    mpc.bus(37,4)=-18 -dQsum(6);
    mpc.bus(38,4)= -25 -dQsum(7);
    
    mpc.bus([41, 46, 66, 59, 62] , 3) = - PV(i, [1,2,1,2,3])';
    mpc.bus([53], 3) = -PV(i, 3);
    
    result = runpf(mpc,opt);
    %cal c
    if cscv == 0
        if i == 1
            for k = 1:node_num
                cn = contorl_node(k);
                pn = main_node(k);
                mpc2 = mpc;
                mpc2.bus(cn,4) = mpc.bus(cn,4) + 0.1;
                result2 = runpf(mpc2,opt);
                c(k) = -(result2.bus(pn,8)-result.bus(pn,8))/0.1;
            end
        end
        if rem(i,5)==0
            for k = 1:node_num
                cn = contorl_node(k);
                pn = main_node(k);
                dV(k) = Vref_29(i) - result.bus(pn, 8); 
                if abs(dV(k)) > 0.015
                    dQ(k) = dV(k)/c(k);
                    mpc.bus(cn, 4) = mpc.bus(cn, 4) - dQ(k);
                    dQsum(k) = dQsum(k) + dQ(k);          
                end
                result = runpf(mpc,opt);
            end
        end
        dQ_list = [dQ_list dQsum'];
    end
    if cscv == 1
        if i == 1
            for k = 1:node_num
                for m = 1:node_num
                cn = contorl_node(m);
                pn = main_node(k);
                mpc2 = mpc;
                mpc2.bus(cn,4) = mpc.bus(cn,4) + 0.1;
                result2 = runpf(mpc2,opt);
                cc(k,m) = -(result2.bus(pn,8)-result.bus(pn,8))/0.1;
                end
            end
            for k = 1:node_num
            end
        end
        if rem(i,5)==0
            dv = zeros(node_num,1);
            for k = 1:node_num
                cn = contorl_node(k);
                pn = main_node(k);
                dv(k) = Vref_29(i) - result.bus(pn, 8); 
            end
            if abs(max(dv)) > 0.015
                    dQ = inv(cc'*cc+5e-20*eye(node_num))*cc'*dv;
                    for k=1:node_num
                        cn = contorl_node(k);
                        pn = main_node(k);
                        mpc.bus(cn, 4) = mpc.bus(cn, 4) - dQ(k);
                        dQsum(k) = dQsum(k) + dQ(k);
                    end
            end
                result = runpf(mpc,opt);

        end
    end
    V4(:,i) = result.bus(:,8);
    %QO4(i,:) = result.bus(:,4)';
    %QO4(i,30:39) = QO4(i,30:39) - result.gen(:,3)';
    i
end


