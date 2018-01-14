%% ����У��STFRFT��������ȷ��

%% 1��LFM�źŵ�FRFT�׷�ֵ��ԭʼ�źŵ�����Ƶ�ʹ�ϵ
clear all; clc, close all;
N=128;  t = 1:N;    %��������
fs =1;  f0 = -0.5;  fend = 0.5;%����Ƶ��
[s_org,iflaw] = fmlin(N,f0,fend,1);
% [s_org,iflaw] = fmsin(N,f0,fend,N);
s = awgn(s_org,5,'measured');
% ��������׵���ѽǶ�
kgen = diff(iflaw);kgen = [kgen(1);kgen];% IF�ĵ�����б��k
popt = -acot(kgen*N)*2/pi; %����������FRFT����
% p = mod(popt,4); p(p>2) = p(p>2)-2; 
% p(p>1.5) = p(p>1.5)-1; p(p<0.5) = p(p<0.5)+1; 
% plot(p)

% % ���������ת����
% pSel = 0:0.01:2;
% G=zeros(length(pSel),length(s));	%��ͬ�����ı任�������
% maxAm=0;        %��¼���Ƶ��
% for k=1:length(pSel)
%     tmp=fracft(s,pSel(k));      %�����׸���Ҷ�任
%     G(k,:)=abs(tmp(:));       %ȡ�任��ķ���
%     if(maxAm<=max(abs(tmp(:))))
%         [maxAm,uOpt]=max(abs(tmp(:)));       %��ǰ�����ڵ�ǰ��ĺ������
%         pOpt=pSel(k);                %��ǰ���ֵ��Ľ���a
%     end
% end
% imagesc(1:length(s),pSel,G);xlabel('ut');ylabel('angle');axis xy;

% ����STLOFRFT����ȷ��
[TFD_LOSTFRFT, ang] = tfrLoStfrft(s,0.02);%���㸴�ӶȺܸ�
TFD_STFT = tfrsp(s);
subplot(1,3,1);plot(ang,'.-');axis tight;ylim([0,2]);title('angle');
subplot(1,3,2);imagesc(abs(TFD_LOSTFRFT));axis xy;title('LOSTFRFT');
subplot(1,3,3);imagesc(abs(TFD_STFT));axis xy;title('STFT');

%% ����SFM�ź�
clear all;clc;close all;
N=256;
s_org = 2*fmsin(N,-0.1,0.2,N) + 1*fmlin(N,0.3,0.4);
s = awgn(s_org,2,'measured');
[TFD_LOSTFRFT, ang] = tfrLoStfrft(s,0.05);%���㸴�ӶȺܸ�
% [TFD_COSTFRFT, ang] = tfrCoStfrft(s,0.01);%���㸴�ӶȺܸ�
TFD_STFT = tfrsp(s);
subplot(1,3,1);plot(ang,'.-');axis tight;ylim([0,2]); title('angle');
subplot(1,3,2);imagesc(abs(TFD_LOSTFRFT));axis xy;title('LOSTFRFT');
subplot(1,3,3);imagesc(abs(TFD_STFT));axis xy;title('STFT');







