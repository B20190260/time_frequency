%% ���ĵڶ���ʾ��ͼ��
% ע��ͼ�񱣴�ߴ糣�ã��ֺŶ�ѡ��10.5pt��
% MATLAB���óߴ�->WORD�����ߴ�
% 6*4->6*4
% 6*6->5*5
% 8*6->5*6.67

%% LFM�źŵ�ʱ���Ƶ������ʾ��ͼ2-2
clear,clc,close all;
N=512;%��������
fs = 200e6;%100M
FNORMI = 0.1e6/fs;%��ʼƵ��->����ڲ���Ƶ�ʣ�between -0.5 and 0.5
FNORMF = 100e6/fs;%����Ƶ��->����ڲ���Ƶ�ʣ�between -0.5 and 0.5
t = (1:N)/fs;
T0 = N/2;%time reference for the phase,��λ�Ĳο�ʱ�䣿
[Y,IFLAW]=fmlin(N,FNORMI,FNORMF,T0);
figure('Name','LFM�źŵ�ʱ��'),plot(t,real(Y));axis tight;%CHIRP�ź�
xlabel('t/s');
Y_W=abs(fftshift(abs(fft(Y)).^2));%
Y_W = Y_W/max(Y_W);
f = linspace(-0.5*fs,0.5*fs,N);
figure('Name','LFM�źŵ�Ƶ��'),plot(f,abs(Y_W));axis tight;%Ƶ��
xlabel('f/Hz');%��һ��Ƶ��
pause


%% LFM�źŵ�FRFT�任��ͼ2-4
clear,clc,close all;
N=512;%��������
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
    T=frft(s,a(l));         %�����׸���Ҷ�任
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
fprintf('��������Ƶб��=%f�� ����Ƶ��Ϊ=%f \n',(fend-f0)/N,(f0+fend)/2);
fprintf('���ƣ���Ƶб��=%f�� ����Ƶ��Ϊ=%f \n',kr,f_center);
pause


%% SFM�źŵ�ʱ���Ƶ������ʾ��ͼ2-6
clear,clc,close all;
N=512;%��������
fs = 200e6;%100M
t = (1:N)/fs;
FNORMI = 0.1e6/fs;%��СƵ��
FNORMAX = 100e6/fs;%���Ƶ��
[Y,IFLAW]=fmsin(N,FNORMI,FNORMAX);
figure('Name','SFM�źŵ�ʱ��'),plot(t,real(Y));axis tight;%CHIRP�ź�
xlabel('t/s');
Y_W=abs(fftshift(abs(fft(Y)).^2));%
Y_W = Y_W/max(Y_W);
f = linspace(-0.5*fs,0.5*fs,N);
figure('Name','LFM�źŵ�Ƶ��'),plot(f,abs(Y_W));axis tight;%Ƶ��
xlabel('f/Hz');%��һ��Ƶ��
pause



%% SFM�źŵ�SFMT�任����δʵ�ּ���



%% TFR��ȡ�ĶԱȣ�ͼ2-7
clear all; close all; clc;
N=512;%��������
t=1:N;
f=linspace(0,0.5,N);
[sig,IF]=fmlin(N,0,0.5);
figure,tfr_sp = tfrsp(sig); imagesc(t,f,tfr_sp(1:N/2,:));axis xy; xlabel('t/s'); ylabel('w');colormap('hot')
figure,tfr_wv = tfrwv(sig); tfr_wv(tfr_wv<0)=0;
imagesc(t,f,tfr_wv);axis xy; xlabel('t/s'); ylabel('w');colormap('hot')
figure,tfr_spwv = tfrspwv(sig); tfr_spwv(tfr_spwv<0)=0;
imagesc(t,f,tfr_spwv);axis xy; xlabel('t/s'); ylabel('w');colormap('hot')
pause


%% TFR��ȡ�ĶԱȣ�ͼ2-8��2-10����
clear all; close all; clc;
N=512;%��������
t=1:N;
f=linspace(0,0.5,N);
sig=fmlin(N,0,0.3)+fmlin(N,0.2,0.5);
figure,tfr_sp = tfrsp(sig); imagesc(t,f,tfr_sp(1:N/2,:));axis xy; xlabel('t/s'); ylabel('w');colormap('hot')
figure,tfr_wv = tfrwv(sig); tfr_wv=abs(tfr_wv);
imagesc(t,f,tfr_wv);axis xy; xlabel('t/s'); ylabel('w');colormap('hot')
[tfr_spwv,tfr_rspwv] = tfrrspwv(sig); tfr_rspwv = abs(tfr_rspwv); tfr_spwv = abs(tfr_spwv);
figure,imagesc(t,f,tfr_spwv);axis xy; xlabel('t/s'); ylabel('w');colormap('hot')
figure,imagesc(t,f,tfr_rspwv);axis xy; xlabel('t/s'); ylabel('w');colormap('hot')

%% TFR��ȡ�ĶԱȣ�ͼ2-9��2-10����
sig=fmlin(N,0,0.25)+fmsin(N,0.25,0.45);
figure,tfr_sp = tfrsp(sig); imagesc(t,f,tfr_sp(1:N/2,:));axis xy; xlabel('t/s'); ylabel('w');colormap('hot')
figure,tfr_wv = tfrwv(sig); tfr_wv=abs(tfr_wv);
imagesc(t,f,tfr_wv);axis xy; xlabel('t/s'); ylabel('w');colormap('hot')
[tfr_spwv,tfr_rspwv] = tfrrspwv(sig); tfr_rspwv = abs(tfr_rspwv); tfr_spwv = abs(tfr_spwv);
figure,imagesc(t,f,tfr_spwv);axis xy; xlabel('t/s'); ylabel('w');colormap('hot')
figure,imagesc(t,f,tfr_rspwv);axis xy; xlabel('t/s'); ylabel('w');colormap('hot')
pause



