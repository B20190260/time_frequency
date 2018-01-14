%% �ź���ǿ�㷨������۵�ͼ�����

%% �źŲ���
clear all; clc; close all;
Fs = 100;N=256; %��λ��ӦMHz, us
t = (0:(N-1))/Fs; f = linspace(0,Fs/2,N);
[s1, sif1] = fmlin(N,0.05,0.2);
[s2, sif2] = fmlin(N,0.35,0.09);
[s3, sif3] = fmsin(N,0.15,0.28,300);
s_org = s1+s2+s3;
s = awgn(s_org,100,'measured');% 5, 0, -5
tfr = tfrADTFD(s,2,15,82);
% tfr = tfr + 0.3*rand(N,N);% �ӵ�����ʾ��
figure;imagesc(tfr);%set_gca_style([12,6],'img');colormap('Cool');


%% �����ݶ���ת��ǿͼ��
[beta0, beta1, beta2]= gradientVector(tfr,2);%��ʽ6����beta0��1��2
[beta1fix, beta2fix] = vectorModify(beta1,beta2);% �ݶ���������

[x,y] = meshgrid(1:size(tfr,2),1:size(tfr,1));%��ͼר����������
figure('Name','ԭʼ�ݶȾ���'); quiver(x(:),y(:),beta2(:),beta1(:));
% set_gca_style([6,1.5]);
axis equal;axis off;set(gca, 'position', [0 0 1 1 ]);
% axis([50,90,140,150]);%axis([150,190,110,120]);%axis([110,150,108,118]);
figure('Name','��ת�ݶȾ���'); quiver(x(:),y(:),beta2fix(:),beta1fix(:));
% set_gca_style([6,1.5]);
axis equal;axis off;set(gca, 'position', [0 0 1 1 ]);
% axis([50,90,140,150]);%axis([150,190,110,120]);%axis([110,150,108,118]);

rImg1 = meanGradientRatioImgEasy(beta0, beta1, beta2, beta1fix, beta2fix,2);
figure('Name','�̶�����ǿ'); imagesc(rImg1); %set_gca_style([6,6],'img');
rImg2 = meanGradientRatioImg(beta0, beta1, beta2, beta1fix, beta2fix, 7);
figure('Name','����Ӧ����ǿ'); imagesc(rImg2); %set_gca_style([6,6],'img');
rBin = gradientImg2Bin(rImg2, 1000, 0.98);%imshow(rBin)
rImg2Fix = rImg2.*rBin;imagesc(rImg2Fix);


%% ��ǿ���ʱƵ�ֲ��½���IF����
img = rImg2Fix';%ѡ��ͼ��
[hif1,~] = IFest_compare_algorithm(img,5,10,3,90);
hif2 =tracks_LRmethod_my(img,4,10,1,90);
% �������
figure('Name','IF algorithms compare');F_scale = Fs/N/2;
for n=1:length(hif1) ;   hmcq=plot(hif1{n}(1:5:end,1)/Fs,hif1{n}(1:5:end,2)*F_scale,'ro-','MarkerSize',6); hold on; end   %����IF����
for n=1:length(hif2) ;   hlr=plot(hif2{n}(1:5:end,1)/Fs,hif2{n}(1:5:end,2)*F_scale,'bsquare-','MarkerSize',2.5); hold on; end   %����IF����
legend([hlr hmcq],{'LPDCL','BDIF'}); %set_gca_style([6,6]);
grid off; ylim([0,60]);%�������ͼ��
xlabel('ʱ��/\mus');ylabel('Ƶ��/Mhz');
% axis([1.1,2.1,12,25]);


pause
close all;
%% IFƬ�ε������㷨
% IFƬ�����
label={'ko-','bsquare-','rdiamond-','kv-','b^-','r<-','k<-','bpentagram-','rhexagram-','k+-','b*-','r.-','kx-'};%��ͼ����
linesInfo = curveModify(hif1,length(s),-2);%�޸����߷ֲ�����ʹ�ֱ�����ϴ��ڶ���������
figure('Name','IFs FIT');
for n=1:length(hif1) ;   hmcq=plot(hif1{n}(1:5:end,1)/Fs,hif1{n}(1:5:end,2)*F_scale,'ro-','MarkerSize',6); hold on;  end   %����IF����
for k = 1:length(linesInfo);    hfit = plot(linesInfo{k}.line(1:5:end,1)/Fs,linesInfo{k}.line(1:5:end,2)*F_scale,'b.-','MarkerSize',2.5);hold on;  end
legend([hmcq,hfit],{'IFƬ��','���IFƬ��'}); %set_gca_style([6,6]);
grid off; ylim([0,60]);%�������ͼ��
xlabel('ʱ��/\mus');ylabel('Ƶ��/Mhz');

% IFƬ������
linesCon = linesConnect(linesInfo,40);%����ƴ��
figure('Name','IFs Connect');
for k=1:length(linesCon);plot(linesCon{k}(1:5:end,1)/Fs,linesCon{k}(1:5:end,2)*F_scale,label{k});hold on; end
% set_gca_style([6,6]);
grid off; ylim([0,50]);xlabel('ʱ��/\mus');ylabel('Ƶ��/Mhz');

% �������
linesFinal = curveModify(linesCon,length(s),256);
figure('Name','IF FIT-pro');
for k = 1:length(linesFinal);    plot(linesFinal{k}.line(1:5:end,1)/Fs,linesFinal{k}.line(1:5:end,2)*F_scale, label{k});hold on; end
% set_gca_style([6,6]);
grid off; ylim([0,50]);xlabel('ʱ��/\mus');ylabel('Ƶ��/Mhz');

