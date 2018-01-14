%% ͳ�Ʋ��ø��ַ�����MMSE��SNR
clear all; close all;clc

%% ԭʼ�źŲ����͹̶���������
[s_gen,s_itfr,s_org,iflaw] = signalGenLxLS();%ָ��2LFM+1SFM�źţ����ཻ
iflaw(isnan(iflaw)) = 0;iflaw = iflaw*length(s_gen)*2;energy = std(iflaw,0,1).^2;
Gt = kaiser(15,1);%betaԽ������Խ����
Hf = kaiser(61,1);%���������Ȳ���������Ĭ�ϵ�SPWVD�����Ϻ�
SNR = 5:2:35;
Niter = 20;%���Դ���

nmse = zeros(length(SNR),length(s_org));

for iter = 1:Niter
    fprintf('iter = %d, totalIter = %d; \n',iter,Niter);
    for snr = 1:length(SNR)

        %% �������
        s = awgn(s_gen,SNR(snr),'measured');
        [tfr,rtfr] = tfrrspwv(s,1:length(s),length(s),Gt,Hf);%����Ĭ�ϵĺ�����Ч��

        %% ������ȡ
        img = tfr;%ͼ��ģ��
        portion = 0.95;%signalGenLLS��SSʱѡ��0.9��signalGenLxLSʱѡ��0.95
        [lines,rBin,rImg] = IfLineSegmentDetection(img,portion,'normal');%��ȡͼ���е�������Ϣ%normal,gradient
        linesSim = linesSimplify(lines);%����ȥ��

        %% ����ƴ�Ӻ��޸�
        linesInfo = curveModify(linesSim,length(s),0);%�޸����߷ֲ�����ʹ�ֱ�����ϴ��ڶ���������
        linesCon = linesConnect(linesInfo,40);%����ƴ�� % k=1;plot(linesCon{k}(:,1),linesCon{k}(:,2),'rx-');hold on; grid on
        linesFinal = curveModify(linesCon,length(s),15);%�ٴ��޸����߷ֲ�����ʹ�ֱ�����ϴ��ڶ���������

        %% ����ԭʼ�ź�--����ʱ���˲�������ÿһ·�ź�ʱ���˲�
        siflaw = [];
        for k = 1:length(linesFinal)
            ifk = nan(length(s),1);%˲ʱƵ��Ĭ��ΪNaN��Ϊ�˷���timeVaryingFilter������Ƶ���б�
            ifk(linesFinal{k}.line(:,1)) = linesFinal{k}.line(:,2);
            siflaw(:,k) = ifk*size(tfr,2)/size(tfr,1);%˲ʱƵ�ʺϳɣ���һ����WVD��Ƶ��ϵ�����棬��������ʱ���˲�����
        end
    %     tfr_stft = tfrstft_my(s);%surf(abs(tfr_stft))
    %     s_hat = timeVaryingFilter(tfr_stft,80,siflaw);%���ڳ�����Ϊ60,���STFT�Ŀ����ͬ

        %% ���ͳ��
        siflaw(isnan(siflaw)) = 0;
        for k = 1:length(linesFinal)
            sifrep = repmat(siflaw(:,k),1,length(s_org));
            difrc = sum((sifrep - iflaw).^2,1);
            [mse,ind] = min(difrc);
            nmse(snr,ind) = nmse(snr,ind) + mse/energy(ind);%�ڼ���������IF�������
        end
    end
end
nmse = nmse/Niter;%���ֵ
nmse = nmse/(max(nmse(:)));%��һ��

subplot(4,1,1:3)
plot(SNR,10*log(nmse(:,1)),'b.-',...
    SNR,10*log(nmse(:,2)),'rx-',...
    SNR,10*log(nmse(:,3)),'ksquare-');
legend('����1','����2','����3')

subplot(4,1,4)
plot(SNR,mean(nmse,2),'k.-');title('��������������')