%% RSPWVD��ͼ����TFR��ֵ��+������+�źŻָ���ͼ2-11��13
clear all; close all; clc;
N=512;%��������
t=1:N;  f=linspace(0,0.5,N);
T0 = 1;%��ʵ�ο���λλ��
[sig1,if1] = fmlin(N,0,0.3,T0);
[sig2,if2] = fmlin(N,0.2,0.5,T0);
sig = sig1+sig2;
[~,tfr] = tfrrspwv(sig); tfr = abs(tfr);%��ȡ�����TFR
% ��ֵ��
tfr_nor = tfr/max(tfr(:));%��һ��TFR
hresh = graythresh(tfr_nor);%����Ӧѡ����ֵ
tfr_bin = tfr_nor>hresh;%��ֵ��
imshow(tfr_bin); axis xy;hold on
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
    xy = [lines(k).point1; lines(k).point2];    plot(xy(:,1),xy(:,2),'g');%��ͼ
    IFLAW{k} = (t-x1(1))*(x2(2) - x1(2))/(x2(1)-x1(1))+x1(2);%�����źŷ�����˲ʱƵ�ʺ���
    if_temp = IFLAW{k};%������IF����
    if_temp(if_temp>0.5) = 0.5;%��ֹ���������ͻ
    sig_each{k} = fmodany(if_temp',T0);%�����ź�
end
%�ָ��źŶԱȣ�ʱ��
figure; plot(t,real(sig1),'b-',t,real(sig_each{1}),'r.');legend('ԭʼ�ź�','�����ź�');axis tight;xlabel('t/s');
figure; plot(t,real(sig2),'b-',t,real(sig_each{2}),'r.');legend('ԭʼ�ź�','�����ź�');axis tight;xlabel('t/s');
figure;plot(t,real(sig),'k.-'); axis tight; xlabel('t/s');
%�ָ��źŶԱȣ�IF
figure;
h1=axes('position',[0.1 0.08 0.88 0.88]); box on; 
h2=axes('position',[0.15 0.6 0.4 0.32]); box on;
plot(h1,t,if1,'b.-',t,IFLAW{1},'o-r'); legend(h1,'ԭʼ�ź�','�����ź�'); axis tight;
plot(h2,t(1:10),if1(1:10),'b.-',t(1:10),IFLAW{1}(1:10),'o-r');axis tight;xlabel(h1,'t/s');ylabel(h1,'f/Hz');
pause


%% �źŵ�ϡ��ֽ��ع���OMP�㷨��FRFTϡ����ع�
clc;clear all; close all;
N=512;%��������
t=1:N;
f=linspace(0,0.5,N);
T0 = N/2;%��ʵ�ο���λλ��
[sig1,if1] = fmlin(N,0,0.3,T0);
[sig2,if2] = fmlin(N,0.2,0.5,T0);
k=0.3/N;%LFMб��
p = mod(2/pi*acot(-k*N),2);% FRFT��������һ��0-2֮��
x = sig1+sig2;

% ����������
bais=eye(N,N);
Psi = zeros(size(bais));
for k = 1:N
    Psi(:,k) = frft(bais(:,k),p)*sqrt(N);%�Ը��л���FRFT�任
end

% OMP�ع�
T=Psi';           %  �ָ�����(��������*�������任����)��y=�ָ�����*s������yΪ�۲����ݣ�sΪϡ���ʾϵ��
[hat_y1,r_n] = omp(x,T,N,1);%OMP�㷨�ع���1������
hat_s1=Psi'*hat_y1.';                         %  ���渵��Ҷ�任�ع��õ�ʱ���ź�
[hat_y2,r_n] = omp(r_n,T,N,1);%OMP�㷨�ع���2������
hat_s2=Psi'*hat_y2.';                         %  ���渵��Ҷ�任�ع��õ�ʱ���ź�

% �ع��źź�ԭʼ�źŶԱ�
figure('Name','��һ������');
plot(t,real(sig1),'.-b');hold on              %  ԭʼ�ź�
plot(t,real(hat_s1),'o-r')                 %  �ؽ��ź�
legend('ԭʼ�ź�','�ع��ź�'),axis tight;xlabel('t/s');

figure('Name','�ڶ�������');
plot(t,real(sig2),'.-b');hold on              %  ԭʼ�ź�
plot(t,real(hat_s2),'o-r')                 %  �ؽ��ź�
legend('ԭʼ�ź�','�ع��ź�'),axis tight;xlabel('t/s');
%������
fprintf('����1�ع�MSE = %8f\n',norm(hat_s1 - sig1, 'fro'))
fprintf('����2�ع�MSE = %8f\n',norm(hat_s2 - sig2, 'fro'))

figure('Name','FRFT��OMP���Ա�')
plot(f,abs(frft(x,p)),'b.-'),axis tight;hold on
plot(f,abs((hat_y1+hat_y2)*sqrt(N)),'o-r');xlabel('w');
legend('ԭʼ�ź�FRFT��','OMP�㷨����ԭ��');
pause












