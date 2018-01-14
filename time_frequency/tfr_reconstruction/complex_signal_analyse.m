%% �����źŵķ���
clear all; close all;clc

%% 1��ѡ���źŵ�Ƶ�ʷ�����ʽ
[s_gen,s_itfr,s_org] = signalGenLLS();%ָ��2LFM+1SFM�źţ����ཻ
% [s_gen,s_itfr,s_org] = signalGenLxLS();%ָ��2LFM+1SFM�źţ���LFM��LFM�ཻ
s = awgn(s_gen,500,'measured');
% [s,s_itfr,s_org] = signalGenSS();%ָ��2SFM�ź�
% plot(real(s_org{1}),'.-');axis tight
% figure;contour(s_itfr);% colormap('hot');
% title('����ʱƵ�ֲ�');xlabel('f/Hz'),ylabel('t/s')%����ʱƵ�ֲ��Ĳ鿴

%% 2��BDʱƵ�ֲ��Ա�--�����÷���
% tfr = quadtfd( s, 127 , 1, 'emb',0.08,0.4);%����BD��
% figure; imagesc(tfr); colormap('hot');%p = tfsapl( s, tfr);
% xlabel('f/Hz'),ylabel('t/s');title('Extended Modified B-distribution');%����ʱƵ�ֲ��Ĳ鿴

%% 3��SPWVD�ֲ�
Gt = kaiser(15,1);%betaԽ������Խ����
Hf = kaiser(61,1);%���������Ȳ���������Ĭ�ϵ�SPWVD�����Ϻ�
[tfr,rtfr] = tfrrspwv(s,1:length(s),length(s),Gt,Hf);%����Ĭ�ϵĺ�����Ч��
% figure; imagesc(tfr);colormap('hot');%����rtfr����ƫ��
% xlabel('f/Hz'),ylabel('t/s');title('SPWVD');%SPWVD

%% 4��ͼ����--������ȡ
img = tfr;%ͼ��ģ��
portion = 0.9;%signalGenLLS��SSʱѡ��0.9��signalGenLxLSʱѡ��0.95
[lines,rBin,rImg] = IfLineSegmentDetection(img,portion,'gradient');%��ȡͼ���е�������Ϣ
% figure;imshow(rBin); axis xy;
% figure
% for k=1:length(lines)
%     plot(lines{k}(:,1),lines{k}(:,2),'b.-'); hold on; grid on;
%     axis([1,length(rBin),1, length(rBin)]);
% end
linesSim = linesSimplify(lines);%����ȥ��

%% 5������ƴ�Ӻ��޸�
linesInfo = curveModify(linesSim,length(s),-1);%�޸����߷ֲ�����ʹ�ֱ�����ϴ��ڶ���������
% figure;label={'ko-','bsquare-','rdiamond-','kv-','b^-','r<-','k<-','bpentagram-','rhexagram-','k+-','b*-','r.-','kx-'};
% for k = 1:length(linesInfo)
%     plot(linesInfo{k}.line(:,1),linesInfo{k}.line(:,2),label{1+mod(k,length(label))});hold on; grid on
%     linesInfo{k}.type
% end
linesCon = linesConnect(linesInfo,40);%����ƴ��%k=1;plot(linesCon{k}(:,1),linesCon{k}(:,2),'rx');hold on; grid on
linesFinal = curveModify(linesCon,length(s),15);%�ٴ��޸����߷ֲ�����ʹ�ֱ�����ϴ��ڶ���������
% figure;label={'ko-','bsquare-','rdiamond-','kv-','b^-','r<-','k<-','bpentagram-','rhexagram-','k+-','b*-','r.-','kx-'};
% for k = 1:length(linesFinal)
%     plot(linesFinal{k}.line(:,1),linesFinal{k}.line(:,2),label{k});hold on; grid on
%     linesFinal{k}.type
% end


%% ����ԭʼ�ź�--����ʱ���˲�������ÿһ·�ź�ʱ���˲�
% ���������ǲ����Եģ���ΪƵ�ʹ��ƴ��������´����ۼ��޷��ָ���ʱ�������Խ��ԽԶ
% for k = 1:length(linesInfo)
%     ifk = linesInfo{k}.line(:,2);
%     s_hat{k} = fmodany(ifk/length(s)/2,1);%������Ƶ�ź�
%     figure, plot(real(s_hat{k}),'b'), hold on; plot(real(s_org{k}),'r')
% end
% ʱ���˲���IF���+ʱ���˲�
tfr_stft = tfrstft_my(s);%surf(abs(tfr_stft))
series = [1,3,2];% ���۷��֣���ԭ��2��3�����źŷ��ˣ���˽���һ��
for k = 1:length(linesFinal)
    ifk = nan(size(tfr_stft,2),1);%˲ʱƵ��Ĭ��ΪNaN��Ϊ�˷���timeVaryingFilter������Ƶ���б�
    ifk(linesFinal{k}.line(:,1)) = linesFinal{k}.line(:,2);
    sif(:,series(k)) = ifk*size(tfr,2)/size(tfr,1);%˲ʱƵ�ʺϳɣ���һ����WVD��Ƶ��ϵ�����棬��������ʱ���˲�����
end
s_hat = timeVaryingFilter(tfr_stft,80,sif);%���ڳ�����Ϊ60,���STFT�Ŀ����ͬ
st_hat = 0;
figure(1); label={'ko-','bsquare-','rdiamond-','kv-','b^-','r<-','k<-','bpentagram-','rhexagram-','k+-','b*-','r.-','kx-'};
for k = 1:length(s_org)
    subplot(length(s_org),1,k);
    plot(real(s_org{k}),label{11}); hold on;
    plot(real(s_hat(:,k)),label{12}); axis tight;
    legend('ԭʼ�ź�','�ָ��ź�');
    st_hat = st_hat + s_hat(:,k);
end

%�ָ�ǰ�����źŶԱ�
figure; 
subplot(211),plot(real(s),'r.-'); hold on; plot(real(st_hat),'o-'); axis tight;title('�Ӻ��ź�');
subplot(212),plot(imag(s),'r.-'); hold on;  plot(imag(st_hat),'o-'); axis tight;legend('ԭʼ�ź�','�ָ��ź�');














