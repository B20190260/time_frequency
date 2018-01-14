function rmse = TVF_component_rmse_Monte_Carlo(s_org,s_cpnt,sif,SNR,testN, LenStft, LenStfrft, LenOverlap)
%% ���ж�����źŷ�������ؿ�����棬�Ա�STFT-FIX/STFT-ADA/STFT-ADA-MOD/STFRFT-FIX/STFRFT-ADA/STFRFT-ADA-MOD
% ���������s_org ��ʾ����ĵ����źţ��������������򲻷������ؿ���ԭ��
% s_cpnt ��ʾ������źŷ�������ÿһ�б�ʾһ���źŷ���
% sif ��ʾ������ź�˲ʱƵ�ʾ���ÿһ�ж�Ӧһ���źŷ���
% SNR ��Ҫ�����SNR����
% testN ��Ҫ����Ĵ���
%rmse�����ص�1-8�������ֱ�Ϊ STFT-FIX/STFT-FIX-MOD/STFT-ADA/STFT-ADA-MOD/STFRFT-FIX/STFRFT-FIX-MOD/STFRFT-ADA/STFRFT-ADA-MOD

% ��������
if  nargin < 6 ;LenStft = 10;end% STFT�Ĵ�����
if  nargin < 7 ;LenStfrft = round(0.5*LenStft); end;%STFRFT�Ĵ�����
if  nargin < 8 ;LenOverlap = round(3*LenStft); end % ����ĵ����źų��ȷ�Χ

%testN = 100; SNR = -20:2:20;%dB--�����������
sigN = size(s_cpnt,2);
LEN_SNR = length(SNR);
rmse = zeros(LEN_SNR,sigN,8);%�����㷨�Ա�
for k = 1:LEN_SNR
    fprintf('TVF_component_rmse_Monte_Carlo, snr = %d / %d , ',SNR(k),SNR(end));tic
    for n = 1:testN
        s = awgn(s_org,SNR(k),'measured');
        % �㷨ʵ��
        [sh1,tfr,tfrv1] = stftSeparation(s,sif,LenStft);%�̶�������
        %sh2 = amplitudeFit(sh1, tfr, tfrv1, 1);%imagesc(abs(tfr))
        sh2 = amplitudeInterp(sh1, sif, LenOverlap, 1);%���÷��Ȳ�ֵ�ķ�ʽ�ָ�--������λʧ��
        
        [sh3,tfr,tfrv2] = stftSeparationAdv(s,sif,LenStft);%����Ӧ�����ȵ�ʱ���˲����������ò����������ܿ����½�
        %sh4 = amplitudeFit(sh3, tfr, tfrv2, 1);%imagesc(abs(tfrv1(:,:,3))); figure; imagesc(abs(tfrv2(:,:,3)))
        sh4 = amplitudeInterp(sh3, sif, LenOverlap, 1);
        
        [sh5,tfrTmp,tfrvTmp] = stfrftSeparation(s,sif,LenStfrft);%�̶�������
        %sh6 = amplitudeFit(sh5,tfr,tfrv2,1);%imagesc(abs(tfrTmp(:,:,1)));figure;imagesc(abs(tfrvTmp(:,:,1)));
        sh6 = amplitudeInterp(sh5, sif, LenOverlap, 1);
        
        [sh7,tfrTmp,tfrvTmp] = stfrftSeparationAdv(s,sif,LenStfrft);%����Ӧ�����ȵ�ʱ���˲�--FRFT���������У������Ҫ�Ŀ�ȸ�С
        %sh8 = amplitudeFit(sh7, tfr, tfrv2, 1);%imagesc(abs(tfrTmp(:,:,1)));figure;imagesc(abs(tfrvTmp(:,:,1)));
        sh8 = amplitudeInterp(sh7, sif, LenOverlap, 1);
        
        %���ͳ��
        for sign = 1:sigN
            rmse(k,sign,1)=rmse(k,sign,1) + sqrt(mean(abs(sh1(:,sign)-s_cpnt(:,sign)).^2));
            rmse(k,sign,2)=rmse(k,sign,2) + sqrt(mean(abs(sh2(:,sign)-s_cpnt(:,sign)).^2));
            rmse(k,sign,3)=rmse(k,sign,2) + sqrt(mean(abs(sh3(:,sign)-s_cpnt(:,sign)).^2));
            rmse(k,sign,4)=rmse(k,sign,4) + sqrt(mean(abs(sh4(:,sign)-s_cpnt(:,sign)).^2));
            rmse(k,sign,5)=rmse(k,sign,5) + sqrt(mean(abs(sh5(:,sign)-s_cpnt(:,sign)).^2));
            rmse(k,sign,6)=rmse(k,sign,6) + sqrt(mean(abs(sh6(:,sign)-s_cpnt(:,sign)).^2));
            rmse(k,sign,7)=rmse(k,sign,7) + sqrt(mean(abs(sh7(:,sign)-s_cpnt(:,sign)).^2));
            rmse(k,sign,8)=rmse(k,sign,8) + sqrt(mean(abs(sh8(:,sign)-s_cpnt(:,sign)).^2));
        end
    end
    fprintf('��ʱ %f s, Ԥ��ʣ�� %.3f min \n',toc, toc*(LEN_SNR-k)/60);
    rmse(k,:) = rmse(k,:)/testN;
end

end