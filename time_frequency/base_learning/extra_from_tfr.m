%% ��ʱƵ�ֲ�����ȡ��Ϣ�ķ���



%% 1����λƫ�Ʋ����ĸ���ʱ�ƣ��鿴���ŷ������̺����ź���Ϣ
clear all; close all; clc;
% �۲��ź���λƫ�Ʋ����ĸ���ʱ�ƣ������̶�Ƶ�ʵ��źŵ��ӣ�����һ����λ�ı�
M=movpwdph(128); movie(M,10);%������λ���ƶ�������Ҳ���ƶ����ǳ��ÿ�
% �۲��ź���λƫ�Ʋ����ĸ���ʱ�ƣ��̶�Ƶ���źţ��м���λ����
M=movpwjph(128,8,'C'); movie(M,10);%����������λ�ı仯���ź�TFRҲ�ڱ仯������������ͼ��
% ��Щ�����������������λ�����ź�

%% 2��renyi��Ϣ����
clear all; close all; clc;
sig=atoms(128,[64,0.25,20,1]);
[TFR,T,F]=tfrwv(sig);
R1=renyi(TFR,T,F)%-0.2075
sig=atoms(128,[32,0.25,20,1;96,0.25,20,1]);
[TFR,T,F]=tfrwv(sig);
R2=renyi(TFR,T,F)%0.779
sig=atoms(128,[32,0.15,20,1;96,0.15,20,1;32,0.35,20,1;96,0.35,20,1]);
[TFR,T,F]=tfrwv(sig);
R3=renyi(TFR,T,F)%1.8029
% R2-R1Լ����1���ĸ�ԭ�ӣ���R3-R1Լ����2��2��ԭ�ӣ�>>>>�����ֻ��һ��ԭ�ӵ��ź���Ϊ��Ϣ��Ϊ0
% ��ô��������renyi��Ϣ����TFR�ֲ��еľ����Զ��Ϣ��Ԫ������

%% 3��TFR���LFM�źŵļ������
% ---ֻ��һ���ź��� AWGN�еĲ���
clear all; close all; clc;
N=64; 
sig=sigmerge(fmlin(N,0,0.3),noisecg(N),1);%�����ָ��
tfr=tfrwv(sig); 
contour(tfr,5);%����tfr���ͼ���Բ鿴Ч��
htl(tfr,N,N,1);%ͼ���еĻ���任ֱ�߼��
% ���Կ����ڲ�����p,theta���еķ�ֵ������ָ����ֵ�ж��Ƿ���ڣ���Ȼ�����(rho,theta)-->(v0,theta)�������������ơ�
% ��ʵ���Ǽ�����ϵת��Ϊ���϶�����ϵ�ı任���ɡ�
% ---����LFM�źŵĲ��ԣ�����WVD����������������ڻ���任��Ӱ�챻������
sig=sigmerge(fmlin(N,0,0.4),fmlin(N,0.3,0.5),1);
tfr=tfrwv(sig); 
contour(tfr,5);
htl(tfr,N,N,1);%���Կ�������LFM�ź�


%% 4��ʱ��-�߶�����ͼ-С���任���ṩ�ľֲ������Լ��
clear all; close all; clc;
sig=anasing(64);%Lipschitz singularity��H=0
[tfr,t,f]=tfrscalo(sig,1:64,4,0.01,0.5,256,1);%����Morlet wavelet��scalogram
H=holder(tfr,f,1,256,32) %����ʱ��ֲ�����㣬-0.0381
sig=anasing(64,32,-0.5);%Lipschitz singularity��H=-0.5
[tfr,t,f]=tfrscalo(sig,1:64,4,0.01,0.5,256,1);
H=holder(tfr,f,1,256,32)%H=-0.5107





