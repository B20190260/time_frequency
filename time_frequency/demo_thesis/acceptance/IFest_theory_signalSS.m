%% �ԱȲ�ͬ�ź��£�TFR-��ǿ-IF����-Ƭ������ ��������IF���ƽ��

%% �źŲ���
clear all; close all; clc
Fs = 100;N=256; %��λ��ӦMHz, us
t = (0:(N-1))/Fs; f = linspace(0,Fs/2,N);
[s1,sif1]=fmsin(N,0.1,0.4,128,1,0.1,1);%(N,FNORMIN,FNORMAX,PERIOD,T0,FNORM0,PM1)
[s2,sif2]=fmsin(N,0.1,0.4,128,1,0.4,1);%(N,FNORMIN,FNORMAX,PERIOD,T0,FNORM0,PM1)
s = s1+s2; sif = [sif1,sif2]; s_org = [s1, s2];% tfrspwv(s);
% s = awgn(s,10,'measured');
tfr = tfrADTFD(s,3,20,82);%
figure('Name','ADTFR');imagesc(tfr);%set_gca_style([5,5],'img');

%% �㷨ʵ��
win1 = 2; win2 = 5;

[beta0, beta1, beta2]= gradientVector(tfr,win1);%��ʽ6����beta0��1��2
[beta1fix, beta2fix] = vectorModify(beta1,beta2);% �ݶ���������

% [x,y] = meshgrid(1:size(tfr,2),1:size(tfr,1));%��ͼר����������
% figure('Name','ԭʼ�ݶȾ���'); quiver(x(:),y(:),beta2(:),beta1(:));
% set_gca_style([6,1.5]);axis equal;axis off;set(gca, 'position', [0 0 1 1 ]);
% axis([50,90,140,150]);%axis([150,190,110,120]);%axis([110,150,108,118]);
% figure('Name','��ת�ݶȾ���'); quiver(x(:),y(:),beta2fix(:),beta1fix(:));
% set_gca_style([6,1.5]);axis equal;axis off;set(gca, 'position', [0 0 1 1 ]);
% axis([50,90,140,150]);%axis([150,190,110,120]);%axis([110,150,108,118]);

% rImg1 = meanGradientRatioImgEasy(beta0, beta1, beta2, beta1fix, beta2fix,win1);
% figure('Name','�̶�����ǿ'); imagesc(rImg1); set_gca_style([6,6],'img');
rImg2 = meanGradientRatioImg(beta0, beta1, beta2, beta1fix, beta2fix, win2);
figure('Name','����Ӧ����ǿ'); imagesc(rImg2); %set_gca_style([5,5],'img');
% rBin = gradientImg2Bin(rImg2, 1000, 0.98);%imshow(rBin)
% rImg2Fix = rImg2.*rBin;imagesc(rImg2Fix);set_gca_style([6,6],'img');


img = rImg2';%ѡ��ͼ��
[hif1,~] = IFest_compare_algorithm(img,5,10,3,90);%ֻѡ��BDIF�㷨�������Ϊ����
% hif3 =tracks_LRmethod_my(img,4,10,1,90);
% �������
figure('Name','IF algorithms compare');F_scale = Fs/N/2;
for n=1:length(hif1) ;   hmcq=plot(hif1{n}(:,1)/Fs,hif1{n}(:,2)*F_scale,'r-'); hold on;  end   %����IF����
% for n=1:length(hif3) ;   hlr=plot(hif3{n}(:,1)/Fs,hif3{n}(:,2)*F_scale,'b:'); hold on; end   %����IF����
% legend([hlr hmcq],{'LPDCL','BDIF'}); 
% set_gca_style([6,6]);
grid off; ylim([0,50]);%�������ͼ��
xlabel('ʱ��/\mus');ylabel('Ƶ��/Mhz');
% axis([1.1,2.1,12,25]);

%% ͼ�������㷨
% IFƬ�����
label={'ro-','b.-','r^-','kv-','b^-','r<-','k<-','bpentagram-','rhexagram-','k+-','b*-','r.-','kx-'};%��ͼ����
linesInfo = curveModify(hif1,length(s),-2);%�޸����߷ֲ�����ʹ�ֱ�����ϴ��ڶ���������
% figure('Name','IFs FIT');
% for n=1:length(hif1) ;   hmcq=plot(hif1{n}(:,1)/Fs,hif1{n}(:,2)*F_scale,'ro-'); hold on;  end   %����IF����
% for k = 1:length(linesInfo);    hfit = plot(linesInfo{k}.line(:,1)/Fs,linesInfo{k}.line(:,2)*F_scale,'b.-');hold on;  end
% legend([hmcq,hfit],{'IFƬ��','���IFƬ��'}); set_gca_style([6,6]);grid off; ylim([0,50]);%�������ͼ��
% xlabel('ʱ��/\mus');ylabel('Ƶ��/Mhz');

% IFƬ������
linesCon = linesConnect(linesInfo,40);%����ƴ��
% figure('Name','IFs Connect');
% for k=1:length(linesCon);plot(linesCon{k}(:,1)/Fs,linesCon{k}(:,2)*F_scale,label{k});hold on; end
% set_gca_style([6,6]);grid off; ylim([0,50]);xlabel('ʱ��/\mus');ylabel('Ƶ��/Mhz');

% �������
enLen = 20;
linesFinal = curveModify(linesCon,length(s),enLen);%--��Ҫ����̫���Ա�������IFҲ����ȫ��
figure('Name','IF FIT-pro');
for k = 1:length(linesFinal);    
    if length(linesFinal{k}.line)<(enLen*2 + 50); continue;end %% ȥ��̫�̵�IF�����ź�
    plot(linesFinal{k}.line(1:5:end,1)/Fs,linesFinal{k}.line(1:5:end,2)*F_scale, label{k});hold on; 
end
% set_gca_style([6,6]);
grid off; ylim([0,50]);xlabel('ʱ��/\mus');ylabel('Ƶ��/Mhz');
% plot(t,sif1*Fs,'b^',t,sif2*Fs,'rv');

sif_hat = linesFinal;



