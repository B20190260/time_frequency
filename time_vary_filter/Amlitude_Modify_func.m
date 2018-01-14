%% STFT��ʱ���˲��ķ��Ȼ����������ԣ�����ϣ�����ط��Ȳ�ֵ������ϵķ����������Ȼ���
% ͨ�����ӵ��źŲ������ȷ������䣬��λҲ���ڻ��䣬��˲��ó����ˡ�
warning off;

%% STFT��3�����źŷ���+����У��
clear all; clc; close all
N=512;  t = 1:N;
[s1, sif1] = fmlin(N,0,0.4,120);%����IF���ƾ�ȷ
[s2, sif2] = fmlin(N,0.4,0,360);
[s3, sif3] = fmlin(N,0.2,0.2,60);
sam3 = (sin(0.05*t.' + pi/16)+2)/3;
s3 = s3.*sam3;
s_org = s1+s2+s3;%�źŵ���
s = awgn(s_org,10,'measured');
% s = s_org;
[sh1,tfr,tfrv1] = stftSeparation(s,[sif1,sif2,sif3],20);%�̶������ȵ�ʱ���˲�
% [sh2,tfr,tfrv2] = stftSeparationAdv(s,[sif1,sif2,sif3],20);%����Ӧ�����ȵ�ʱ���˲�
shf1 = amplitudeFit(sh1, tfr, tfrv1, 1);%���÷�����ϵķ�ʽ�ָ�--������λʧ��
% shf1 = amplitudeSacle(sh1, tfr, tfrv1);%���õ��ӷ���ķ�ʽ�ָ�
figure;
subplot(311);plot(t,real(s1),'b.-',t,real(s),'g',t,real(sh1(:,1)),'k.-',t,real(shf1(:,1)),'r.-'); 
axis tight;legend('orignal','noised','windowed','adaptive');%xlim([1,128])%�鿴��Եֵ
subplot(312);plot(t,real(s2),'b.-',t,real(s),'g',t,real(sh1(:,2)),'k.-',t,real(shf1(:,2)),'r.-'); 
axis tight;legend('orignal','noised','windowed','adaptive');%xlim([1,128])%�鿴��Եֵ
subplot(313);plot(t,real(s3),'b.-',t,real(s),'g',t,real(sh1(:,3)),'k.-',t,real(shf1(:,3)),'r.-'); 
axis tight;legend('orignal','noised','windowed','adaptive');%xlim([1,128])%�鿴��Եֵ



%%-----------------------------------------------
% �����ź�ʱ���˲���������ʹ�����ؿ���ģ��ó���MSE���ߡ����������źŵĶԱȡ�
% ����������õ����������źŷֱ���LFM��SFM��AM-LFM�����ؿ���������������źŵ�MSE���ɵõ�һ������ͼ��
%%-----------------------------------------------

% pause
% %% �������͵��źŻ�ϵ��źŻָ����
% clear all; clc; close all
% N=512;  t = 1:N;
% [s1, sif1] = fmlin(N,-0.2,0.1,120);%LFM
% [s2, sif2] = fmsin(N,0.1,0.35,400,1,0.35);%SFM
% [s3, sif3] = fmlin(N,0.2,-0.3,60);%AM-LFM
% sam3 = (sin(0.05*t.' + pi/16)+2)/3;
% s3 = s3.*sam3;
% s_org = s1+s2+s3;%�źŵ���
% s = awgn(s_org,0,'measured');



%% �źŷ��Ȳ�ֵ�㷨����
clear all; clc; close all
N=512;  t = 1:N;
[s1, sif1] = fmlin(N,0,0.4,120);%����IF���ƾ�ȷ
[s2, sif2] = fmlin(N,0.4,0,360);
[s3, sif3] = fmlin(N,0.2,0.2,60);
sam3 = (sin(0.05*t.' + pi/16)+2)/3;
s3 = s3.*sam3;
s_org = s1+s2+s3;%�źŵ���
s = awgn(s_org,100,'measured');
% s = s_org;
[sh1,tfr,tfrv1] = stftSeparation(s,[sif1,sif2,sif3],20);%�̶������ȵ�ʱ���˲�
% [sh2,tfr,tfrv2] = stftSeparationAdv(s,[sif1,sif2,sif3],20);%����Ӧ�����ȵ�ʱ���˲�
shf1 = amplitudeInterp(sh1, [sif1,sif2,sif3], 30, 1);%���÷��Ȳ�ֵ�ķ�ʽ�ָ�--������λʧ��
figure;
subplot(311);plot(t,real(s1),'b.-',t,real(s),'g',t,real(sh1(:,1)),'k.-',t,real(shf1(:,1)),'r.-'); 
axis tight;legend('orignal','noised','windowed','adaptive');%xlim([1,128])%�鿴��Եֵ
subplot(312);plot(t,real(s2),'b.-',t,real(s),'g',t,real(sh1(:,2)),'k.-',t,real(shf1(:,2)),'r.-'); 
axis tight;legend('orignal','noised','windowed','adaptive');%xlim([1,128])%�鿴��Եֵ
subplot(313);plot(t,real(s3),'b.-',t,real(s),'g',t,real(sh1(:,3)),'k.-',t,real(shf1(:,3)),'r.-'); 
axis tight;legend('orignal','noised','windowed','adaptive');%xlim([1,128])%�鿴��Եֵ






