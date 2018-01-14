% CS����ȥ��ѹ��������ֻ�����ع����㷨����ô���ھ����������������źţ�����ع���������Ҫ����һ�¡�

clc;clear all; close all;

%%  1. ʱ������ź�����
clear all; close all; clc;
N=512;%��������
t=1:N;
f=linspace(0,0.5,N);
T0 = N/2;%��ʵ�ο���λλ��
[sig1,if1] = fmlin(N,0,0.3,T0);
[sig2,if2] = fmlin(N,0.2,0.5,T0);
k=0.3/N;%LFMб��
p = mod(2/pi*acot(-k*N),2);% FRFT��������һ��0-2֮��
x_org = sig1+sig2;
% x=awgn(x_org,10,'measured');%�������
x = x_org;

%%  3.  ����ƥ��׷�ٷ��ع��ź�(��������L_1�������Ż�����)
% ����������
bais=eye(N,N);
Psi = zeros(size(bais));
for k = 1:N
    Psi(:,k) = frft(bais(:,k),p)*sqrt(N);%�Ը��л���FRFT�任
end
% imagesc(real(Psi));imagesc(imag(Psi));imagesc(abs(Psi));
% frft_s = frft(s,p);%���� FRFT���Կ���ֻ�������źŷ���

% OMP�ع�
T=Psi';           %  �ָ�����(��������*�������任����)��y=�ָ�����*s������yΪ�۲����ݣ�sΪϡ���ʾϵ��
[hat_y1,r_n] = omp(x,T,N,1);%OMP�㷨�ع�1������
hat_s1=Psi'*hat_y1.';                         %  ���渵��Ҷ�任�ع��õ�ʱ���ź�

[hat_y2,r_n] = omp(r_n,T,N,1);%OMP�㷨�ع�1������
hat_s2=Psi'*hat_y2.';                         %  ���渵��Ҷ�任�ع��õ�ʱ���ź�

%%  4.  �ָ��źź�ԭʼ�źŶԱ�
figure
plot(t,real(sig1),'.-b');hold on              %  ԭʼ�ź�
plot(t,real(hat_s1),'o-r')                 %  �ؽ��ź�
legend('ԭʼ�ź�','�ؽ��ź�'),axis tight; xlabel('t/s')
%������
fprintf('����1�ع�MSE = %8f\n',norm(hat_s1 - sig1, 'fro')/norm(x - sig1,'fro'))

figure
plot(t,real(sig2),'.-b');hold on              %  ԭʼ�ź�
plot(t,real(hat_s2),'o-r')                 %  �ؽ��ź�
legend('ԭʼ�ź�','�ؽ��ź�'),axis tight; xlabel('t/s')
%������
fprintf('����2�ع�RMSE = %8f\n',norm(hat_s2 - sig2, 'fro')/norm(x - sig2,'fro'))

figure
plot(f,abs(frft(x_org,p)),'b.-'),axis tight;hold on
plot(f,abs((hat_y1+hat_y2)*sqrt(N)),'o-r')
legend('ԭʼ�ź�FRFT��','OMP�㷨�����');








