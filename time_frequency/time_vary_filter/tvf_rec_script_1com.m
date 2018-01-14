%% �������źŵ�ʱ���˲��ؽ�

%% 1.������LFM�źŵ�ʱ���˲��ؽ�
clear all; clc; close all
N=256; t = 1:N;
[s_org,sif] = fmlin(N,0,0.5,120);
s = awgn(real(s_org),5,'measured');% ת��Ϊʵ���źţ�������
% s_hat = stfrftTvf_1Cmpnt(s); % ������ʵ���ź�ʱ���˲�
s_hat = stftTvf_1Cmpnt(s); % ������ʵ���ź�ʱ���˲�
figure;plot(t,real(s_org),'b.-',t,real(s),'g',t,real(s_hat),'r.-'); 
axis tight;legend('orignal','noised','TVFed');%xlim([1,128])%�鿴��Եֵ


%% 2.������AM-LFM-PM�źŵ�ʱ���˲��ؽ�
clear all; clc; close all
N=512;  t = 1:N;
[sfm, sif] = fmlin(N,0,0.5,50);%plot(real(sfm))
sam = (cos(0.05*t)+2)/3;%plot(sam)
s_org = sfm.*sam.';%plot(real(s)) % ���ȵ���
s = awgn(real(s_org),5,'measured');% ת��Ϊʵ���źţ�������
% s_hat = stfrftTvf_1Cmpnt(s); % ������ʵ���ź�ʱ���˲�
s_hat = stftTvf_1Cmpnt(s); % ������ʵ���ź�ʱ���˲�
figure;plot(t,real(s_org),'b.-',t,real(s),'g',t,real(s_hat),'r.-'); 
axis tight;legend('orignal','noised','TVFed');%xlim([1,128])%�鿴��Եֵ
% ����̫��ʱ��Ҫ��IF����Ч��̫���ˣ����¸ñ任������Ҳ̫���ˡ�





