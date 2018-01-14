function [lines,rBin,rImg] = IfLineSegmentDetection(img,portion,mthd)
%% �������imgͼ����Ҫ���ʱƵ�ֲ�ͼ���е���������Ƭ��
% ���� img ͼ��double
% ���lin�ṹ�����飬��⵽�ĸ�������Ƭ�ε�����IF���ݣ�
% ������Ҫ��lin{k}�бȽ����ڵ����������������бȽ϶�С�ĸɵ������ߵ����˷ֲ�ϲ�+�ӳ�����
% ���rBin�Ƕ�ֵ����ľ�ֵ�ݶ�ͼ�񣬰����������Ϣ��
% �ο���Zhang H, Bi G, Yang W, et al. IF estimation of FM signals based on time-frequency image[J]. IEEE Transactions on Aerospace and Electronic Systems, 2015, 51(1): 326-343.

% �ű����Դ��룺
% clear all; clc; close all;
% load img %����ͼ������
% img = img(1:2:end, 1:2:end);%��Сͼ��ӿ촦���ٶ�
% figure; imagesc(img);axis xy

if nargin<3
    mthd = 'gradient';
end%normal�������


%% ������ʼ��
winLen = ceil(length(img)/50);%������Ϊ2*winLen+1�����������Ҫ�˹�����ʱƵͼ�Ĵ��ߴ����
% img = img(1:5:end, 1:5:end)ʱѡ��3��img = img(1:2:end, 1:3:end)ʱѡ��6��
% img=img����ʱѡ��11��==>winLen = ceil(length(img)/50);
segs = 1000;%rImgϸ������
% portion = 0.94;%rImg��0����
cleanArea = round(winLen*winLen/2);%ɾ�����С�ڴ�ֵ�Ĳ��ְٿ�--��Ϊ�⼫�п���������

if strcmp(mthd,'gradient')
    %% �����ݶ�ͼ��
    [beta0, beta1, beta2]= gradientVector(img,winLen);%��ʽ6����beta0��1��2
    [beta1fix, beta2fix] = vectorModify(beta1,beta2);% �ݶ���������
    % [x,y] = meshgrid(1:size(img,2),1:size(img,1));%��ͼר����������
    % figure; quiver(x(:),y(:),beta2(:),beta1(:));axis tight;%����Fig2�������beta1��beta2������ò���е㷴
    % figure; quiver(x(:),y(:),beta2fix(:),beta1fix(:));axis tight;%����Fig2�������beta1��beta2������ò���е㷴

    %% �������ͼ��Mean ratio images������������ռ�ȶ�ֵ��
    % rImg = meanGradientRatioImg(beta0, beta1, beta2, beta1fix, beta2fix);
    rImg = meanGradientRatioImgEasy(beta0, beta1, beta2, beta1fix, beta2fix,winLen);
    % figure; surf(rImg); axis tight
else
    rImg = img;
end
rBin = gradientImg2Bin(img, segs, portion);

%% ϸ������ȡͼ��������Ϣ
rBinClean = bwareaopen(rBin,cleanArea,8);%imshow(rBinClean)
rBinfix = bwmorph(rBinClean,'thin',1000);%ϸ���Ĵ�����֮ǰѡ��Ĵ������й�
% figure;subplot(211);imshow(rBin);axis xy;
% subplot(212);imshow(rBinfix);axis xy;
% [L,num] = bwlabel(rBinfix, 8); S = regionprops(L, 'Area');lineSkel = bwmorph(rBin,'skel',Inf);
[lines, bimg]= bwboundaries(rBinfix',8);
% figure;
% for k=1:length(lines)
%     plot(lines{k}(:,1),lines{k}(:,2),'.-'); hold on; grid on;
%     axis([1,length(rBin),1, length(rBin)]);
% end

%% ���飺�ȰѸ���ֱ�߶����һ�£���Ϊ����������ò�����Ļ�ֱ�����˻��зֲ�
% Ŀǰ���img���ݵ�ͼ��Ч���������ó��Ľ�����ǲ���

end







