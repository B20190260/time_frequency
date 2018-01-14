%% �����ֲ����ڶ�����������

%% Cohen��
%% 1��Wigner-Ville distribution
clear all; close all; clc;
sig=fmlin(256);tfrwv(sig);%���Կ���WVD�ֲ����зǳ���������Ƶ�ֲ����ԣ���ֵ����Ϊ����
[fm,am,iflaw]=doppler(256,50,13,10,200);%�������ź�
% [��Ƶ�źţ����ȷ�����˲ʱƵ��law] = [��������������Ƶ�ʣ�Ŀ��Ƶ�ʣ�Ŀ����룬Ŀ���ٶȣ�����ʱ��]
sig=am.*fm; tfrwv(sig);%���Կ���������ŷ����ǳ���
sig=fmlin(128,0,0.3)+fmlin(128,0.2,0.5);tfrwv(sig);%���Կ������ڽ�����ŷ���
% ���������ɲ鿴:Oscillating structure of the interferences of the WVD
M=movwv2at(256);%�����޸�movwv2at�����ĵڶ����������ƹ�������
figure;clf; movie(M,10);
% ���Կ������ž������Ӻͷ���仯ʱ��������ݱ���й���

%% 2���Ա�WVD��PWVD�Ŀ�����
clear all; close all; clc;
sig=atoms(128,[32,.15,20,1;96,.15,20,1;...
                    32,.35,20,1;96,.35,20,1]);%�����ĸ�ԭ�ӵ��ź�[t1,f1,T1,A1]
figure,tfrwv(sig);%6��������ĵ���
figure,tfrpwv(sig);%������4������ĸ�����

%% 3��WVD�Ĳ����ʿ��ǣ�ʹ�ý����źŵĺô�
clear all; close all; clc;
sig=atoms(128,[32,0.15,20,1;96,0.32,20,1]);
figure,tfrwv(real(sig));%�պ���������ʵ�ʵ���źŵ�WVD
figure,tfrwv(sig);

%% 4��smoothed-pseudo Wigner-Ville distribution
clear all; close all; clc;
sig=fmconst(128,.15) + amgauss(128).*fmconst(128,0.4);%�����źŵĵ���
tfr_wvd=tfrwv(sig); subplot(131);imagesc(tfr_wvd);axis xy; title('WVD');
tfr_pwvd=tfrpwv(sig);subplot(132);imagesc(tfr_pwvd);axis xy;title('PWVD');
tfr_spwvd = tfrspwv(sig);subplot(133);imagesc(tfr_spwvd);axis xy;title('SPWVD');
% �鿴SPWVD�ӹ������˻���WVD�Ĺ��̣���ô����Ƶ�ֱ��ʿ��Ƹı�ʱ
M=movsp2wv(128);% �����޸�movsp2wv�����ĵڶ����������ƹ�������
movie(M,10);

%% 5��narrow-band ambiguity function
clear all; close all; clc;
N=64; %��������LFM*��˹˥���źŵ���
sig1=fmlin(N,0.2,0.5).*amgauss(N);
sig2=fmlin(N,0.3,0).*amgauss(N);
sig=[sig1;sig2];%����ź�
figure(1);tfrwv(sig);%�����ź���м�һЩ�𵴵ĸ���
figure(2);ambifunb(sig);%��AF�ף��м����ź�������Ǹ��ţ�������Զ���ź�����
% ���Կ��������AF�����2D��ͨ�˲�ȥ�����ܵĸ�����֮���ٱ��WVD��Ϳ���ȥ�������ˡ�
% ��ʵ��cohen���еĲ���������f����ִ�������������

%% 6������Cohen��
clear all; close all; clc;
sig=atoms(128,[32,0.15,20,1;96,0.32,20,1]);
figure(1);tfrmh(sig);%Margenau-Hill,���Կ���������ĸ���������xy����Ľ�����������
figure(2);tfrri(sig);%Rihaczek,ͬ��
figure(3);tfrpmh(sig);%pseudo Margenau-Hill,���Կ�������������˺ܶ�
figure(4);tfrpage(sig);%Page distribution
figure(5);tfrppage(sig);%pseudo-Page distribution
M=movcw4at(128);clf; movie(M,5);%Choi-Williams distribution�ĸ�����۲�
figure(6);tfrbj(sig);%tfrzam Born-Jordan
figure(7);tfrzam(sig);%Zhao-Atlas-Marks

