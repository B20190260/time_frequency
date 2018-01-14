function rmse = TVF_component_rmse_Monte_Carlo(s_org,s_cpnt,sif,SNR,testN, LenStft, LenStfrft)
%% ���ж�����źŷ�������ؿ�����棬�Ա�STFT-ADA//STFRFT-ADA
% ���������s_org ��ʾ����ĵ����źţ��������������򲻷������ؿ���ԭ��
% s_cpnt ��ʾ������źŷ�������ÿһ�б�ʾһ���źŷ���
% sif ��ʾ������ź�˲ʱƵ�ʾ���ÿһ�ж�Ӧһ���źŷ���
% SNR ��Ҫ�����SNR����
% testN ��Ҫ����Ĵ���
%rmse�����ص�2�������ֱ�ΪSTFT-ADA//STFRFT-ADA/synsqCwt-ADA

% ��������
if  nargin < 6 ;LenStft = 10;end% STFT�Ĵ�����
if  nargin < 7 ;LenStfrft = round(0.5*LenStft); end;%STFRFT�Ĵ�����

%testN = 100; SNR = -20:2:20;%dB--�����������
sigN = size(s_cpnt,2);
LEN_SNR = length(SNR);
rmse = zeros(LEN_SNR,sigN,3);%�����㷨�Ա�
for k = 1:LEN_SNR
    fprintf('TVF_component_rmse_Monte_Carlo, snr = %d / %d , ',SNR(k),SNR(end));tic
    for n = 1:testN
        s = awgn(s_org,SNR(k),'measured');
        % �㷨ʵ��
        [sh1,tfr,tfrv] = stftSeparationAdv(s,sif,LenStft);%����Ӧ�����ȵ�ʱ���˲����������ò����������ܿ����½�
        %imagesc(abs(tfr(:,:))); % imagesc(abs(tfrv(:,:,1)));
        [sh2,tfrfr,tfrfrv] = stfrftSeparationAdv(s,sif,LenStfrft);%����Ӧ�����ȵ�ʱ���˲�--FRFT���������У������Ҫ�Ŀ�ȸ�С
        %imagesc(abs(tfrfr(:,:,1))); % imagesc(abs(tfrfr(:,:,2))); %imagesc(abs(tfrfrv(:,:,1)))
        [sh3,tfrcw,tfrcwv] = synsqCwtSeparationAdv(s,sif,LenStfrft);
        %imagesc(abs(tfrfr(:,:,1))); % imagesc(abs(tfrfr(:,:,2))); %imagesc(abs(tfrfrv(:,:,1)))
        
        %���ͳ��
        for sign = 1:sigN
            rmse(k,sign,1)=rmse(k,sign,1) + sqrt(mean(abs(sh1(:,sign)-s_cpnt(:,sign)).^2));
            rmse(k,sign,2)=rmse(k,sign,2) + sqrt(mean(abs(sh2(:,sign)-s_cpnt(:,sign)).^2));
            rmse(k,sign,3)=rmse(k,sign,3) + sqrt(mean(abs(sh3(:,sign)-s_cpnt(:,sign)).^2));
        end
    end
    fprintf('��ʱ %f s, Ԥ��ʣ�� %.3f min \n',toc, toc*(LEN_SNR-k)/60);
    rmse(k,:) = rmse(k,:)/testN;
end

end