% CS����ȥ��ѹ��������ֻ�����ع����㷨����ô���ھ����������������źţ�����ع���������Ҫ����һ�¡�
% ����ͳ��RMSE

clc;clear all; close all;
N=512;%��������
t=1:N;
f=linspace(0,0.5,N);
T0 = N/2;%��ʵ�ο���λλ��
nTest = 10;
SNR = [-30:2:0];
K_LFM = -0.5:0.2:0.5;%LFMб��*N�����ֵ0.5

corcef = zeros(length(K_LFM),length(SNR));
for iK=1:length(K_LFM)
    % ��������
    k_lfm=K_LFM(iK)/N;%LFMб��
    p = mod(2/pi*acot(-k_lfm*N),2);% FRFT��������һ��0-2֮��
    % ����������
    bais=eye(N,N);
    Psi = zeros(size(bais));
    for k = 1:N
        Psi(:,k) = frft(bais(:,k),p)*sqrt(N);%�Ը��л���FRFT�任
    end
    
    fprintf('sim k = %0.4f\n',K_LFM(iK));
    for iT = 1:nTest
        for iSnr = 1:length(SNR)
            % �źŲ���
            [sig1,if1] = fmlin(N,0,K_LFM(iK),T0);
            %         [sig2,if2] = fmlin(N,0.2,0.5,T0);%���ӷ���
            [sig2,if2] = fmconst(N,0.2,T0);%���ӷ���
            x_org = sig1 + sig2;
            x = awgn(x_org,SNR(iSnr),'measured'); %�������
            % OMP�ع�
            T=Psi';           %  �ָ�����(��������*�������任����)��y=�ָ�����*s������yΪ�۲����ݣ�sΪϡ���ʾϵ��
            [hat_y1,r_n] = omp(x,T,N,1);%OMP�㷨�ع�1������
            hat_s1=Psi'*hat_y1.';                         %  ���渵��Ҷ�任�ع��õ�ʱ���ź�
            
            %������
            % plot(t,real(sig1),'b.-');hold on; plot(t,real(x),'k+-'); plot(t,real(hat_s1),'o-r'); legend('�źŷ���','����Ⱦ���ź�','�ع��ķ���'),axis tight
            cor = corrcoef(hat_s1, sig1);%���ϵ��
            corcef(iK,iSnr) = corcef(iK,iSnr) + abs(cor(1,2)) ;%����
        end
    end
end

%�������
corcef = mean(corcef,1)/nTest;
figure,plot(SNR,corcef,'b.-');xlabel('SNR/dB');ylabel('correlative coefficient')
% �����������TFR��SNR=0dBʱ�������Ѿ��޷��ָ������������ź��ˣ�
% ������ϡ���򷽷��ָ����ź�ȴ�ǳ���������������ضȺܺã���

