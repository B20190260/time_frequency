% ������ͬ��ѹ����������׷��������ź�



%% �źŲ���
clear;clc;close all
N = 512;t = 0:(N-1);
[s1,if1] = fmlin(N,0.1,0.15);
% [s2,if2]=  fmsin(N,0.3,0.35,200);
[s2,if2]=  fmlin(N,0.05,0.35,200);
s_org =  s1+s2;
s = awgn(s_org,10,'measured');
x = real(s);




%% �źŷ���
[Tx, fs,Wx,as,w] = synsq_cwt_fw(t,x,16);
% xhat = synsq_cwt_iw(Tx,fs);
% figure;plot(t,x,'bo-',t,xhat,'r.-'); axis tight;
[Txf1,fmi,fMi] = synsq_filter_pass(Tx,fs,0.9*if1,1.1*if1);%����IF���ƾ�ȷ
[Txf2,fmi,fMi] = synsq_filter_pass(Tx,fs,0.9*if2,1.1*if2);
s1hat = synsq_cwt_iw(Txf1,fs);
s2hat = synsq_cwt_iw(Txf2,fs);




%% ��ͼ
figure;%�����ͬ��ѹ��С����
subplot(131);imagesc(abs(Tx)); axis xy;
subplot(132);imagesc(abs(Txf1)); axis xy;
subplot(133);imagesc(abs(Txf2)); axis xy;
figure;%�����ʱ���ź�
subplot(311);plot(t,real(s1),'bx-',t,s1hat,'r.-');axis tight; legend('orignal','seperated')
subplot(312);plot(t,real(s2),'bx-',t,s2hat,'r.-');axis tight; legend('orignal','seperated')
subplot(313);plot(t,real(s_org),'bx-',t,x,'g+-',t,s1hat+s2hat,'r.-');axis tight; legend('orignal','noised','synthesised')








