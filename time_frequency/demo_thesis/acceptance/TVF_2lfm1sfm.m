%% ��ͬ�ź�TVF���㷨��RMSE���ܶԱȣ������ź�
% 2LFM+1SFM

clear all; clc; close all;

testN = 1; SNR = -20:5:20;%%%%% �������

N=128;  t = 1:N;
[s1, sif1] = fmlin(N,0.03,0.09);
[s2, sif2] = fmlin(N,0.31,0.5);
[s3, sif3] = fmsin(N,0.15,0.28,N);
s_org = s1+s2+s3;%tfr = tfrstft(s_org);imagesc(abs(tfr));axis xy
% figure('Name','sigmix-time');plot(t,real(s_org),'k-'); xlabel('ʱ��/\mus'),ylabel('����/V');set_gca_style([12,4]);
% figure('Name','tfrwv');tfr = tfrstft(s_org);imagesc(abs(tfr));set_gca_style([4,4],'img');%imagesc(abs(tfrADTFD(s_org,2,14,82)));

rmse = TVF_rmse_Monte_Carlo(s_org,[s1,s2,s3],[sif1,sif2,sif3],SNR,testN,10,6,50);
rmseSum = mean(rmse,2);
figure('Name','���ؿ�������������2LFM1SFM');label={'ko-','ksquare-','kdiamond-','kx-','rv-','r^-','r<-','r>-','m.-','bhexagram-','m+-','m*-','mx-'};%��ע���ã�֧�����13������
% for k=1:9; plot(SNR,20*log(rmseSum(:,1,k)),label{k});hold on; end%����ȫ���������ܲ�����
for k=1:9; plot(SNR,20*log(rmse(:,3,k)),label{k});hold on;   end  %ֻ���ǵ����������Է��������ܲ��ܸ���
legend('STFT-F','STFT-FM','STFT-A','STFT-AM','STFRFT-F','STFRFT-FM','STFRFT-A','STFRFT-AM','SWT');
xlabel('SNR/dB');ylabel('RMSE/dB');%set_gca_style([16,8]);

% Results_File = ['TVF_rmse_Monte_Carlo_2LFM1SFM',datestr(clock,'_yyyy_mm_dd_hh_MM'),'_N=',num2str(testN)];
% save(Results_File,'SNR','rmse');pause(0.1)

