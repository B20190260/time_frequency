%% �����źźϳɷ���


%% ʹ��synthesize�����ϳ��ź�--������
% s = fmlin(512,0,0.5,15);
% tfd_wvd = quadtfd( s, 127, 1, 'wvd', 128 );
% s_hat = synthesize( tfd_wvd, 'wvd', 127, s);
% plot(1:length(s),imag(s),'b.-',1:length(s_hat),imag(s_hat),'rx-'); axis tight

%% ʱ���˲�STFT�²ſ��Բ���
% clear all; clc; close all
% N=512;
% s = fmlin(N,0,0.5,120);
% t = 1:N;
% tfd_stft = tfrstft_my(s);%surf(abs(tfd_stft(:,1:2:end)));xlabel('t'); axis tight
% s_hat = sum(tfd_stft,1)/N;%������Ƶ�ʷ�������һ����
% subplot(211)
% plot(t,real(s),'b.-');axis tight; hold on;
% plot(t,real(s_hat),'rx-');legend('ԭ�ź�','�ϳ��ź�')
% sn = awgn(s,10,'measured');
% tfd_stftn = tfrstft_my(sn);%surf(abs(tfd_stftn(:,1:2:end)));xlabel('t'); axis tight
% sn_hat = sum(tfd_stftn,1)/N;%������Ƶ�ʷ�������һ����
% subplot(212)
% plot(t,real(sn),'b.-');axis tight; hold on;
% plot(t,real(sn_hat),'rx-');legend('ԭ�ź�','�ϳ��ź�')

%% STFT��ʱ���˲�ȥ��
% clear all; clc; close all
% N=512;  t = 1:N;
% [s, sif] = fmlin(N,0,0.5,120);
% sn = awgn(s,0,'measured');%��0dB����
% tfd_stftn = tfrstft_my(sn);
% win = [ones(20,1);zeros(472,1);ones(20,1)];%�̶�������40
% for k=1:N
%     winT = circshift(win,round(sif(k)*512),1);%��ѭ��ƽ�Ƶ�IF����
%     tfd_filter(:,k) = tfd_stftn(:,k).*winT;%ʱ���˲�
% end
% sden = sum(tfd_filter,1)/N;%ȥ�����ź�
% tfd_den = tfrstft_my(sden.');%ȥ�����ź�STFT
% figure(1);subplot(131);imagesc(abs(tfd_stftn));xlabel('t'); ylabel('f');axis xy
% subplot(132);imagesc(abs(tfd_filter));xlabel('t'); ylabel('f');axis xy
% subplot(133);imagesc(abs(tfd_den));xlabel('t'); ylabel('f');axis xy
% figure(2);plot(t,real(s),'b.-');hold on;
% plot(t,real(sn),'k.-');plot(t,real(sden),'rx-');axis tight;legend('ԭ�ź�','�����ź�','ȥ���ź�')


%% STFT �µ�����AM-FM-PM�źŵĻָ�
% clear all; clc; close all
% N=512;  t = 1:N;
% [sfm, sif] = fmlin(N,0,0.5,50);%plot(real(sfm))
% sam = (sin(0.05*t + pi/16)+2)/3;%plot(sam)
% s = sfm.*sam.';%plot(real(s)) % ���ȵ���
% sn = awgn(s,5,'measured');%��5dB����
% tfd_stftn = tfrstft_my(sn);
% win = [ones(30,1);zeros(452,1);ones(30,1)];%�̶�������60
% for k=1:N
%     winT = circshift(win,round(sif(k)*512),1);%��ѭ��ƽ�Ƶ�IF����
%     tfd_filter(:,k) = tfd_stftn(:,k).*winT;%ʱ���˲�
% end
% sden = sum(tfd_filter,1)/N;%ȥ�����ź�
% tfd_den = tfrstft_my(sden.');%ȥ�����ź�STFT
% figure(1);subplot(131);imagesc(abs(tfd_stftn));xlabel('t'); ylabel('f');axis xy
% subplot(132);imagesc(abs(tfd_filter));xlabel('t'); ylabel('f');axis xy
% subplot(133);imagesc(abs(tfd_den));xlabel('t'); ylabel('f');axis xy
% figure(2);plot(t,real(s),'b.-');hold on;
% plot(t,real(sn),'g.-');plot(t,real(sden),'rx-');axis tight;legend('ԭ�ź�','�����ź�','ȥ���ź�')



%% STFT��2�����źŷ���+����У��
% clear all; clc; close all
% N=512;  t = 1:N;
% [s1, sif1] = fmlin(N,0,0.4,120);
% [s2, sif2] = fmlin(N,0.5,0,360);
% s = s1+s2;%�źŵ���
% tfd = tfrstft_my(s);
% sigs = timeVaryingFilter(tfd,60,[sif1,sif2]);
% % ��ͼ�Ա�
% subplot(311);plot(t,real(s1),'b.-'); hold on;
% plot(t,real(sigs(:,1)),'rx-');axis tight; legend('ԭʼ�źŷ���','�ָ����źŷ���');
% subplot(312);plot(t,real(s2),'b.-'); hold on;
% plot(t,real(sigs(:,2)),'rx-');axis tight; legend('ԭʼ�źŷ���','�ָ����źŷ���');
% subplot(313);plot(t,real(s),'b.-'); hold on;
% plot(t,real(sigs(:,2)+sigs(:,1)),'rx-');axis tight; legend('ԭʼ�ź�','�ָ����źŵ���');


%% STFT��3�����źŷ���+����У��
clear all; clc; close all
N=512;  t = 1:N;
[s1, sif1] = fmlin(N,0,0.4,120);
[s2, sif2] = fmlin(N,0.4,0,360);
[s3, sif3] = fmlin(N,0.2,0.2,60);
s = s1+s2+s3;%�źŵ���
tfd = tfrstft_my(s);%surf(abs(tfd))
sigs = timeVaryingFilter(tfd,60,[sif1,sif2,sif3]);
% ��ͼ�Ա�
subplot(311);plot(t,real(s1),'b.-'); hold on;
plot(t,real(sigs(:,1)),'rx-');axis tight; legend('ԭʼ�źŷ���','�ָ����źŷ���');
subplot(312);plot(t,real(s2),'b.-'); hold on;
plot(t,real(sigs(:,2)),'rx-');axis tight; legend('ԭʼ�źŷ���','�ָ����źŷ���');
subplot(313);plot(t,real(s3),'b.-'); hold on;
plot(t,real(sigs(:,3)),'rx-');axis tight; legend('ԭʼ�źŷ���','�ָ����źŷ���');






















