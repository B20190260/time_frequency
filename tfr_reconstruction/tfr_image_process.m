%% TFR��ͼ��IF������ȡ��ͼ��ָ�


%% �����źŻָ�
% TFR��ȡ
clear all; close all; clc;
N=512;%��������
t=1:N;
f=linspace(0,0.5,N);
T0 = 1;%��ʵ�ο���λλ��
[sig1,if1] = fmlin(N,0,0.3,T0);
[sig2,if2] = fmlin(N,0.2,0.5,T0);
sig = sig1+sig2;
[~,tfr] = tfrrspwv(sig); tfr = abs(tfr);%��ȡ�����TFR
% ��ֵ��
% hist_tfr=hist(tfr(:),linspace(min(tfr(:)),max(tfr(:)),100));%��ֱ��ͼ�ֲ��л�ȡ�����ֵ������һ�������ѡ����
tfr_nor = tfr/max(tfr(:));%��һ��TFR
hresh = graythresh(tfr_nor);%����Ӧѡ����ֵ
tfr_bin = tfr_nor>hresh;%��ֵ��
imshow(tfr_bin); axis xy;hold on
% % ϸ������
% tfr_thin = bwmorph(tfr_bin, 'thin',Inf);%ϸ������
% subplot(122);imshow(tfr_thin); axis xy;%������ϸ��������û�в�������
% ����任ֱ�߼��
[H,T,R] = hough(tfr_bin);%����任���鿴����Ŀ¼���и����ջ�
P  = houghpeaks(H,10,'threshold',ceil(0.3*max(H(:))));%�����10����ֵ����ֵ����ֵ�������0.3maxH
lines = houghlines(tfr_bin,T,R,P);%���ֱ�ߣ������߶ζ˵�
%�źŻָ�
IFLAW = cell(1,length(lines));
sig_each = cell(1,length(lines));
for k = 1:length(lines)
    x1 = lines(k).point1;x1(2) = x1(2)*0.5/N;%��һ��������Ƶ����
    x2 = lines(k).point2;x2(2) = x2(2)*0.5/N;%��һ��������Ƶ����
    xy = [lines(k).point1; lines(k).point2];    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');%��ͼ
    IFLAW{k} = (t-x1(1))*(x2(2) - x1(2))/(x2(1)-x1(1))+x1(2);%�����źŷ�����˲ʱƵ�ʺ���
    if_temp = IFLAW{k};%������IF����
    if_temp(if_temp>0.5) = 0.5;%��ֹ���������ͻ
    sig_each{k} = fmodany(if_temp',T0);%�����ź�
end
%�ָ��źŶԱȣ�ʱ��
figure; plot(t,real(sig1),'b.-',t,real(sig_each{1}),'ro-');legend('ԭʼ�ź�','�����ź�');axis tight; xlabel('t/s')
figure; plot(t,real(sig2),'b.-',t,real(sig_each{2}),'ro-');legend('ԭʼ�ź�','�����ź�');axis tight; xlabel('t/s')
figure; subplot(121); plot(t,if1,'b.-',t,IFLAW{1},'o-r'); legend('ԭʼ�ź�','�����ź�');axis tight
subplot(122);plot(t,if2,'b.-',t,IFLAW{2},'o-r'); legend('ԭʼ�ź�','�����ź�');axis tight
%�����Դ��TFR�˵㴦������Ӱ����ֱ�߼�⣬��ֱ��б���е�ƫ�������ô�����Ĳ�����
% ���������ȥ�����˵�ͼ�����ݺ��ټ�⣬���߶��ڸ���t��F����ֵ�Ȳ��������õĹ���ȷ��Fֵ��


