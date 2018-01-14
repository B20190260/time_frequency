%% ����У��STFRFT��������ȷ��

%% 1��LFM�źŵ�FRFT�׷�ֵ��ԭʼ�źŵ�����Ƶ�ʹ�ϵ
clear all; clc, close all;
N=256;  t = 1:N;    %��������
fs =1;  f0 = 0.5;  fend = -0.1;%����Ƶ��
[s_org,iflaw] = fmlin(N,f0,fend,1);
s = awgn(s_org,50,'measured');
% ��������׵���ѽǶ�
% kgen = diff(iflaw);kgen = [kgen(1);kgen];% IF�ĵ�����б��k
% popt = -acot(kgen*N)*2/pi; %����������FRFT����
%-------------------------------------------------
% ����Ƶ�������ӦFRFT�����ֵ���꣺ʵ�ʲ��Խ��
% fc��ִ���������֮ǰ����Ҫһ��У����������Ȼ����̫��ʱ�������̫�󣡺���ת�Ƕ�Ӧ����أ�
% fc_o = iflaw(N/2)*N; %����Ƶ��
% fc = fc_o * abs(sin(popt(1)*pi/2));
% if fc >= 0 && kgen(N/2)>0; uc = N - fc + 1; 
% elseif fc >= 0 && kgen(N/2)<0; uc = fc - 1;
% elseif fc < 0 && kgen(N/2)<0; uc = N + fc -1;
% elseif fc <0 && kgen(N/2)>0; uc = -fc- 1;
% else uc = - fc; end %����Ƶ�ʶ�ӦFRFT�����Ƶ��
%-------------------------------------------------
% uc = mod(fc_o * sin(popt(1)*pi/2),N);%��ӳ�乫ʽ��
% %����Ƶ�ʵ����Ƶ�ʵ�ӳ���ϵ��ʵ��fc_o * sin(popt(1)*pi/2)����һ����0-N֮�伴��
% p = popt(1);frt = frft(s,p);
% [~,uc_hat] = max(abs(frt));
% [fc_o,uc,uc_hat]
%-------------------------------------------------
%-----------------------------------------------------------
% �Ա�FFT��FTFR1�Ĳ��첢��֤FRFT��������ȷ��
% p = popt(1);plot(t,abs(fft(s)),'b.-',t,abs(frt),'ro-');legend('fft',['frft p=',num2str(p)])
% ȷ��FRFT����ת����������ȷ����֤����
% r=0.01;     %��������������ʵ�ʷ���ʱԽСԽ��ȷ
% for a = 0:r:4
%     T=frft(s,a);         %�����׸���Ҷ�任
%     plot(abs(T));title(['a = ',num2str(a)]);
%     if a == 0; pause; else pause(0.02); end
% end
%-----------------------------------------------------------

fLen = N;
[fc,uc,popt] = fftIflaw2frftIflaw(iflaw,fLen);
tfr1 = tfrStft(s,N);% % ����STFT��
[tfr2,uc] = tfrStfrft(s,iflaw,N);% ���������ת�Ƕȵķ�������
[tfr3,ucf] = stfrftShift(tfr2,fc,uc);% ����õ�STFRFTƵ��У����STFTƵ��λ�ã��Է��������˲ʱƵ��

subplot(131); imagesc(abs(tfr1)); axis xy; title('STFT');
subplot(132); imagesc(abs(tfr2)); axis xy; title('STFRFT');
subplot(133); imagesc(abs(tfr3)); axis xy; title('STFRFT shift');

% �������ʱ�̵��FRFT��Ƶ��
subplot(131); hold on;plot(t,mod(fc,N),'w.--');
subplot(132); hold on;plot(t,mod(uc,N),'w.--');
subplot(133); hold on;plot(t,mod(ucf,N),'w.--');

pause
%% 2������SFM�źŵ�FRFT��
clear all; clc, close all;
N=256;  t = 1:N;    %��������
[s_org,iflaw] = fmsin(N,0.1,0.45,200,1,0.2);
s = awgn(s_org,50,'measured');

