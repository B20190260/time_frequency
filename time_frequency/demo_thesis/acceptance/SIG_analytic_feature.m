%% �����źŵ�Ƶ������ʾ��
clear all; close all; clc; 
Fs = 100;N=128; %��λ��ӦMHz, us
t = (0:(N-1))/Fs; f = linspace(-Fs/2,Fs/2,N);
s = real(fmconst(N,0.07,1) + fmconst(N,0.22,1));%7M+22M COS�źŵ���
sF = abs(fftshift(fft(s)));sF = sF/max(sF);
sa = hilbert(s);%�����ź�
saF = abs(fftshift(fft(sa)));saF = saF/max(saF);
%���������źż���Ƶ��
figure;plot(t,s,'k-'); xlabel('ʱ��/\mus');ylabel('����/V');
% set_gca_style([7,4]);
figure;plot(f,sF,'k-'); xlabel('Ƶ��/MHz');ylabel('��һ������');
% set_gca_style([7,4]);
%���ƽ����źż���Ƶ��
figure;plot(t,real(sa),'b^-','LineWidth',1.3,'MarkerSize',3);hold on; 
plot(t,imag(sa),'k-.','LineWidth',0.7); xlabel('ʱ��/\mus');ylabel('����/V');legend('ʵ��','�鲿');
% set_gca_style([7,4]);
figure;plot(f,saF,'k-'); xlabel('Ƶ��/MHz');ylabel('��һ������');
% set_gca_style([7,4]);
