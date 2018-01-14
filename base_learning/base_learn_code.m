%% ����TFTB������ѧϰ
% ѧϰ����ע��
% ����֮����imagesc ����ָ�������������ͼ��

%% 1������ʹ��
% ���Ե�Ƶ�źŵĲ����ͷ���
clear,clc,close all;
N=512;%��������
FNORMI = 0;%��ʼƵ��->����ڲ���Ƶ�ʣ�between -0.5 and 0.5
FNORMF = 0.5;%����Ƶ��->����ڲ���Ƶ�ʣ�between -0.5 and 0.5
T0 = N/2;%time reference for the phase,��λ�Ĳο�ʱ�䣿
[Y,IFLAW]=fmlin(N,FNORMI,FNORMF,T0);
figure('Name','CHIRP�źŵ�ʱƵͼ��')
subplot(211),plot(real(Y));axis tight;%CHIRP�ź�
Y_W=fftshift(abs(fft(Y)).^2);%
subplot(212),plot(linspace(-0.5,0.5,N),abs(Y_W));axis tight;%Ƶ��
figure('Name','CHIRP�źŵ�Wigner-Ville�ֲ�')
TF_dis = tfrwv(Y);%WV��
imshow(TF_dis,[]);colormap('hot');axis xy on;%ȱ�ݣ�ʹ��imshow�޷�ָ����������ֵ������ʹ��surf��
xlabel('t/s'),ylabel('f/Hz');
% �����������źŷ���
Y_n=sigmerge(Y,noisecg(N),0);%0db
figure('Name','CHIRP+�����źŵ�ʱƵͼ��')
subplot(211),plot(real(Y_n));axis tight;%CHIRP�ź�
Y_n_W=fftshift(abs(fft(Y_n)).^2);%
subplot(212),plot(linspace(-0.5,0.5,N),abs(Y_n_W));axis tight;%Ƶ��
figure('Name','CHIRP+�����źŵ�Wigner-Ville�ֲ�')
TF_dis = tfrwv(Y_n);%WV��
imshow(TF_dis,[]);colormap('hot');axis xy on;%ȱ�ݣ�ʹ��imshow�޷�ָ����������ֵ������ʹ��surf��
xlabel('t/s'),ylabel('f/Hz');

%% 2�������źŵĴ���
clear,clc,close all;
load bat%������Ϊ230.4khz
N=length(bat);
t=linspace(0,N/2304,N);
plot(t,bat); xlabel('Time [ms]');
TF_dis = tfrpwv(bat);axis xy%���������֧������t�������������
% tfrpwvЧ����tfrwv�Ϻ�
imagesc(abs(TF_dis));axis xy

%% 3��˲���źŵļ��
clear,clc,close all;
N_l=128;N_r=100;
N=N_l+2*N_r;
trans=amexpo1s(N_l).*fmconst(N_l);%����exp����˥����Ƶ�ʹ̶�
sig=[zeros(N_r,1) ; trans ; zeros(N_r,1)];
sign=sigmerge(sig,noisecg(N),-5);
figure('Name','ԭʼ�źŵ�ʱƵ����')
subplot(211),plot(real(sign));
dsp=fftshift(abs(fft(sign)).^2);
subplot(212),plot(linspace(-0.5,0.5,N),dsp);
figure('Name','ʱƵ�ֲ�ͼ��')
TF_dis = tfrsp(sign);%�����ڼ������Ƶ��˲���ź�
imagesc(abs(TF_dis));axis xy


%% 4��ʱƵ�ֲ���������Heisenberg-Gabor��ƽ��----��֤
clear,clc,close all;
N=256;
sig=fmlin(N).*amgauss(N);%AM��˹���ƣ�fm���Ե��Ƶ��ź�
[tm,T]=loctime(sig);%ʱ��ֲ�������
[num,B]=locfreq(sig);%Ƶ�ʾֲ�������
[T,B,T*B]
%����������T*B>1�Ľ��ۣ�����Heisenberg-Gabor inequality����
sig=amgauss(N);%��˹�źŵ�ʱƵ��T*B=1
[tm,T]=loctime(sig);
[fm,B]=locfreq(sig);
[T,B,T*B]

%% 5��˲ʱƵ�ʡ����ȡ�Ⱥ��ʱ
clear,clc,close all;
N=256;
sig=fmlin(N);%���Ե�Ƶ�ź�
t=(3:N);ifr=instfreq(sig);%����˲ʱƵ��----ϣ�����ر任
subplot(211),plot(t,ifr);axis tight
fnorm=0:.05:.5;
gd=sgrpdlay(sig,fnorm);%����Ⱥ��ʱ
subplot(212),plot(gd,fnorm);axis tight
%ֻ�е�T*B�ܴ�ʱȺ��ʱ�Ż��˲ʱƵ����ͬ
t=2:255;
sig1=amgauss(256,128,90).*fmlin(256,0,0.5);
[~,T1]=loctime(sig1); [~,B1]=locfreq(sig1);
T1*B1 %---> T1*B1=15.9138
ifr1=instfreq(sig1,t); f1=linspace(0,0.5-1/256,256);
gd1=sgrpdlay(sig1,f1);
subplot(211),plot(t,ifr1,'*',gd1,f1,'-');axis tight
sig2=amgauss(256,128,30).*fmlin(256,0.2,0.4);
[tm,T2]=loctime(sig2); [fm,B2]=locfreq(sig2);
T2*B2 %---> T2*B2=1.224
ifr2=instfreq(sig2,t); f2=linspace(0.2,0.4,256);
gd2=sgrpdlay(sig2,f2); 
subplot(212),plot(t,ifr2,'*',gd2,f2,'-');axis tight

%% 6����ƽ���źŵĲ���
clear,clc,close all;
fm1=fmlin(256,0,0.5);%LFM�ź�
am1=amgauss(256,200);%ָ����˹�������ĵ�200
sig1=am1.*fm1;
subplot(311),plot(real(sig1));axis tight
fm2=fmconst(256,0.2);%��Ƶ�ź�
am2=amexpo1s(256,100);%ָ��ָ��˥��������ʼ��Ϊ100
sig2=am2.*fm2; 
subplot(312),plot(real(sig2));axis tight
[fm3,am3]=doppler(256,200,4000/60,10,50);%�������ź�--��matlab�Դ�����
% ����Ƶ��200Hz��Ŀ��Ƶ��Ϊ4000/60Hz���۲��ߺ�Ŀ�����10m��Ŀ����50m/s���ٶȿ���
sig3=am3.*fm3; 
subplot(313),plot(real(sig3));axis tight
noise=noisecg(256,.8);%��ɫ����----AWGN�����˲�����Ľ��
sign=sigmerge(sig1,noise,-10); %�źŵ���
subplot(311),hold on; plot(real(sign),'r');


%% 7����ƽ���źŵĵ���----����ַ�ƽ���ź�
clear,clc,close all;
N=128; 
x1=fmlin(N,0.5,0.3); x2=fmlin(N,0.1,0.5);
x=x1+x2;%�źŵ���
ifr=instfreq(x); %˲ʱƵ��
subplot(211); plot(ifr);axis tight;
fn=0:0.01:0.5; 
gd=sgrpdlay(x,fn);%Ⱥ��ʱ
subplot(212); plot(fn,gd);axis tight;
TF = tfrstft(x);%��ʱ����Ҷ�任��
% tfrstft(x);����ʹ��ʱ�������ӻ��ƹ����׵�����
figure,imagesc(abs(TF));axis xy




