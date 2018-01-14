function [y,tfr] = tfpf_iter(s, maxf)
%% һ��ʱƵ��ֵ�˲�����������
% ԭ��ο��� Boashash B, Mesbah M. Signal enhancement by time-frequency peak filtering [J]. IEEE Transactions on Signal Processing, 2004, 52(4): 929-37.
% �Լ���Rankine L, Mesbah M, Boashash B. IF estimation for multicomponent signals using image processing techniques in the time�Cfrequency domain [J]. Signal Process, 2007, 87(6): 1234-50.
% ���룺
% s : �����źţ�������ʵ���ź�
% maxf�������źŵ��������Ƶ��fmax/Fs���ò�����PWVD���ӳٴ����ȹ�ϵ�ܴ�

s = s(:);
if nargin < 2; maxf = 0.05; end
%% ������ȡ�ͳ�ʼ��
UpSampling = 1/maxf;%��������������ʵ���ǲ���Ƶ�����ź����Ƶ�ʵı���
WinLen = floor(1.28*UpSampling/pi) - 1;%ʱ�Ӵ����ȣ��м��㹫ʽ����UpSampling�й�ϵ
WinLen = WinLen + (~mod(WinLen,2));%����������
if WinLen<3; WinLen = 3; end
% �źŵ���ǿЧ����WinLen��������Էǳ��󣡣�������
GuardEdge = WinLen * 2;%�źŵ�������չ

FreqLen = 512;%Ƶ���������
Miu = 0.9;%IF��Ϣ���ţ�1��ʾ0-0.5��Χ��
h=ones(WinLen,1);%PWVD�Ĵ���������ʱѡ����δ�
guard = ones(GuardEdge,1);%��Ե����

%% �����źŲ���
% �ź�������
% sr = resample(s,UpSampling,1);%����������%plot(sr,'.-');axis tight;
sr = [guard*s(1);s;guard*s(end)];%�������ǲ���ʱ�������������������㷨��һ���֣���
% ������������ͽ��������Ž��㷨�����������𲻵��ź���ǿ��Ч������Ϊ����Ҳ������������ʱ��ƽ���ˡ�
maxValue = max(sr(:));
minValue = min(sr(:));
% �źŹ�һ�����ϳɽ����ź�
x = (sr - minValue)/(maxValue-minValue)*0.3+0.1;%�ź��������ŵ�0.1-0.4֮��
sc = cumsum(x);%�ۼӺ�%plot(sc)
z = exp(1j * 2 * pi * Miu * sc);%���������ź�z

%% PWVD��ֵIF����
[tfr,~,~]=tfrpwv(z,1:length(z),FreqLen,h);
% figure;[tfr,T,F]=tfrwv(z,1:length(z),FreqLen);
% subplot(4,1,1:3);imagesc(tfr); subplot(4,1,4);plot(sr); axis tight
% figure;[tfr,T,F]=tfrpwv(z,1:length(z),FreqLen,h);
% subplot(4,1,1:3);imagesc(tfr); subplot(4,1,4);plot(sr); axis tight
[~,flaw]=max(tfr);%���ҷ�ֵ��Ӧ��IFֵ
flaw = flaw/FreqLen/2;%��һ����0-0.5֮��
ye = (flaw/Miu - 0.1) * (maxValue-minValue)/0.3 + minValue;%���任��ȥ��ԭʼ�źŷ���

% �źŽ�����
% y = resample(ye,1,UpSampling);%�źŽ�����
y = ye((GuardEdge+1):(end - GuardEdge));
tfr = tfr(:,(GuardEdge+1):(end - GuardEdge));
% t = 1:length(s); plot(t,s,'bx-',t,y,'r.-');



end