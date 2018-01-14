% ����Ƶ��100MHz������1V
% ���ű��ļ��������С�ʱ���˲������½ڡ����ͼ�����ɵ���䣬
% ĳЩ��������̫ռ�ռ��װ�����������ˣ�����鿴��ע�͡�


%% ���ԵĶԱȻ��ڹ̶����������Ӧ��Χ��ʱ���˲�ʵ�ֲ���
clear all; clc; close all
Fs = 100;N=512; 
t = (0:(N-1))/Fs; f = linspace(-Fs/2,Fs/2,N);
[s_org,sif] = fmlin(N,0,0.5,120);
s = awgn(s_org,0,'measured');
[sh1,tfr,tfrv1] = stftSeparation(s,sif,30);%�̶������ȵ�ʱ���˲�
[sh2,tfr,tfrv2] = stftSeparationAdv(s,sif,30);%����Ӧ�����ȵ�ʱ���˲�

figure('Name','STFT');imagesc(abs(tfr)); set_gca_style([4,4],'img');
figure('Name','STFT-fix-window');imagesc(abs(tfrv1)); set_gca_style([4,4],'img');
figure('Name','STFT-ada-window');imagesc(abs(tfrv2)); set_gca_style([4,4],'img');

figure;plot(t,real(s_org),'b-',t,real(s),'m.-',t,real(sh1),'r^-',t,real(sh2),'kv-');
legend('ԭ�ź�','�������ź�','�̶���TVF','����Ӧ��TVF');
set_gca_style([12,6]); xlim([t(20),t(120)])%�鿴��Եֵ
xlabel('ʱ��/\mus'),ylabel('����/V');


%% �����ĶԱȻ��ڹ̶����������Ӧ��Χ��ʱ���˲����ܲ���
TVF_Compare_fixAda_window_STFT();


pause
%% ���޽�������źŷ���Ч���Աȣ�����+����
% �����棬1LFM+1SFM
clear all; clc; close all
Fs = 100;N=256; 
t = (0:(N-1))/Fs; f = linspace(-Fs/2,Fs/2,N);
[s1, sif1] = fmlin(N,0.1,0.2,120);
[s2, sif2] = fmsin(N,0.25,0.45,N+50);
s_org = s1+s2;%�źŵ���
s = awgn(s_org,0,'measured');%��5dB������SNR�ܸ�ʱ������źż��������غϡ�
figure('Name','sigmix-time');plot(t,real(s_org),'k-',t,real(s),'b--'); legend('�����ź�','�������ź�');
xlabel('ʱ��/\mus'),ylabel('����/V');set_gca_style([12,4]);xlim([t(1),t(128)])%�鿴��Եֵ

% [sh1,tfr,tfrv1] = stftSeparation(s,[sif1,sif2],20);%�̶������ȵ�ʱ���˲�
[sh2,tfr,tfrv2] = stftSeparationAdv(s,[sif1,sif2],20);%����Ӧ�����ȵ�ʱ���˲�
figure('Name','STFT');imagesc(abs(tfr)); set_gca_style([4,4],'img');
figure('Name','STFT-ada-window-sig1');imagesc(abs(tfrv2(:,:,1))); set_gca_style([4,4],'img');
figure('Name','STFT-ada-window-sig2');imagesc(abs(tfrv2(:,:,2))); set_gca_style([4,4],'img');

figure('Name','sig1-time');plot(t,real(s1),'k-',t,real(sh2(:,1)),'b--'); legend('ԭʼ�ź�','TVF�����ź�');
xlabel('ʱ��/\mus'),ylabel('����/V');set_gca_style([12,4]);xlim([t(10),t(128)])%�鿴��Եֵ
figure('Name','sig2-time');plot(t,real(s2),'k-',t,real(sh2(:,2)),'b--'); legend('ԭʼ�ź�','TVF�����ź�');
xlabel('ʱ��/\mus'),ylabel('����/V');set_gca_style([12,4]);xlim([t(10),t(128)])%�鿴��Եֵ

% ���ؿ������Ա���������RMSE
testN = 20; SNR = -20:2:20;% �������
rmse = TVF_component_rmse_Monte_Carlo_STFT(s_org,[s1,s2],[sif1,sif2],SNR,testN);
figure('Name','���ؿ�������������');plot(SNR,rmse(:,1),'b^-',SNR,rmse(:,2),'rv-');legend('����1','����2');
xlabel('SNR/dB');ylabel('RMSE');set_gca_style([12,4]);
h2=axes('position',[0.42 0.5 0.25 0.4]);%������ͼ�Ŵ�
plot(h2,SNR,rmse(:,1),'b^-',SNR,rmse(:,2),'rv-');
axis(h2,[SNR(15),SNR(end),0,1]);

pause
%% ���н�������źŷ���Ч���Ա�--STFT������+����
% �����棬1LFM+1SFM
clear all; clc; close all
Fs = 100;N=256; 
t = (0:(N-1))/Fs; f = linspace(-Fs/2,Fs/2,N);
[s1, sif1] = fmlin(N,0.35,0.1,N/2);
[s2, sif2] = fmsin(N,0.08,0.35,N+50);
s_org = s1+s2;%�źŵ���
s = awgn(s_org,0,'measured');%��5dB����
figure('Name','sigmix-time');plot(t,real(s_org),'k-',t,real(s),'b--'); legend('�����ź�','�������ź�');
xlabel('ʱ��/\mus'),ylabel('����/V');set_gca_style([12,4]);xlim([t(78),t(180)])%�鿴��Եֵ

% [sh1,tfr,tfrv1] = stftSeparation(s,[sif1,sif2],20);%�̶������ȵ�ʱ���˲�
[sh2,tfr,tfrv2] = stftSeparationAdv(s,[sif1,sif2],20);%����Ӧ�����ȵ�ʱ���˲�
figure('Name','STFT');imagesc(abs(tfr)); set_gca_style([4,4],'img');
figure('Name','STFT-ada-window-sig1');imagesc(abs(tfrv2(:,:,1))); set_gca_style([4,4],'img');
figure('Name','STFT-ada-window-sig2');imagesc(abs(tfrv2(:,:,2))); set_gca_style([4,4],'img');

% figure('Name','sig1-time');plot(t,real(s1),'k-',t,real(sh2(:,1)),'b--'); legend('ԭʼ�ź�','TVF�����ź�');
% xlabel('ʱ��/\mus'),ylabel('����/V');set_gca_style([12,4]);xlim([t(78),t(180)])%�鿴��Եֵ
% figure('Name','sig2-time');plot(t,real(s2),'k-',t,real(sh2(:,2)),'b--'); legend('ԭʼ�ź�','TVF�����ź�');
% xlabel('ʱ��/\mus'),ylabel('����/V');set_gca_style([12,4]);xlim([t(78),t(180)])%�鿴��Եֵ

% ���ؿ������Ա���������RMSE
testN = 20; SNR = -20:2:20;% �������
rmse = TVF_component_rmse_Monte_Carlo_STFT(s_org,[s1,s2],[sif1,sif2],SNR,testN);
figure('Name','���ؿ�������������');h1=axes();
plot(h1,SNR,rmse(:,1),'b^-',SNR,rmse(:,2),'rv-');legend('����1','����2');
xlabel('SNR/dB');ylabel('RMSE');set_gca_style([12,4]);
h2=axes('position',[0.42 0.5 0.25 0.4]);%������ͼ�Ŵ�
plot(h2,SNR,rmse(:,1),'b^-',SNR,rmse(:,2),'rv-');
axis(h2,[SNR(15),SNR(end),0,1]);

% ��������
shf2 = amplitudeFit(sh2, tfr, tfrv2, 1);%���÷�����ϵķ�ʽ�ָ�--������λʧ��
figure('Name','sig1-time');plot(t,real(s1),'k-',t,real(sh2(:,1)),'b--',t,real(shf2(:,1)),'r.:'); legend('ԭʼ�ź�','TVF�����ź�','����У���ź�');
xlabel('ʱ��/\mus'),ylabel('����/V');set_gca_style([12,4]);xlim([t(70),t(190)]);ylim([-2,6])%�鿴��Եֵ
figure('Name','sig2-time');plot(t,real(s2),'k-',t,real(sh2(:,2)),'b--',t,real(shf2(:,2)),'r.:'); legend('ԭʼ�ź�','TVF�����ź�','����У���ź�');
xlabel('ʱ��/\mus'),ylabel('����/V');set_gca_style([12,4]);xlim([t(70),t(190)]);ylim([-2,6])%�鿴��Եֵ



pause
%% ���н�������źŷ���Ч���Ա�--STFRFT������+����
% �����棬1LFM+1SFM
clear all; clc; close all
Fs = 100;N=256; %������Ҫ�������һ���Ա�Ա�
t = (0:(N-1))/Fs; f = linspace(-Fs/2,Fs/2,N);
[s1, sif1] = fmlin(N,0.35,0.1,N/2);
[s2, sif2] = fmsin(N,0.08,0.35,N+50);
s_org = s1+s2;%�źŵ���
s = awgn(s_org,0,'measured');%��5dB����

% [sh1,tfr,tfrv1] = stfrftSeparation(s,[sif1,sif2],8);%����Ӧ�����ȵ�ʱ���˲�
[sh2,tfr,tfrv2] = stfrftSeparationAdv(s,[sif1,sif2],8);%����Ӧ�����ȵ�ʱ���˲�--FRFT���������У������Ҫ�Ŀ�ȸ�С
figure('Name','STFRFT-sig1');imagesc(abs(tfr(:,:,1))); set_gca_style([4,4],'img');
figure('Name','STFRFT-sig2');imagesc(abs(tfr(:,:,2))); set_gca_style([4,4],'img');
figure('Name','STFRFT-ada-window-sig1');imagesc(abs(tfrv2(:,:,1))); set_gca_style([4,4],'img');
figure('Name','STFRFT-ada-window-sig2');imagesc(abs(tfrv2(:,:,2))); set_gca_style([4,4],'img');

% figure('Name','sig1-time');plot(t,real(s1),'k-',t,real(sh2(:,1)),'b--'); legend('ԭʼ�ź�','TVF�����ź�');
% xlabel('ʱ��/\mus'),ylabel('����/V');set_gca_style([12,4]);xlim([t(78),t(180)]);ylim([-2,2])%�鿴��Եֵ
% figure('Name','sig2-time');plot(t,real(s2),'k-',t,real(sh2(:,2)),'b--'); legend('ԭʼ�ź�','TVF�����ź�');
% xlabel('ʱ��/\mus'),ylabel('����/V');set_gca_style([12,4]);xlim([t(78),t(180)]);ylim([-2,2])%�鿴��Եֵ

% ���ؿ������Ա���������RMSE
testN = 20; SNR = -20:2:20;% �������
rmse = TVF_component_rmse_Monte_Carlo_STFRFT(s_org,[s1,s2],[sif1,sif2],SNR,testN);
figure('Name','���ؿ�������������');h1=axes();
plot(h1,SNR,rmse(:,1),'b^-',SNR,rmse(:,2),'rv-');legend('����1','����2');
xlabel('SNR/dB');ylabel('RMSE');set_gca_style([12,4]);
h2=axes('position',[0.42 0.5 0.25 0.4]);%������ͼ�Ŵ�
plot(h2,SNR,rmse(:,1),'b^-',SNR,rmse(:,2),'rv-');
axis(h2,[SNR(15),SNR(end),0,1]);

Results_File = ['TVF_component_rmse_Monte_Carlo_STFRFT_2sig',datestr(clock,'_yyyy_mm_dd_hh_MM')];
save(Results_File,'SNR','rmse');

[~,tfr,tfrv2] = stftSeparationAdv(s,[sif1,sif2],20);%��ȡ�������λ����Ҫ�õ�
shf2 = amplitudeFit(sh2, tfr, tfrv2, 1);%���÷�����ϵķ�ʽ�ָ�--������λʧ��
figure('Name','sig1-time');plot(t,real(s1),'k-',t,real(sh2(:,1)),'b--',t,real(shf2(:,1)),'r.:'); legend('ԭʼ�ź�','TVF�����ź�','����У���ź�');
xlabel('ʱ��/\mus'),ylabel('����/V');set_gca_style([12,4]);xlim([t(70),t(190)]);ylim([-2,6])%�鿴��Եֵ
figure('Name','sig2-time');plot(t,real(s2),'k-',t,real(sh2(:,2)),'b--',t,real(shf2(:,2)),'r.:'); legend('ԭʼ�ź�','TVF�����ź�','����У���ź�');
xlabel('ʱ��/\mus'),ylabel('����/V');set_gca_style([12,4]);xlim([t(70),t(190)]);ylim([-2,6])%�鿴��Եֵ


pause
%% ��ͬ�ź�TVF���㷨��RMSE���ܶԱȣ������ź�
% 2LFM+1SFM
clear all; clc; close all;
testN = 20; SNR = -20:5:20;% �������
N=128;  t = 1:N;
[s1, sif1] = fmlin(N,0.03,0.09);
[s2, sif2] = fmlin(N,0.31,0.5);
[s3, sif3] = fmsin(N,0.15,0.28,N);
s_org = s1+s2+s3;%tfr = tfrstft(s_org);imagesc(abs(tfr));axis xy
% figure('Name','sigmix-time');plot(t,real(s_org),'k-'); xlabel('ʱ��/\mus'),ylabel('����/V');set_gca_style([12,4]);
% figure('Name','tfrwv');tfr = tfrstft(s_org);imagesc(abs(tfr));set_gca_style([4,4],'img');%imagesc(abs(tfrADTFD(s_org,2,14,82)));

rmse = TVF_component_rmse_Monte_Carlo(s_org,[s1,s2,s3],[sif1,sif2,sif3],SNR,testN,10,6,50);
rmseSum = mean(rmse,2);
figure('Name','���ؿ�������������2LFM1SFM');label={'ko-','ksquare-','kdiamond-','kx-','rv-','r^-','r<-','r>-','bpentagram-','bhexagram-','m+-','m*-','mx-'};%��ע���ã�֧�����13������
% for k=1:8; plot(SNR,20*log(rmseSum(:,1,k)),label{k});hold on; end%����ȫ���������ܲ�����
for k=1:8; plot(SNR,20*log(rmse(:,3,k)),label{k});hold on;   end  %ֻ���ǵ����������Է��������ܲ��ܸ���
legend('STFT-F','STFT-FM','STFT-A','STFT-AM','STFRFT-F','STFRFT-FM','STFRFT-A','STFRFT-AM');
xlabel('SNR/dB');ylabel('RMSE/dB');set_gca_style([16,8]);

