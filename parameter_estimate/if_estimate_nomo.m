
%% IF���Ʋ���
clear all; clc, close all;

%% �������źŲ����͹���
N=312;
t = 1:N;
[s_org,rif]=fmsin(N,0.15,0.45,200,1,0.35,1);%����Ϊ100����λ0��Ϊ1��t0����Ƶ��Ϊ0.35��Ƶ�ʷ���Ϊ��
s = awgn(s_org,5,'measured');
if1 = zce( s, 64);plot(t,if1,'b.-'); hold on
if2 = wvpe(s, 127, 1);plot(t,if2,'r.-');
if3 = pwvpe(s,127,1,8);plot(t,if3,'k.-');
if4 = rls(s,0.5);plot(t,if4,'bx-');
if6 = lms(s,0.5);plot(t,if6,'kx-');
if7 = sfpe (s, 127, 1);plot(t,if7,'rsquare-');
legend('zce','wvpe','pwvpe','rls','lms','sfpe');axis tight
% ���Է���ZCE��WVPE�Ϻã���wvpe���������Ѿ�����õ�TFD>>ʧ�ܣ���������





