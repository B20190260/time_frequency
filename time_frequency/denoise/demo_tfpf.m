%% �ο���Rankine L, Mesbah M, Boashash B. 
% IF estimation for multicomponent signals using image processing techniques in the time�Cfrequency domain [J]. 
% Signal Process, 2007, 87(6): 1234-50.
% ��2.2�ڵ�ʵ�ֲ���
%% ���ۣ���ε������ź�˥����ǿ���������ֻ�ʺ�����������
% ��TFPF����������Ľ�ʵ���ź���ΪIF��Ϣ�����ƣ�������ʵЧ��������ʹ�õ�ͨ�˲�����ʱ���˲��ء�
% ֻ��������һ���ź���ǿ�㷨��Ҳ���ǡ�IF���Ƶ�Ӧ�ó���֮һ����

%% ����ʱƵ��ֵ�˲����ź���ǿ
clear all; close all; clc
N = 512; t = 1:N; Fs = 1;
maxf = 0.08;
s_org = fmlin(N,0.01,maxf);%���0.05���ź�Ƶ��
s = awgn(s_org,5,'measured');
x = real(s); xt = x;

for k=1:1
    [y,tfr] = tfpf_iter_org(xt,maxf);
%     [y,tfr] = tfpf_ref(xt,9,0.9);
    plot(t,real(s_org),'bx-',t,x,'g',t,y,'r.-');axis tight;legend('ԭʼ�ź�','�������ź�','��ǿ���ź�')
    pause(0.05)
    xt = y;
end


%% ������źŵ��˲�
clear all; close all; clc
N = 512; t = 1:N; Fs = 1;
maxf = 0.4;
s_org = fmlin(N,0.01,0.1) + fmsin(N,0.12,0.28) + fmlin(N,0.3,0.4);%���0.05���ź�Ƶ��
s = awgn(s_org,0,'measured');%tfrspwv(s);
x = real(s); 

xt = x;
for k=1:4
    %[y,tfr] = tfpf_iter_org(xt,maxf);
    [y,~] = tfpf_iter(xt,maxf);tfr = tfrspwv(hilbert(y.'));
    subplot(4,1,1:3);imagesc(abs(tfr));axis xy;pause(0.1)
    subplot(4,1,4);plot(t,real(s_org),'bx-',t,x,'g',t,y,'r.-');axis tight;legend('ԭʼ�ź�','�������ź�','��ǿ���ź�')
    pause(0.05)
    xt = y;
end




%% TFR��ǿ������WVD��SPWVD���
% clear all; close all; clc
% N = 512; t = 1:N; Fs = 1;
% s_org = fmlin(N,0.01,0.45) + fmlin(N,0.41,0.05) ;%���0.05���ź�Ƶ��
% s = awgn(s_org,10,'measured');
% tf1 = tfrwv(s);
% tf2 = tfrspwv(s);
% tf = tf1.*tf2;
% subplot(131);imagesc(tf1);
% subplot(132);imagesc(tf2);
% subplot(133);imagesc(tf);