Results_File = ['TVF_component_rmse_Monte_Carlo_2LFM1SFM',datestr(clock,'_yyyy_mm_dd_hh_MM')];
save(Results_File,'SNR','rmse');pause(0.1)


% 3LFM�ཻ
clear all; clc; close all;
testN = 20; SNR = -20:5:20;% �������
N=128;  t = 1:N;
[s1, sif1] = fmlin(N,0,0.4,29);
[s2, sif2] = fmlin(N,0.4,0,90);
[s3, sif3] = fmlin(N,0.2,0.2,14);
s_org = s1+s2+s3;%tfr = tfrstft(s_org);imagesc(abs(tfr))
% figure('Name','sigmix-time');plot(t,real(s_org),'k-'); xlabel('ʱ��/\mus'),ylabel('����/V');set_gca_style([12,4]);
% figure('Name','tfrwv');tfr = tfrstft(s_org);imagesc(abs(tfr));set_gca_style([4,4],'img');%imagesc(abs(tfrADTFD(s_org,2,14,82)));


rmse = TVF_component_rmse_Monte_Carlo(s_org,[s1,s2,s3],[sif1,sif2,sif3],SNR,testN,10,6,3);
rmseSum = mean(rmse,2);
figure('Name','���ؿ�������������3LFM');label={'ko-','ksquare-','kdiamond-','kx-','rv-','r^-','r<-','r>-','bpentagram-','bhexagram-','b+-','b*-','mx-'};%��ע���ã�֧�����13������
for k=1:8; plot(SNR,20*log(rmseSum(:,1,k)),label{k});hold on;   end
for k=4:8; plot(SNR,20*log((rmse(:,1,k)+rmse(:,2,k))/2),label{k+4});hold on;   end% ֻ������б����
legend('STFT-F','STFT-FM','STFT-A','STFT-AM','STFRFT-F','STFRFT-FM','STFRFT-A','STFRFT-AM');
xlabel('SNR/dB');ylabel('RMSE/dB');set_gca_style([16,8]);

Results_File = ['TVF_component_rmse_Monte_Carlo_3LFM',datestr(clock,'_yyyy_mm_dd_hh_MM')];
save(Results_File,'SNR','rmse');pause(0.1)


% 3LFM+1SFM
clear all; clc; %close all;
testN = 20; SNR = -20:5:20;% �������
N=128;  t = 1:N;
[s1, sif1] = fmlin(N,0.05,0.11,30);
[s2, sif2] = fmlin(N,0.1,0.2,1);
[s3, sif3] = fmsin(N,0.22,0.42,128);
[s4, sif4] = fmlin(N,0.4,0.16,1);
s_org = s1+s2+s3+s4;%tfr = tfrstft(s_org);imagesc(abs(tfr))
% figure('Name','sigmix-time');plot(t,real(s_org),'k-'); xlabel('ʱ��/\mus'),ylabel('����/V');set_gca_style([12,4]);
% figure('Name','tfrwv');tfr = tfrstft(s_org);imagesc(abs(tfr));set_gca_style([4,4],'img');%imagesc(abs(tfrADTFD(s_org,2,14,82)));

rmse = TVF_component_rmse_Monte_Carlo(s_org,[s1,s2,s3,s4],[sif1,sif2,sif3,sif4],SNR,testN,10,6,50);
rmseSum = mean(rmse,2);
figure('Name','���ؿ�������������3LFM+1SFM');label={'ko-','ksquare-','kdiamond-','kx-','rv-','r^-','r<-','r>-','bpentagram-','bhexagram-','m+-','m*-','mx-'};%��ע���ã�֧�����13������
for k=1:8; plot(SNR,20*log(rmseSum(:,1,k)),label{k});hold on;   end
% for k=1:8; plot(SNR,20*log(rmse(:,1,k)),label{k});hold on;   end
legend('STFT-F','STFT-FM','STFT-A','STFT-AM','STFRFT-F','STFRFT-FM','STFRFT-A','STFRFT-AM');
xlabel('SNR/dB');ylabel('RMSE/dB');set_gca_style([16,8]);

Results_File = ['TVF_component_rmse_Monte_Carlo_3LFM1SFM',datestr(clock,'_yyyy_mm_dd_hh_MM')];
save(Results_File,'SNR','rmse');pause(0.1)