%% 7�������������ıȽ�
clear all; close all; clc;
N=128; 
x1=fmlin(N,0.05,0.15); x2=fmlin(N,0.2,0.5);
x=x1+x2;%�źŵ���
n=noisecg(N);%��ɫ��AWGN����
sig=sigmerge(x,n,10); %�źŵ���
% WVD����AF
tfr_wvd = tfrwv(sig);figure
subplot(122);imagesc(abs(tfr_wvd));axis xy
amf_wvd = fftshift(fft2(tfr_wvd));%ǰ��˵��AF����ʵ���Ͼ���WVD�任�Ķ�ά����Ҷ�任
amf_wvd = imrotate(amf_wvd,-90);%��֪��Ϊʲô��Ҫ��ת90�ȲŶ�
subplot(121);imagesc(abs(amf_wvd));axis xy
% �����׼���AF
tfr_spec = tfrsp(sig,1:N,N,gausswin(63));figure
subplot(122);imagesc(abs(tfr_spec));axis xy
amf_spec = fftshift(fft2(tfr_spec));%ǰ��˵��AF����ʵ���Ͼ���WVD�任�Ķ�ά����Ҷ�任
amf_spec = imrotate(amf_spec,-90);%��֪��Ϊʲô��Ҫ��ת90�ȲŶ�
subplot(121);imagesc(abs(amf_spec));axis xy
% SPWVD����AF
tfr_spwvd = tfrspwv(sig);figure
subplot(122);imagesc(abs(tfr_spwvd));axis xy
amf_spwvd = fftshift(fft2(tfr_spwvd));%ǰ��˵��AF����ʵ���Ͼ���WVD�任�Ķ�ά����Ҷ�任
amf_spwvd = imrotate(amf_spwvd,-90);%��֪��Ϊʲô��Ҫ��ת90�ȲŶ�
subplot(121);imagesc(abs(amf_spwvd));axis xy
% BJ����AF
tfr_bj = tfrbj(sig);figure
subplot(122);imagesc(abs(tfr_bj));axis xy
amf_bj = fftshift(fft2(tfr_bj));%ǰ��˵��AF����ʵ���Ͼ���WVD�任�Ķ�ά����Ҷ�任
amf_bj = imrotate(amf_bj,-90);%��֪��Ϊʲô��Ҫ��ת90�ȲŶ�
subplot(121);imagesc(abs(amf_bj));axis xy
% Choi-Williams ����AF
tfr_cw = tfrzam(sig);figure
subplot(122);imagesc(abs(tfr_cw));axis xy
amf_cw = fftshift(fft2(tfr_cw));%ǰ��˵��AF����ʵ���Ͼ���WVD�任�Ķ�ά����Ҷ�任
amf_cw = imrotate(amf_cw,-90);%��֪��Ϊʲô��Ҫ��ת90�ȲŶ�
subplot(121);imagesc(abs(amf_cw));axis xy

%% affine��
%% 1��scalogram ����Ƶ��ֵ��ƽ��Ч����ʾ
clear all; close all; clc;
sig=atoms(128,[38,0.1,32,1;96,0.35,32,1]);
figure, tfrscalo(sig);%The scalogram
% �ɼ�Ƶ��Խ��ʱ��Խ��Ƶ��Խ��ʱ��Խխ��
% ʹ��ASPWVD�鿴��ͼ��WVD���˻�
M=movsc2wv(128);
clf; movie(M,10);%���Կ�����任������ʱ��ƽ����Ƶ��ֵ�й�
%WVD����Ƶ�ֱ�����ߣ����Ǵ��ڸ��ţ���ͼ�ֱ�����ͣ����Ǽ���û�и��ţ�ASPWVDʵ����������֮������ԡ�
% �Ա���ͼ����ͼͨ��WVD�Ĺ���
M1=movsc2wv(128);%from the scalogram to the WVD
M2=movsp2wv(128);%from the spectrogram to the WVD
M=[M1,M2(end:-1:1)];%from the scalogram to the spectrogram
clf; movie(M,10);


%% 2��Bertrand distribution
clear all; close all; clc;
sig=gdpower(128);
tfrbert(sig,1:128,0.01,0.22,128,1);%Bertrand distribution
% �ñ任���нϺõ�˫��Ⱥ�ӳپֲ��������ǲ�����������Ϊֻ��Ƶ�׵�һ���֡�
sig=gdpower(128,1/2);
tfrdfla(sig,1:128,0.01,0.22,128,1);%D-Flandrin distribution
% �ñ任��Ը��ŷ��ȵ�Ⱥ��ʱ�����ֲ����Ϻá�
sig=gdpower(128,-1);
tfrunter(sig,1:128,'A',0.01,0.22,172,1);%Unterberger distributions
% �ı�����ƽ�����ȵ�Ⱥ��ʱ�����ֲ����Ϻá�

%% 3������źŷ���
clear all; close all; clc;
sig=anapulse(128);tfrwv(sig);%����źŵ�WVD����----�ɼ����ź�ʱ�������ھֲ��������Ǻܺá�
sig=altes(128,0.1,0.45);ambifuwb(sig);%���AF�任
% WAF��ģ��ƽ������ˡ�


%% 4��affine Wigner distributions�ڲ�ͬkֵ�µĸ��Žṹ��
clear all; close all; clc;
K=-15:20;%����ָ����K��Χ
for k=1:length(K)
    [t(k),f(k)]=midpoint(10,0.45,60,0.05,K(k));%���㲻ͬkֵʱ��Affine��ֲ����ĵ�
end
plot(t,f,'r.-',[10,60],[0.45,0.05],'o-');%���Ƹ��Žṹ��ԭʼ����ʱƵ��
% Ϊ����ʾ���ż��Ͻṹ���������һ��SIN��Ƶ�ź�
[sig,ifl]=fmsin(128);%����sin��Ƶ�ź�
% �ڸ���if�¹���affine Wigner�ֲ��ĸ���
figure;plotsid(1:128,ifl,0);%Bertrand distribution (k = 0) 
figure;plotsid(1:128,ifl,2);%Wigner-Ville distribution (k = 2)
figure;plotsid(1:128,ifl,-1);%Unterberger distribution(k=-1)
figure;tfrspwv(sig);%WVD����һ���źŽϺá�


%% 5����ͬ��kֵ��affine��ֲ���ʱƵ����
clear all; close all; clc;
load bat; N=128;
sig=hilbert(bat(801:7:800+N*7)').';%���������ź����ڷ���
% �Բ�ͬ��kֵ�����Ӧ��affine Wigner distribution��affine smoothed pseudo Wigner distribution
figure,tfrwv(sig);%K=2����WVD�����ڵ�Ƶ�����Ե����˸�����
figure,tfrspaw(sig,1:N,2,24,0,0.1,0.4,N,1);%K=2�����������˸�����
figure,tfrbert(sig,1:N,0.1,0.4,N,1);%k=0ʱ��pseudo Bertrand distribution������˫����ʱ�����ԶԸ��ź�չ���˷ǳ��õ�������������Ȼ���ڲ��ָ���
figure,tfrspaw(sig,1:N,0,32,0,0.1,0.4,N,1);%k=0���������������и���


%% 6��reassigned spectrogram��ʱƵ�ֲ��Ľ�
clear all; close all; clc;
N=128; 
[sig1,ifl1]=fmsin(N,0.15,0.45,100,1,0.4,-1);%SINƵ�ʵ���
[sig2,ifl2]=fmhyp(N,[1 .5],[32 0.05]);%˫��Ƶ�ʵ���
sig=sig1+sig2;
tfrideal([ifl1 ifl2]);%����Ƶ����Ϣ����������TF�ֲ�
figure; tfrrsp(sig);%����reassigned spectrogram
% һ��֤��reassignment���ƣ���ǿʱƵ�ֲ��ľֲ������ԣ��Ĳ���
[sig1,ifl1]=fmsin(60,0.15,0.35,50,1,0.35,1);
[sig2,ifl2]=fmlin(60,0.3,0.1);
[sig3,ifl3]=fmconst(60,0.4);
sig=[sig1;zeros(8,1);sig2+sig3];%�ź����
iflaw=zeros(128,2);
iflaw(:,1)=[ifl1;NaN*ones(8,1);ifl2];
iflaw(:,2)=[NaN*ones(68,1);ifl3];%Ƶ�����
tfrideal(iflaw);%�����ź�ʱƵ�ֲ�
figure; tfrwv(sig);%�źŵ�WVD�ֲ����ź��Ǿֲ����ܺã����Ǻཻܶ������ʱƵ�ֲ����Ѷ���
figure;tfrrpwv(sig);%PWVD��ʱ����ȥ���˽����������Ȼ���ڽ��������reassigned���ǿ��õ�������
figure; tfrrspwv(sig);%  SPWVD and its reassigned version,���ܷǳ���
%�ɼ�SPWVDȷʵͨ��ƽ��ȥ���˺ཻܶ������Ƿֱ��ʱ������˺ܶࡣͨ��reassigned��ֱ����ٴ���ߡ�
%%����֮reassigned�ĺô����ǽ����е�TF�ֲ�������ֲ�����������������ֲ���
figure;tfrrsp(sig);%�����׼���reassigned----���ܽϺã��޸����
figure;tfrrmsc(sig);%Morlet scalogram����reassigned----���ܽϲҲû�и�������ڵ�Ƶ���ֵ�ʱ��ֱ������ز��㣩
figure;tfrrppag(sig);%pseudo-Page�����ڸ�����ĵ��ӵ������ܺܲ����ʰȡ����
figure;tfrrpmh(sig);%pseudo Margenau-Hill�����ڸ�����ĵ��ӵ������ܺܲ����ʰȡ����
%�ܽ����������ǡ�ʹ��spectrogram or the SPWVD���ܱȽϺá�

%% 7������ʱƵ��ȡ����
clear all; close all; clc;
[sig1,ifl1]=fmsin(60,0.15,0.35,50,1,0.35,1);
[sig2,ifl2]=fmlin(60,0.3,0.1);
[sig3,ifl3]=fmconst(60,0.4);
sig=[sig1;zeros(8,1);sig2+sig3];%�ź����
t=1:2:127; [tfr,rtfr,hat]=tfrrpwv(sig,t);
figure;friedman(tfr,hat,t,'tfrrpwv',1);%ʱƵ�ֲ������ԽϺ�
[tfr,rtfr,hat]=tfrrsp(sig);
figure;ridges(tfr,hat);%�Ǽܺͱ�Ե��ȡ
