%% ԭ�ӷֽ⣬��һ��������


%% 1��gabor������STFT
clear,clc
load gabor
time=0:337; subplot(211); 
plot(time,gabor);
dsp=fftshift(abs(fft(gabor)).^2);%FFT
freq=(-169:168)/338*1000; 
subplot(212); plot(freq,dsp);
tfr = tfrstft(gabor);%��ʱ����Ҷ�任��
figure,imagesc(time,freq,abs(tfr));axis xy
xlabel('Time [ms]'); ylabel('Frequency [Hz]');
title('Squared modulus of the STFT of the word GABOR');


%% 2��ʱƵ�ֱ��ʶԱ�
clear all; close all; clc;
x=real(amgauss(128).*fmlin(128));
h=1; %ʱ��߷ֱ���h=delta
tfrstft(x,1:128,128,h);
h=ones(127,1); %Ƶ��߷ֱ���h=1
tfrstft(x,1:128,128,h);
sig=atoms(128,[45,.25,32,1;85,.25,32,1]);%������ͬ����ʱ�̵���ͬ�źţ���˹���ȹ̶�Ƶ�ʣ�
%�ܳ���Ϊ128����һ�����ĵ�Ϊ45��Ƶ��Ϊ0.25fs������ʱ��Ϊ32���㡢����Ϊ1���ڶ������ĵ�Ϊ85��Ƶ��Ϊ.25������ʱ��Ϊ32���㣬����Ϊ1��
h=hanning(65);
figure,tfrstft(sig,1:128,128,h);%Ƶ�ʷֱ��ʸߣ�����ʱ���޷��ֱ��������ź�
h=hanning(17);
figure,tfrstft(sig,1:128,128,h);%ʱ��ֱ��ʺܸߣ�����Ƶ���޷��ֱ����Ƶ��


%% 3��Gobarչʾ----�ڲ�ͬ�������µ�Gobarϵ��
clear all; close all; clc;
N1=256; Ng=33; Q=1; % �ٽ������
sig=fmlin(N1); 
g=gausswin(Ng); %��˹������
g=g/norm(g);%��һ��
[tfr,dgr,h]=tfrgabor(sig,16,Q,g);%Gobarϵ�����
% ����ֵ��Gobarϵ��ƽ����Gobar����ϵ����g��˫������h
subplot(311),plot(h); 
subplot(3,1,[2,3]),imagesc(tfr);axis xy
xlabel('Time'); ylabel('Normalized frequency'); axis('xy');
title('Squared modulus of the Gabor coefficients');
% ���Կ����ٽ����ʱh���ȶ�
Q=4;%4��������
[tfr,dgr,h]=tfrgabor(sig,16,Q,g);%Gobarϵ�����
% ����ֵ��Gobarϵ��ƽ����Gobar����ϵ����g��˫������h
figure,subplot(311),plot(h); 
subplot(3,1,[2,3]),imagesc(tfr);axis xy
xlabel('Time'); ylabel('Normalized frequency'); axis('xy');
title('Squared modulus of the Gabor coefficients');
% ���Կ���������ʱh�Ѿ����ȶ���QԽ��Խ�ȶ�


%% 4�������׸�����ͷֱ���
clear all; close all; clc;
% �����������ź�----���ڽ������
sig=fmlin(128,0,0.4)+fmlin(128,0.1,0.5);
h1=gausswin(23);
figure(1); tfrsp(sig,1:128,128,h1);%���㹦���ף�����ָ��������
h2=gausswin(63);
figure(2); tfrsp(sig,1:128,128,h2);%Ĭ�ϲ��õ��Ǻ�����
% ����������������̫���������۴����Ƕ��ٶ��޷����ֿ�����
% Զ��������ź�----������ź�С
sig=fmlin(128,0,0.3)+fmlin(128,0.2,0.5);
h1=gausswin(23);
figure(3); tfrsp(sig,1:128,128,h1);%���㹦���ף�����ָ��������
h2=gausswin(63);
figure(4); tfrsp(sig,1:128,128,h2);%Ĭ�ϲ��õ��Ǻ�����
% ��Խ��ʱ��ֱ���Խ�ߣ�Ƶ��ֱ���Խ�͡���֮��Ȼ��


%% 5��scalogram��ͼ��С���任
clear all; close all; clc;
sig1=anapulse(128);%Dirac pulse
figure(1),tfrscalo(sig1,1:128,6,0.05,0.45,128,1);%������ͼ
% ��ͼ�п��Կ�����Ƶ�ʲ��֣���ӦС��a��ʱ��ǳ����У�Ƶ�ʼ�С��a����ʱʱ����չ��
sig2=fmconst(128,.15)+fmconst(128,.35);%���������źŵ���
figure(2),tfrscalo(sig2,1:128,6,0.05,0.45,128,1);
% ���Կ���Ƶ�ʷֱ�������Ƶ�ʱ仯����Ƶ���ֱַ��ʵ�
% ����������ԣ�������Ų���Ҳ�����ڣ����ź�����㹻Զʱ�ſ�������0��




