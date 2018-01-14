function hiferr = IFest_perferenceEva(hif_hat,sif_ideal,N)
%% ���ݹ��ƵĶ��hif_hat�ṹ���������������IF������
% hif_hat ��cell������Ԫ�ذ�������IF�����㷨�Ĺ��ƽ��
% hif_ideal ��һ�����󣬸��б�ʾ�����źŵ�if����ֵ
% N Ƶ�ʲ�������

%% ������ϴ
sif_ideal(sif_ideal<0) = sif_ideal(sif_ideal<0) + 0.5;%��Ƶ�ʵĲ��������
sif_ideal = sif_ideal * N*2;

%% �����IF�����㷨��������
hiferr = zeros(size(sif_ideal,2),length(hif_hat));
for k1 = 1:size(sif_ideal,2)
    sif = sif_ideal(:,k1);
    for k2 = 1:length(hif_hat) % ���������㷨����ÿ���㷨�Ĺ��ƽ��������ӽ���ֵ��Ϊ����ֵ
        hif = hif_hat{k2}; rmse = zeros(1,length(hif));%��ʼ������
        for k3 = 1:length(hif)
            % ���㱾hif(k3)��sig(k1)�� RMSEֵ
            sif_chip = sif_ideal(hif{k3}(:,1),k1);
            hif_chip = hif{k3}(:,2);
            %plot(sif_chip,'r.-'); hold on; plot(hif_chip,'ko-');
            rmse(k3) = sqrt(sum( (sif_chip - hif_chip).^2 ) /N );
        end
        % ���㱾hif(k3)��sig(k1)�����������Ϊ��Ե�k1��IF�Ĺ���ֵ
        hiferr(k1,k2) = min(rmse);
    end
end

hiferr = hiferr/N;% ��һ��Ϊ�������ƽ��Ƶ�ʹ������
hiferr = mean(hiferr,1);%���źŷ�������ƽ��һ��

end