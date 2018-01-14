function rmse = TVF_component_rmse_Monte_Carlo_STFRFT(s_org,s_cpnt,sif,SNR,testN)
%% ���ж�����źŷ�������ؿ�����棬����STFRFT����Ӧ������
% ���������s_org ��ʾ����ĵ����źţ��������������򲻷������ؿ���ԭ��
% s_cpnt ��ʾ������źŷ�������ÿһ�б�ʾһ���źŷ���
% sif ��ʾ������ź�˲ʱƵ�ʾ���ÿһ�ж�Ӧһ���źŷ���
% SNR ��Ҫ�����SNR����
% testN ��Ҫ����Ĵ���

%testN = 100; SNR = -20:2:20;%dB--�����������
sigN = size(s_cpnt,2);
rmse = zeros(length(SNR),sigN);%�����㷨�Ա�
LEN_SNR = length(SNR);
for k = 1:LEN_SNR
    fprintf('TVF_component_rmse_Monte_Carlo, snr = %d / %d , ',SNR(k),SNR(end));tic
    for n = 1:testN
        s = awgn(s_org,SNR(k),'measured');
        [sh2,tfr,tfrv2] = stfrftSeparationAdv(s,sif,8);%����Ӧ�����ȵ�ʱ���˲����������ò����������ܿ����½�
        for sign = 1:sigN
            rmse(k,sign)=rmse(k,sign) + sqrt(mean(abs(sh2(:,sign)-s_cpnt(:,sign)).^2));
        end
    end
    fprintf('��ʱ %f s, Ԥ��ʣ�� %.3f min \n',toc, toc*(LEN_SNR-k)/60);
    rmse(k,:) = rmse(k,:)/testN;
end

end