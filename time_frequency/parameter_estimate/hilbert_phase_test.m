%% ����ϣ�����ر任���˲ʱ��λ�Ƿ�ɿ�
% ���ۣ�����������ԵĹ����������ۼ�Ӱ�����Ĳ��������

clear;close all;clc

% �źŲ���
t=0:0.01:30;
Phase = t+cos(t);
phase = mod(Phase,2*pi);
y=cos(Phase);

% ��λ���
xhat=hilbert(y);
Pha=angle(xhat);%phase of signal��ϣ�����ر任�õ���˲ʱ��λ�ǰ�����λ
pha=unwrap(Pha);%Correct pha angles
figure(1)
plot(t,Pha,'.-r',t,pha,'.-r',t,Phase,'k-x',t,phase,'k-x');
legend('uncorrected','corrected','real uncorrected','real corrected');



figure(2)
Phase1 = t;
Phase2 = cos(2*t);
y=cos(Phase1)+cos(Phase2);
xhat=hilbert(y);
Pha=angle(xhat);%phase of signal
pha=unwrap(Pha);%Correct pha angles
figure(2)
plot(t,Phase1,'.-b',t,Phase2,'o-r',t,pha,'k-p');
legend('Phase1','Phase2','messured');


