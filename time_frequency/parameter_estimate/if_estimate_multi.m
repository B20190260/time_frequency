%% �ο������ַ��https://github.com/otoolej/time_frequency_tracks

%% �źŲ���
clear all; clc, close all;
N=512;
Fs = 100e6;
MIN_LEN = 20;%���IFƬ�γ���
IF_NUMBER = 3;%IFƬ������
s = fmlin(N,0.01,0.05) + fmlin(N,0.1,0.16) + fmlin(N,0.2,0.5);
% s = fmsin(N,0.1,0.3,400,400,0.2) + fmlin(N,0.05,0.4);
% s = fmsin(N,0.1,0.25,200);
x = awgn(s,0,'measured');
%% ����TFD
% tf1 = full_tfd(real(x),'sep',{{51,'hann'},{51,'hann'}},N,N);% tf1 = dec_tfd(x,'sep',{{51,'hann'},{51,'hann'}},512,512,1,1);
%ǰһ����Խ������ֱ��������Խ���У����Ǹ���Խ�󣻺�һ����Խ����ˮƽ��������Խ���У����Ǹ���Խ��
tf2 = quadtfd(x, 127, 1, 'emb', 0.1, 0.3, N)';% tf2 = tfrspwv(x); %�ڶ�������ҲӰ�����
% subplot(121),imagesc(tf1');axis xy;subplot(122),imagesc(tf2');axis xy;
tf = tf2;% tf = abs(tfrspwv(x))';
t_scale=(1/Fs);  f_scale=(Fs/2)/size(tf,2); %��ͼ�õĹ�һ������

%% Rankine et al. (2007) method: �Ľ�֮�������˵��ڲ��ֵ������˳�
delta_freq_samples= 10;%IF׷�ٵ��ݶȣ��������Ϊ10��ͼ�����
min_track_length=MIN_LEN;%��̸���IFƬ�γ���
lower_prctile_limit = 60; % ���Ե��ڸ������İٷֱ�
it=tracks_LRmethod(tf,1,delta_freq_samples,min_track_length,lower_prctile_limit);%��������Fs=1��������������������Ϊͼ�����

%% McAulay and Quatieri (1986) method:
max_peaks=IF_NUMBER;%ÿ��ʱ�������ظ�IF����
it2=tracks_MCQmethod(tf,Fs,delta_freq_samples,min_track_length,max_peaks);

%% HRV CPL IF estimation--��ʵ����2007�����ַ�������һ��д��
tfps = tfdpeaks(tf', 2);%�ڶ���������peaks�İٷֱȣ�ԽС�����ķ�ֵԽ��
[it3_r, cps] = edgelink3(tfps,20); %�ڶ�����������̱�Ե����

% ��ͼ
figure(1); clf; hold all; 
for n=1:length(it)
    %hlr=plot(it{n}(:,1).*t_scale,filt_if_law(it{n}(:,2).*f_scale),'k+-');%�˲��ᵼ�±�Եƫ��
    hlr=plot(it{n}(:,1).*t_scale,it{n}(:,2).*f_scale,'ko-'); 
end
for n=1:length(it2)
    %hmcq=plot(it2{n}(:,1).*t_scale,filt_if_law(it2{n}(:,2).*f_scale),'rx-'); 
    hmcq=plot(it2{n}(:,1).*t_scale,it2{n}(:,2).*f_scale,'r+-'); 
end
for n = 1:length(it3_r)
    %hhrv=plot(it3_r{n}(:,2).*t_scale,filt_if_law(it3_r{n}(:,1).*f_scale),'b.-'); 
    hhrv=plot(it3_r{n}(:,2).*t_scale,it3_r{n}(:,1).*f_scale,'bx-'); 
end
xlabel('time (seconds)'); ylabel('frequency (Hz)');axis tight
legend([hlr hmcq hhrv],{'LR method','MCQ method','HRV CPL method'},'location','northwest');
set_gca_style()






