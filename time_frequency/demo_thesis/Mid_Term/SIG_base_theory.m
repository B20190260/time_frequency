% ����Ƶ��100MHz������1V
% ���ű��ļ��������С�ʱƵ���������½ڡ����ͼ�����ɵ���䣬
% ĳЩ��������̫ռ�ռ��װ�����������ˣ�����鿴��ע�͡�


%% �����źŵ�Ƶ������ʾ��
clear all; close all; clc; 
Fs = 100;N=128; %��λ��ӦMHz, us
t = (0:(N-1))/Fs; f = linspace(-Fs/2,Fs/2,N);
s = real(fmconst(N,0.07,1) + fmconst(N,0.22,1));%7M+22M COS�źŵ���
sF = abs(fftshift(fft(s)));sF = sF/max(sF);
sa = hilbert(s);%�����ź�
saF = abs(fftshift(fft(sa)));saF = saF/max(saF);
%���������źż���Ƶ��
figure;plot(t,s,'k-'); xlabel('ʱ��/\mus');ylabel('����/V');
set_gca_style([7,4]);
figure;plot(f,sF,'k-'); xlabel('Ƶ��/MHz');ylabel('��һ������');
set_gca_style([7,4]);
%���ƽ����źż���Ƶ��
figure;plot(t,real(sa),'b^-','LineWidth',1.3,'MarkerSize',3);hold on; 
plot(t,imag(sa),'k-.','LineWidth',0.7); xlabel('ʱ��/\mus');ylabel('����/V');legend('ʵ��','�鲿');
set_gca_style([7,4]);
figure;plot(f,saF,'k-'); xlabel('Ƶ��/MHz');ylabel('��һ������');
set_gca_style([7,4]);


pause
%% LFM�źż���Ƶ��
clear all; close all; clc; 
Fs = 100;N=512; %��λ��ӦMHz, us
t = (0:(N-1))/Fs; f = linspace(-Fs/2,Fs/2,N);
[Y,IFLAW]=fmlin(N,0.00001,0.5);
figure('Name','LFM�źŵ�ʱ��'),plot(t,real(Y));%CHIRP�ź�
xlabel('ʱ��/\mus');ylabel('����/V');set_gca_style([7,4]);

Y_W=abs(fftshift(abs(fft(Y)).^2));%
Y_W = Y_W/max(Y_W);
figure('Name','LFM�źŵ�Ƶ��'),plot(f,abs(Y_W));%Ƶ��
xlabel('Ƶ��/MHz');ylabel('��һ������');set_gca_style([7,4]);


pause
%% LFM��FRFT�����ѹ���չʾ
clear,clc,close all;
N=128;      %��������
r=0.05;     %��������������ʵ�ʷ���ʱԽСԽ��ȷ
fs =1;  %����Ƶ��
f0 = 0;  fend = 0.5;
s = fmlin(N,f0,fend,1);
t = 1:N;
f = linspace(-0.5,0.5,N);%Ƶ�ʵ㡾���������������ģ�fmlinֱ�ӷ��ص�f����ȷ��
% ��ͬ�����µ�FRFT�任
a=0:r:2;    %FRFT�������ο�����2.1
G=zeros(length(a),length(s));	%��ͬ�����ı任�������
f_opt=0;        %��¼���Ƶ��
for l=1:length(a)
    T=frft_org(s,a(l));         %�����׸���Ҷ�任
    G(l,:)=abs(T(:));       %ȡ�任��ķ���
  if(f_opt<=max(abs(T(:))))     
    [f_opt,f_ind]=max(abs(T(:)));       %��ǰ�����ڵ�ǰ��ĺ������
    a_opt=a(l);                %��ǰ���ֵ��Ľ���a
  end
end
%������άͼ��
[xt,yf]=meshgrid(a,f);             %��ȡ����������
surf(xt',yf',G);               % colormap('Autumn');     %��ɫģʽ
xlabel('p');ylabel('u');%uΪ��p�����µĵ�ЧƵ��
axis tight; grid on;
%�����Ƶб��
nor_coef=(t(N)-t(1))/fs;      %���ݲ����ʼ����һ�����ӣ�ע�������ϵ�б����������Ƶ��Ϊ��λ�ģ���˹�ʽ����ȫһ��
kr=-cot(a_opt*pi/2)/nor_coef;   %k�����Ĺ���ֵ������alpha=pi*a/2
%������ʼƵ��
u0=f(f_ind);      %�����Ӧ�ĵ�ЧƵ��
f_center=u0*csc(a_opt*pi/2);  % ����Ƶ��f0�Ĺ���ֵ
fprintf('��������Ƶб��=%f�� ����Ƶ��Ϊ=%f \n',(fend-f0)/N*fs,(f0+fend)/2);
fprintf('���ƣ���Ƶб��=%f�� ����Ƶ��Ϊ=%f \n',kr,f_center);
% tfsapl(s,G,'GrayScale','on','xlabel','p','ylabel','u');%Ч��Ҳ����


pause
%% SFM�źż���Ƶ��
clear,clc,close all;
Fs = 100;N=512; %��λ��ӦMHz, us
t = (0:(N-1))/Fs; f = linspace(-Fs/2,Fs/2,N);
[Y,IFLAW]=fmsin(N,0.0001,0.5);
figure('Name','SFM�źŵ�ʱ��'),plot(t,real(Y));%CHIRP�ź�
xlabel('ʱ��/\mus');ylabel('����/V');set_gca_style([7,4]);

Y_W=abs(fftshift(abs(fft(Y)).^2));%
Y_W = Y_W/max(Y_W);
figure('Name','SFM�źŵ�Ƶ��'),plot(f,abs(Y_W));%Ƶ��
xlabel('Ƶ��/MHz');ylabel('��һ������');set_gca_style([7,4]);


pause
%% SFM�źŵ�SFMT�任
clear all; clc; close all;
N = 128; k0 = 2;l0 = 16;%�źŲ���
t = [0:N-1]';
s = exp(1i*l0/k0*sin(2*pi*k0*t/N));%plot(t,real(s),'.-') %��ʽ5����֪k0��l0ʱ�ָ�ԭʼ�źŵķ���
[X,s_hat] = sfmt(s);
surf(abs(X));xlabel('k');ylabel('l');axis tight; grid on;
colormap('hot');%shading interp






