% CS����ȥ��ѹ��������ֻ�����ع����㷨����ô���ھ����������������źţ�����ع���������Ҫ����һ�¡�
% ѡ������ָ��Ĳ��Խű�

clc;clear all; close all;


clear all; close all; clc;
N=512;%��������
t=1:N;
f=linspace(0,0.5,N);
T0 = N/2;%��ʵ�ο���λλ��
nTest = 10;
SNR = [-30:2:10];
K_LFM = -0.5:0.2:0.5;%LFMб��*N�����ֵ0.5

RMSE = zeros(length(K_LFM),length(SNR));
MSE = zeros(length(K_LFM),length(SNR));
corcef = zeros(length(K_LFM),length(SNR));
for iK=1:length(K_LFM)
    % ��������
    k_lfm=K_LFM(iK)/N;%LFMб��
    p = mod(2/pi*acot(-k_lfm*N),2);% FRFT��������һ��0-2֮��
    
    fprintf('sim k = %0.4f\n',K_LFM(iK));
    for iT = 1:nTest
        for iSnr = 1:length(SNR)
            % �źŲ���
            [sig1,if1] = fmlin(N,0,K_LFM(iK),T0);
            %         [sig2,if2] = fmlin(N,0.2,0.5,T0);%���ӷ���
            [sig2,if2] = fmconst(N,0.2,T0);%���ӷ���
            x_org = sig1;% + sig2;
            x = awgn(x_org,SNR(iSnr),'measured'); %�������
            
            %ϡ�����ع�
            x_f = frft(x,p);
            x_f(x_f<max(x_f)*0.8)=0;
            hat_s1 = frft(x_f,-p);
            
            %������
            % plot(t,real(sig1),'b.-');hold on; plot(t,real(x),'k+-'); plot(t,real(hat_s1),'o-r');legend('�źŷ���','����Ⱦ���ź�','�ع��ķ���'),axis tight
            RMSE(iK,iSnr) = RMSE(iK,iSnr) + norm(hat_s1 - sig1, 'fro')/norm(sig1,'fro') ;
            MSE(iK,iSnr) = MSE(iK,iSnr) + norm(hat_s1 - sig1, 'fro');
            cor = corrcoef(hat_s1, sig1);%���ϵ��
            corcef(iK,iSnr) = corcef(iK,iSnr) + abs(cor(1,2)) ;%����
        end
    end
end

%�������
RMSE = mean(RMSE,1)/nTest;
MSE = mean(MSE,1)/nTest;
corcef = mean(corcef,1)/nTest;

figure,plot(SNR,RMSE,'b.-'); %���ָ��������Ⱥܴ�ʱЧ���ܲ����Ⱥ�Сʱ����Ч���Ϻ�
figure,plot(SNR,MSE,'b.-'); %���ָ������ʱ�����������źŵķ������ţ�������۽���ȽϺ���
figure,plot(SNR,corcef,'b.-');%���ָ��������ؽ��ջ�ʱ����Ч���ǳ�����



