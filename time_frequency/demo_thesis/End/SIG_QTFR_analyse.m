% ����Ƶ��100MHz������1V
% ���ű��ļ��������С�ʱƵ���������½ڡ����ͼ�����ɵ���䣬
% ĳЩ��������̫ռ�ռ��װ�����������ˣ�����鿴��ע�͡�


%% LFM+SFM �� ʱƵ���Է���
clear all; close all;clc
Fs = 100;N=256; %��λ��ӦMHz, us
t = (0:(N-1))/Fs; f = linspace(0,Fs/2,N);
s1 = fmsin(N,0.1,0.3);
s2 = fmlin(N,0.35,0.1,128);
s = s1 + s2;
% s = awgn(s,50,'measured'); %%%%%%% ���������

figure;imagesc(abs(tfrstft(s1)));axis xy;set_gca_style([5,5]);axis off;set(gca, 'position', [0 0 1 1 ]);
figure;imagesc(abs(tfrstft(s2)));axis xy;set_gca_style([5,5]);axis off;set(gca, 'position', [0 0 1 1 ]);
figure;imagesc(abs(tfrstft(s)));axis xy;set_gca_style([5,5]);axis off;set(gca, 'position', [0 0 1 1 ]);


%% LFM+SFM �� ʱƵ���Է���
clear all; close all;clc
Fs = 100;N=256; %��λ��ӦMHz, us
t = (0:(N-1))/Fs; f = linspace(0,Fs/2,N);
s1 = fmsin(N,0.1,0.3,512);
s2 = fmlin(N,0.35,0.1,1);
s = s1 + s2;
% s = awgn(s,50,'measured'); %%%%%%% ���������

figure;imagesc(abs(tfrstft(s1)));axis xy;set_gca_style([5,5]);axis off;set(gca, 'position', [0 0 1 1 ]);
figure;imagesc(abs(tfrstft(s2)));axis xy;set_gca_style([5,5]);axis off;set(gca, 'position', [0 0 1 1 ]);
figure;imagesc(abs(tfrstft(s)));axis xy;set_gca_style([5,5]);axis off;set(gca, 'position', [0 0 1 1 ]);
