%% SFM�źŵ�SFMT�任
clear all; clc; close all;
N = 128; k0 = 2;l0 = 16;%�źŲ���
t = [0:N-1]';
s = exp(1i*l0/k0*sin(2*pi*k0*t/N));%plot(t,real(s),'.-') %��ʽ5����֪k0��l0ʱ�ָ�ԭʼ�źŵķ���
[X,s_hat] = sfmt(s);
surf(abs(X));xlabel('k');ylabel('l');axis tight; grid on;
colormap('hot');%shading interp
