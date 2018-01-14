%% ԭ��������ͼ�����




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
Gt = G/max(G(:));
[xt,yf]=meshgrid(a,f);             %��ȡ����������
surf(xt',yf',10*log10(1+Gt));               
colormap('Autumn');     %��ɫģʽ
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
% set_gca_style([8,6]); box off; colormap('hot');


%% �޽���LFM+SFM�źŵ�ʱ���˲�
clear all; clc; close all
Fs = 100;N=256; 
t = (0:(N-1))/Fs; f = linspace(-Fs/2,Fs/2,N);
[s1, sif1] = fmlin(N,0.1,0.2,120);
[s2, sif2] = fmsin(N,0.25,0.45,N+50);
s_org = s1+s2;%�źŵ���
s = awgn(s_org,0,'measured');%��5dB������SNR�ܸ�ʱ������źż��������غϡ�

%%%%%%%  STFT TVF
% [sh1,tfr,tfrv1] = stftSeparation(s,[sif1,sif2],20);%�̶������ȵ�ʱ���˲�
[sh2,tfr,tfrv2] = stftSeparationAdv(s,[sif1,sif2],20);%����Ӧ�����ȵ�ʱ���˲�
figure('Name','STFT');imagesc(abs(tfr)); set_gca_style([4,4],'img');
figure('Name','STFT-ada-window-sig1');imagesc(abs(tfrv2(:,:,1))); set_gca_style([4,4],'img');
figure('Name','STFT-ada-window-sig2');imagesc(abs(tfrv2(:,:,2))); set_gca_style([4,4],'img');

figure('Name','sigmix-time');plot(t,real(s),'k-'); 
% h = legend('${s_1(t)+s_2(t)}$','${s(t)}$'); set(h,'Interpreter','latex')
xlabel('t/\mus'),ylabel('A/V');set_gca_style([16,4]);%xlim([t(1),t(128)]);%axis([t(1),t(128),-2.2,7])%�鿴��Եֵ
figure('Name','sig1-time');plot(t,real(s1),'k-',t,real(sh2(:,1)),'b--'); 
% h=legend('$s_1(t)$','$ \tilde s_1(t)$');set(h,'Interpreter','latex')
xlabel('t/\mus'),ylabel('A/V');set_gca_style([8,4]);%xlim([t(1),t(end)])%�鿴��Եֵ
figure('Name','sig2-time');plot(t,real(s2),'k-',t,real(sh2(:,2)),'b--'); 
% h=legend('$s_2(t)$','$ \tilde s_2(t)$');set(h,'Interpreter','latex')
xlabel('t/\mus'),ylabel('A/V');set_gca_style([8,4]);%xlim([t(1),t(enf)])%�鿴��Եֵ


%%%%%%% STFRFT TVF
% [sh1,tfr,tfrv1] = stfrftSeparation(s,[sif1,sif2],8);%����Ӧ�����ȵ�ʱ���˲�
[sh2,tfr,tfrv2] = stfrftSeparationAdv(s,[sif1,sif2],8);%����Ӧ�����ȵ�ʱ���˲�--FRFT���������У������Ҫ�Ŀ�ȸ�С
figure('Name','STFRFT-sig1');imagesc(abs(tfr(:,:,1))); set_gca_style([4,4],'img');
figure('Name','STFRFT-sig2');imagesc(abs(tfr(:,:,2))); set_gca_style([4,4],'img');
figure('Name','STFRFT-ada-window-sig1');imagesc(abs(tfrv2(:,:,1))); set_gca_style([4,4],'img');
figure('Name','STFRFT-ada-window-sig2');imagesc(abs(tfrv2(:,:,2))); set_gca_style([4,4],'img');

figure('Name','sig1-time');plot(t,real(s1),'k-',t,real(sh2(:,1)),'b--'); 
xlabel('t/\mus'),ylabel('A/V');set_gca_style([8,4]);grid off;
figure('Name','sig2-time');plot(t,real(s2),'k-',t,real(sh2(:,2)),'b--'); 
xlabel('t/\mus'),ylabel('A/V');set_gca_style([8,4]);grid off;









