%% ��֤����IF estimation of FM signals based on time-frequency image �е��ź�
clear;clc;close all;

%% 1���źŽ��洦����һ�����Ƿ�ֵ
% �źŲ���
T0 = 14;
N=1024;t = 0:(N-1);
[s1,if1] = fmlin(N, 0.4, 0, T0);
[s2,if2] = fmsin(N,0.1,0.4,N*2,T0,0.1,-1);
s = real(s1+s2);

% �źŲ���
% T0 = 2;T3 = 5;
% N=1024;t = 0:(N-1);
% [s1,if1] = fmlin(N, 0.35, 0.4, T0);
% [s2,if2] = fmsin(N,0.1,0.3,N*2/1.5,N/2,0.1,1);
% [s3,if3] = fmlin(N, 0.1, 0.35, T0);
% s = s1+s2+s3;

% TFR����
tfr = quadtfd( s, 127, 1, 'emb',0.03,0.3);%����BD��
figure; 
% p = tfsapl( s, tfr);
imagesc(tfr); colormap('hot');axis xy;%
%���߲��õ���EMBD�׶�����ͨ�������BD�ס�


%% 2���ݶ�ͼ�����Ķ�ֵ�����Ҳ���ǽ��洦���ѵ�
% img = tfr(:,1:2:end);%ͼ��ģ��
% portion = 0.96;%ͼ���ֵ��
% [lines,rBin,rImg] = IfLineSegmentDetection(img,portion,'gradient');%��ȡͼ���е�������Ϣ
% figure;imshow(rBin);%figure; p = tfsapl( s, rImg);



%% 3�����ߵĳ���������Է�ֵ�������������һЩ��ֵƬ�������ӡ��β�ֱ�Ӽ���ֵ�أ���  



