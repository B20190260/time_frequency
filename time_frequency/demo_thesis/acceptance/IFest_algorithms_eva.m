% ����Ƶ��100MHz������1V
% ���ű��ļ��������С�˲ʱƵ�ʹ����½ڡ����ͼ�����ɵ���䣬
% ĳЩ��������̫ռ�ռ��װ�����������ˣ�����鿴��ע�͡�


%% ʱƵ���ص��������ź�-IF�����㷨�Ա�
clear all; clc; close all;
Fs = 100;N=256; %��λ��ӦMHz, us
t = (0:(N-1))/Fs; f = linspace(0,Fs/2,N);
[s1, sif1] = fmlin(N,0.03,0.09);
[s2, sif2] = fmlin(N,0.31,0.5);
[s3, sif3] = fmsin(N,0.15,0.28,300);
s_org = s1+s2+s3;%tfr = tfrstft(s_org);imagesc(abs(tfr));axis xy
s = awgn(s_org,10,'measured');
tfr = tfrADTFD(s,3,20,82);%imagesc(tfr);axis xy
tfr_emb = quadtfd(s, 127, 1, 'emb', 0.1, 0.3, N);%imagesc(tfr_emb);axis xy
[hif1,hif2] = IFest_compare_algorithm(tfr_emb.',10,20,3,75);%�Ա��㷨���ܵĽű�����
[hif3s] = IFest_proposed(tfr,10,20,3,75,2,7);%ʹ��hif1��ǿ����������Ż��㷨
for n=1:length(hif3s) ; hif3{n} = hif3s{n}.line; end

% �������
figure('Name','IF algorithms compare');F_scale = Fs/N/2;
for n=1:length(hif1) ;   hmcq=plot(hif1{n}(1:8:end,1)/Fs,hif1{n}(1:8:end,2)*F_scale,'ko-','MarkerSize',6); hold on; end   %����IF����
for n=1:length(hif2) ;   hlr=plot(hif2{n}(2:8:end,1)/Fs,hif2{n}(2:8:end,2)*F_scale,'bsquare-','MarkerSize',3); hold on; end   %����IF����
for n=1:length(hif3) ;   henmcq=plot(hif3{n}(3:8:end,1)/Fs,hif3{n}(3:8:end,2)*F_scale,'rp-','MarkerSize',6); hold on; end   %����IF����
legend([hlr hmcq henmcq],{'LPDCL','BDIF','proposed'}); %set_gca_style([6,6]);grid off; ylim([0,60]);%�������ͼ��
xlabel('ʱ��/\mus');ylabel('Ƶ��/Mhz');

hiferr = Fs * IFest_perferenceEva({hif1,hif2,hif3},[sif1,sif2,sif3],N)
%���ص��������΢��,100M��������ƽ������0.4M��ʲôˮƽ�����Խ���ΪƵ�ʷֱ��ʱ���ͺܵ�
% ��100M��256������˵���˾�һ�����ص�����⣩


pause(5)
%% ʱƵ���ص��������ź�-IF�����㷨�Ա�
clear all; 
Fs = 100;N=256; %��λ��ӦMHz, us
t = (0:(N-1))/Fs; f = linspace(0,Fs/2,N);
[s1, sif1] = fmlin(N,0.05,0.2, 5);
[s2, sif2] = fmlin(N,0.35,0.09,1);
[s3, sif3] = fmsin(N,0.15,0.28,300);
s_org = s1+s2+s3;
s = awgn(s_org,20,'measured');
tfr = tfrADTFD(s,2,15,82);%imagesc(abs(tfr));axis xy
tfr_emb = quadtfd(s, 127, 1, 'emb', 0.1, 0.3, N); %imagesc(tfr_emb);axis xy
[hif1,hif2] = IFest_compare_algorithm(tfr_emb.',10,20,3,75);%�Ա��㷨���ܵĽű�����
[hif3s] = IFest_proposed(tfr,10,20,3,75,2,7);%ʹ��hif1��ǿ����������Ż��㷨
for n=1:length(hif3s) ; hif3{n} = hif3s{n}.line; end

% �������
figure('Name','IF algorithms compare');F_scale = Fs/N/2;
for n=1:length(hif1) ;   hmcq=plot(hif1{n}(1:8:end,1)/Fs,hif1{n}(1:8:end,2)*F_scale,'ko-','MarkerSize',6); hold on; end   %����IF����
for n=1:length(hif2) ;   hlr=plot(hif2{n}(2:8:end,1)/Fs,hif2{n}(2:8:end,2)*F_scale,'bsquare-','MarkerSize',3); hold on; end   %����IF����
for n=1:length(hif3) ;   henmcq=plot(hif3{n}(3:8:end,1)/Fs,hif3{n}(3:8:end,2)*F_scale,'rp-','MarkerSize',6); hold on; end   %����IF����
legend([hlr hmcq henmcq],{'LPDCL','BDIF','proposed'}); %set_gca_style([6,6]);grid off; ylim([0,60]);%�������ͼ��
xlabel('ʱ��/\mus');ylabel('Ƶ��/Mhz');

hiferr = Fs * IFest_perferenceEva({hif1,hif2,hif3},[sif1,sif2,sif3],N)
% ��������ص������ص�Ҳֻ��˵���ã�����̫��



pause(5)
%% �����ź�IF���ƽ��
clear all; 
Fs = 100;N=256; %��λ��ӦMHz, us
t = (0:(N-1))/Fs; f = linspace(0,Fs/2,N);
[s1,sif1]=fmsin(N,0.1,0.4,128,1,0.1,1);%(N,FNORMIN,FNORMAX,PERIOD,T0,FNORM0,PM1)
[s2,sif2]=fmsin(N,0.1,0.4,128,1,0.4,1);%(N,FNORMIN,FNORMAX,PERIOD,T0,FNORM0,PM1)
s_org = s1+s2; 
s = awgn(s_org,100,'measured');
tfr = tfrADTFD(s,3,20,82);%
[hif1,hif2] = IFest_compare_algorithm(tfr.',10,20,2,75);%�Ա��㷨���ܵĽű�����
[hif3s] = IFest_proposed(tfr,10,20,2,75,2,5);%ʹ��hif1��ǿ����������Ż��㷨
for n=1:length(hif3s) ; hif3{n} = hif3s{n}.line; end

% �������
figure('Name','IF algorithms compare');F_scale = Fs/N/2;
for n=1:length(hif1) ;   hmcq=plot(hif1{n}(1:8:end,1)/Fs,hif1{n}(1:8:end,2)*F_scale,'ko-','MarkerSize',6); hold on; end   %����IF����
for n=1:length(hif2) ;   hlr=plot(hif2{n}(2:8:end,1)/Fs,hif2{n}(2:8:end,2)*F_scale,'bsquare-','MarkerSize',3); hold on; end   %����IF����
for n=1:length(hif3) ;   henmcq=plot(hif3{n}(3:8:end,1)/Fs,hif3{n}(3:8:end,2)*F_scale,'rp-','MarkerSize',6); hold on; end   %����IF����
legend([hlr hmcq henmcq],{'LPDCL','BDIF','proposed'}); %set_gca_style([6,6]);grid off; ylim([0,60]);%�������ͼ��
xlabel('ʱ��/\mus');ylabel('Ƶ��/Mhz');

hiferr = Fs * IFest_perferenceEva({hif1,hif2,hif3},[sif1,sif2],N)
% ��������ص����صľ;��зǳ��޴�ĸĽ�Ч����













