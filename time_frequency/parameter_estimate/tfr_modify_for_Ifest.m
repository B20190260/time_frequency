%% TFR�����㷨

% �źŲ���
clear all; clc; close all;
Fs = 100;N=256; %��λ��ӦMHz, us
t = (0:(N-1))/Fs; f = linspace(0,Fs/2,N);
[s1, sif1] = fmlin(N,0.05,0.2);
[s2, sif2] = fmlin(N,0.35,0.09);
[s3, sif3] = fmsin(N,0.15,0.28,300);
s_org = s1+s2+s3;
s = awgn(s_org,100,'measured');% 5, 0, -5
tfr = tfrADTFD(s,2,15,82);%figure;imagesc(tfr);axis xy;

[beta0, beta1, beta2]= gradientVector(tfr,2);%��ʽ6����beta0��1��2
[beta1fix, beta2fix] = vectorModify(beta1,beta2);% �ݶ���������

[x,y] = meshgrid(1:size(tfr,2),1:size(tfr,1));%��ͼר����������
figure; quiver(x(:),y(:),beta2(:),beta1(:));axis equal;axis tight;axis([115,150,100,130])%����Fig2�������beta1��beta2������ò���е㷴
figure; quiver(x(:),y(:),beta2fix(:),beta1fix(:));axis equal;axis tight;axis([115,150,100,130])%����Fig2�������beta1��beta2������ò���е㷴

%% �������ͼ��Mean ratio images������������ռ�ȶ�ֵ��
rImg = meanGradientRatioImg(beta0, beta1, beta2, beta1fix, beta2fix, 7);figure; imagesc(rImg); axis xy;
% rImg = meanGradientRatioImgEasy(beta0, beta1, beta2, beta1fix, beta2fix,3);figure; imagesc(rImg); axis xy;
% rImgFilter = filter2(fspecial('gaussian',8),rImg);%surf(rImgFilter);%����Ӧ�����ͼ��Ƚϼ��񣬿����ʵ���ƽ���Ա�IF��ȡ
segs = 1000;%rImgϸ������
portion = 0.97;%rImg��0����
rBin = gradientImg2Bin(rImgFilter, segs, portion);%imshow(rBin)
rImgFix = rImg.*rBin;imagesc(rImgFix);


% Ƶ�ʹ����㷨
delta_freq_samples= 10;%IF׷�ٵ��ݶȣ��������Ϊ10��ͼ�����
min_track_length= 1;%��̸���IFƬ�γ���
max_peaks= 3;%ÿ��ʱ�������ظ�IF����
hif1=tracks_MCQmethod(rImgFix',Fs,delta_freq_samples,min_track_length,max_peaks);%1986
lower_prctile_limit= 90; % ���Ե��ڸ������İٷֱ�
hif2=tracks_LRmethod(rImgFix',1,delta_freq_samples,min_track_length,lower_prctile_limit);%2007
% tfps = tfdpeaks(rImgFix', 2);%�ڶ���������peaks�İٷֱȣ�ԽС�����ķ�ֵԽ��
% [hif2, cps] = edgelink3(tfps,1); %�ڶ�����������̱�Ե����

figure(1); clf; hold all;
for n=1:length(hif1);    hmcq=plot(hif1{n}(:,1),hif1{n}(:,2),'ko-'); end
for n=1:length(hif2);    hlr=plot(hif2{n}(:,1),hif2{n}(:,2),'r+-'); end
xlabel('time (seconds)'); ylabel('frequency (Hz)');axis tight
legend([hlr hmcq],{'LR method','MCQ method'});


% �����Լ��޸ĵ��㷨ʵ��Ч��
delta_time_samples = 15;% �����ʱ���������
hif3=tracks_LRmethod_my(rImg2Fix',delta_time_samples,delta_freq_samples,min_track_length,lower_prctile_limit);
figure(1); clf; hold all;
for n=1:length(hif3);    hlr=plot(hif3{n}(:,1),hif3{n}(:,2),'r+-'); end
% �Լ�������IF�����㷨
rBin = gradientImg2Bin(img, 1000, 0.95);
rBinClean = bwareaopen(rBin,cleanArea,8);%imshow(rBinClean)
rBinfix = bwmorph(rBinClean,'thin',1000);%ϸ���Ĵ�����֮ǰѡ��Ĵ������й�
% figure;subplot(211);imshow(rBin);axis xy;
% subplot(212);imshow(rBinfix);axis xy;
% [L,num] = bwlabel(rBinfix, 8); S = regionprops(L, 'Area');lineSkel = bwmorph(rBin,'skel',Inf);
[hif4, bimg]= bwboundaries(rBinfix',8);


%% Ƭ�����Ӻ�����㷨
% linesSim = linesSimplify(hif1);%����ȥ��--��Щ�㷨���Ƶ�˲ʱƵ��Ƭ�β�������ص����
linesInfo = curveModify(hif1,length(s),-3);%�޸����߷ֲ�����ʹ�ֱ�����ϴ��ڶ���������
figure;label={'ko-','bsquare-','rdiamond-','kv-','b^-','r<-','k<-','bpentagram-','rhexagram-','k+-','b*-','r.-','kx-'};
for k = 1:length(linesInfo)
    plot(linesInfo{k}.line(:,1),linesInfo{k}.line(:,2),label{1+mod(k,length(label))});hold on; grid on
    linesInfo{k}.type
end
linesCon = linesConnect(linesInfo,40);%����ƴ��%k=1;plot(linesCon{k}(:,1),linesCon{k}(:,2),'rx-');hold on; grid on
linesFinal = curveModify(linesCon,length(s),256);
figure;label={'ko-','bsquare-','rdiamond-','kv-','b^-','r<-','k<-','bpentagram-','rhexagram-','k+-','b*-','r.-','kx-'};
for k = 1:length(linesFinal)
    plot(linesFinal{k}.line(:,1),linesFinal{k}.line(:,2),label{k});hold on; grid on
    linesFinal{k}.type
end