fLen = 256;%���Է���Ƶ�������Խ�࣬STFRFT�ֱ���Խ�ߣ�
[fc,uc,popt] = fftIflaw2frftIflaw(iflaw,fLen);
tfr1 = tfrStft(s,fLen,tftb_window(31));% ����STFT��
[tfr2,uc] = tfrStfrft(s,iflaw,fLen,tftb_window(51));% ���������ת�Ƕȵķ�������
[tfr3,uc] = stfrftShift(tfr2,fc,uc);% ����õ�STFRFTƵ��У����STFTƵ��λ�ã��Է��������˲ʱƵ��

subplot(121); imagesc(abs(tfr1)); axis xy;title('STFT');
% subplot(122); imagesc(abs(tfr2)); axis xy;
subplot(122); imagesc(abs(tfr3)); axis xy;title('STFRFT shift');

% �������ʱ�̵��FRFT��Ƶ��
subplot(121); hold on;plot(t,mod(fc,fLen),'w.--');
subplot(122); hold on;plot(t,mod(uc,fLen),'w.--');

% figure;plot(t,mod(fc,fLen),'bo-',t,mod(uc,fLen),'ro-',t,popt>0,'x-');

pause
%% 3�����ӷ�����STFRFT����
clear all; clc, close all;
N=256;  t = 1:N;    %��������
[s1,iflaw1] = fmsin(N,-0.1,0.25,150,1,0.1);
[s2,iflaw2] = fmlin(N,0.1,0.4,1);
s_org = s1+s2;
s = awgn(s_org,50,'measured');

[fc,uc,popt] = fftIflaw2frftIflaw(iflaw1,N);
tfr1 = tfrStft(s,N,tftb_window(51));% ����STFT��
[tfr2,uc] = tfrStfrft(s,iflaw1,N,tftb_window(51));% ���������ת�Ƕȵķ�������
[tfr3,uc] = stfrftShift(tfr2,fc,uc);% ����õ�STFRFTƵ��У����STFTƵ��λ�ã��Է��������˲ʱƵ��

subplot(121); imagesc(abs(tfr1)); axis xy;title('STFT');
subplot(122); imagesc(abs(tfr3)); axis xy;title('STFRFT shift');

% �������ʱ�̵��FRFT��Ƶ��
subplot(121); hold on;plot(t,mod(fc,N),'w.--');
subplot(122); hold on;plot(t,mod(uc,N),'w.--');
% ����ѡ���Ե���ǿĳЩ����������������ǿ��SFM�źŷ�����



%% 4��FRFT�Ŀ�������֤
clear all; clc, close all;
N=64;  t = 1:N;    %����������ԽСƵ������Խ�죬���Ǳ�Ե���������ռ�ı���������ͬ��
[s_org,iflaw] = fmlin(N,0.45,-0.45,1);%������ʼ�ͽ���Ƶ�ʿ��Է�������Խ��ָ�����Խ��
s = awgn(s_org,10,'measured');%����Ϊ0dBʱҲ���ԽϺõĻָ��м䲿�ֵ��ź�ֵ
kgen = diff(iflaw);kgen = [kgen(1);kgen];% IF�ĵ�����б��k
popt = -acot(kgen*N)*2/pi; %����������FRFT����
p = popt(1);%��������Χ��popt(1)�仯���ֲ�Խ��ָ����źŲ���Խ��
frt = frft(s,p);%plot(abs(frt))
frt(abs(frt)<max(abs(frt))*0.2) = 0; %ģ��ȥ������������ֵ���������
sh = ifrft(frt,p);
plot(t,real(s_org),'b.-',t,real(s),'g-',t,real(sh),'rx-'); legend('orignal','noised','transformed');axis tight
%-----------------------------------------------------------
% ��-���任�ָ��ź�ʱ���ڵ����⣺��Ե�״�Ƶ������̫��Ҳ������������ò��Ի����
% ������ɢ�㷨���µ���ֻ�ܽ�������FRFT������
% ����ʵ��Ӧ��ʱ���Թ������źţ�Ҳ������[����FRFT-IFRFT������]���棩��
%-----------------------------------------------------------
% ��Ҫ�Ǳ�Ե���ֵ��ź�ʧ�棬�ź��е�λ��ͨ����ȷ����Եʧ�泤�Ⱥ��źų��ȳɱ�����
% ռ��С��һ���ֶ��ѡ��������ʺ�STFRFT��ʱ���˲�����������
%-----------------------------------------------------------









