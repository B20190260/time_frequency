%% �����źŵķ���
clear all; close all;clc

%% 1��ѡ���źŵ�Ƶ�ʷ�����ʽ
[s,s_itfr] = signal_gen_my();%ָ���źŲ���
itfd = s_itfr';%���BD����ʾ����
figure;contour(itfd);% colormap('hot');
title('����ʱƵ�ֲ�');%����ʱƵ�ֲ��Ĳ鿴
xlabel('f/Hz'),ylabel('t/s')
% % load test_signal

% tfd = quadtfd( s, 127, 1, 'mb',0.08);%����BD��
% figure; p = tfsapl( s, tfd); %wfall(tfd')



%% curvelet ��������Чȥ��Ч��
% tfr = tfrspwv(s);%��Ч�����С�
% tfr(isnan(tfr))=0;
% subplot(121);imshow(abs(tfr),[]);colormap('hot');
% subplot(122);
% C = fdct_usfft(tfr);
% for k1 = 1:length(C)
%     for k2 = 1:length(C{k1})
%         tmp = C{k1}{k2};
% %         imshow(abs(tmp),[]); colormap('hot');pause(0.05)
%         tmp(abs(tmp)<15)=0;
%         C{k1}{k2} = tmp;
%     end
% end
% tfrr = ifdct_usfft(C,0);
% imshow(abs(tfrr),[]); colormap('hot');

%% ����ʱƵ�ֲ�
% figure;tfrbj(s);%��Ƶ��SIN��Ƶ���󣬶��ҽ��沿�ָ�������
% figure;tfrbud(s);%�ֱ��ʲ���
% figure; tfrcw(s);%ͬ��
% figure;tfrdfla(s);%�ֱ����㹻��������̫��
% figure;tfrbert(s);%�ֱ����㹻��������̫��
% figure;tfrgabor(s);%�ֱ���̫�������
% figure;tfrgrd(s);%ģ��̫���أ���Ƶ�źŶ�ʧ
% figure;tfrppage(s);%���������������ǿ
% figure;tfrparam(s);%������
% tfrpmh(s);%�������̫ǿ
% tfrpwv(s);%������̫��
% tfrrgab(s);%��ʧ��Ƶ��ϸ��̫��
% tfrridb(s);%��Ƶ�ɷ���ʧ��ϸ��̫�࣬SIN��Ƶ��������
% tfrridbn(s);%����һ����࣬LFM�źŽϺ�
% tfrridt(s);%����һ���Բ�
% tfrrpwv(s);%��Ƶ�źŶ�ʧ����ϸ�ڣ����Ž϶�
% tfrrsp(s);%SP�пɿ�����ŷֲ���R��ʧ��Ƶϸ��
% tfrrspwv(s);%��SPWVD���С�
% tfrscalo(s);%Ч��һ��
% tfrspaw(s);%������̫��
% tfrstft(s);%��Ч�����á�
% tfrzam(s);%�ֱ��ʱ�ǰ�߸ߣ�����ϸ�ڶ�ʧ�϶�
% tfrspwv(s);%��Ч�����С�

% Gt = kaiser(31,1);%betaԽ������Խ����
% Hf = kaiser(15,1);
% tfrrspwv(s,1:length(s),length(s),Gt,Hf);%����Ĭ�ϵĺ�����Ч��


TFD_AFS = tfrAFS(s);figure;imagesc(TFD_AFS);axis xy
TFD_ADTFD = tfrADTFD(s,3,12,82);figure;imagesc(TFD_ADTFD);axis xy


