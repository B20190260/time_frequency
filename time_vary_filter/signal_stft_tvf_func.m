%% �����źźϳɷ�����WVD ���� STFT�µ�ʱ���˲�
% ���Է���STFT�µ�ʱ���˲��ȽϿ��ף����Ƕ��ڽ������Ȼ������ȷ��
% ʵ����������Ҫʹ�����ؿ��巽����ʾ�Ա����ַ������ã�����ֻ��ԭ���Ե���֤��


%% ʹ��synthesize+WVD�����ϳ��ź�--�����У���Ҫ����λƫ���ˣ�������ʱ����ʹ�ô��������ź�������λ���䣬�����ʱ�����ԡ�
% clear all; close all;clc
% s = fmlin(512,0,0.5,15);
% tfd_wvd = quadtfd( s, 127, 1, 'wvd', 512 );
% s_hat = synthesize( tfd_wvd, 'wvd', 127, s);
% % pf = sum(s.*conj(s_hat)); 
% % s_hat = s_hat.* pf/abs(pf); % ��λ����У����ʽ
% plot(1:length(s),imag(s),'b.-',1:length(s_hat),imag(s_hat),'rx-'); axis tight

%% 1.STFT�µ�ʱ���˲�����������Ӧ�����Ⱥ͹̶������ȵĶԱ�
clear all; clc; close all
N=512; t = 1:N;
[s_org,sif] = fmlin(N,0,0.5,120);
s = awgn(s_org,10,'measured');
[sh1,tfr,tfrv1] = stftSeparation(s,sif,30);%�̶������ȵ�ʱ���˲�
[sh2,tfr,tfrv2] = stftSeparationAdv(s,sif,30);%����Ӧ�����ȵ�ʱ���˲�
figure;plot(t,real(s_org),'b.-',t,real(s),'g',t,real(sh1),'r.-',t,real(sh2),'k.-'); 
axis tight;legend('orignal','noised','windowed','adaptive');%xlim([1,128])%�鿴��Եֵ
figure;subplot(131);imagesc(abs(tfr)); axis xy; 
subplot(132);imagesc(abs(tfrv1)); axis xy; 
subplot(133);imagesc(abs(tfrv2)); axis xy; 

pause
%% 2.STFT�µ�����AM-FM-PM�źŵĻָ�
clear all; clc; close all
N=512;  t = 1:N;
[sfm, sif] = fmlin(N,0,0.5,50);%plot(real(sfm))
sam = (cos(0.05*t)+2)/3;%plot(sam)
s_org = sfm.*sam.';%plot(real(s)) % ���ȵ���
s = awgn(s_org,5,'measured');%��5dB����
[sh1,tfr,tfrv1] = stftSeparation(s,sif,20);%�̶������ȵ�ʱ���˲�
[sh2,tfr,tfrv2] = stftSeparationAdv(s,sif,20);%����Ӧ�����ȵ�ʱ���˲�
figure;plot(t,real(s_org),'b.-',t,real(s),'g',t,real(sh1),'r.-',t,real(sh2),'k.-'); 
axis tight;legend('orignal','noised','windowed','adaptive');%xlim([1,128])%�鿴��Եֵ
figure;subplot(131);imagesc(abs(tfr)); axis xy; 
subplot(132);imagesc(abs(tfrv1)); axis xy; 
subplot(133);imagesc(abs(tfrv2)); axis xy; 

pause
%% STFT��2�����źŷ���+����У��
clear all; clc; close all
N=512;  t = 1:N;
[s1, sif1] = fmlin(N,0,0.4,120);
[s2, sif2] = fmlin(N,0.5,0,360);
s_org = s1+s2;%�źŵ���
s = awgn(s_org,10,'measured');%��5dB����
[sh1,tfr,tfrv1] = stftSeparation(s,[sif1,sif2],20);%�̶������ȵ�ʱ���˲�
[sh2,tfr,tfrv2] = stftSeparationAdv(s,[sif1,sif2],20);%����Ӧ�����ȵ�ʱ���˲�
% ��ͼ�Ա�
figure;
subplot(211);plot(t,real(s1),'b.-',t,real(s),'g',t,real(sh1(:,1)),'r.-',t,real(sh2(:,1)),'k.-'); 
axis tight;legend('orignal','noised intersect','windowed','adaptive');%xlim([1,128])%�鿴��Եֵ
subplot(212);plot(t,real(s2),'b.-',t,real(s),'g',t,real(sh1(:,2)),'r.-',t,real(sh2(:,2)),'k.-'); 
axis tight;legend('orignal','noised intersect','windowed','adaptive');%xlim([1,128])%�鿴��Եֵ
figure;
subplot(131);imagesc(abs(tfr)); axis xy; 
subplot(232);imagesc(abs(tfrv1(:,:,1))); axis xy; %�̶���
subplot(233);imagesc(abs(tfrv1(:,:,2))); axis xy; 
subplot(235);imagesc(abs(tfrv2(:,:,1))); axis xy; %����Ӧ��
subplot(236);imagesc(abs(tfrv2(:,:,2))); axis xy; 
%����ȡ���洦��ʱƵλ��
figure; overlayedTfr = sum(tfrv2,3) - tfr.*(sum(tfrv2,3)~=0); 
imagesc(abs(overlayedTfr));axis xy;

pause
%% STFT��3�����źŷ���+����У��
clear all; clc; close all
N=512;  t = 1:N;
[s1, sif1] = fmlin(N,0,0.4,120);
[s2, sif2] = fmlin(N,0.4,0,360);
[s3, sif3] = fmlin(N,0.2,0.2,60);
s_org = s1+s2+s3;%�źŵ���
s = awgn(s_org,10,'measured');%��5dB����
[sh1,tfr,tfrv1] = stftSeparation(s,[sif1,sif2,sif3],20);%�̶������ȵ�ʱ���˲�
[sh2,tfr,tfrv2] = stftSeparationAdv(s,[sif1,sif2,sif3],20);%����Ӧ�����ȵ�ʱ���˲�
figure;
subplot(311);plot(t,real(s1),'b.-',t,real(s),'g',t,real(sh1(:,1)),'r.-',t,real(sh2(:,1)),'k.-'); 
axis tight;legend('orignal','noised intersect','windowed','adaptive');%xlim([1,128])%�鿴��Եֵ
subplot(312);plot(t,real(s2),'b.-',t,real(s),'g',t,real(sh1(:,2)),'r.-',t,real(sh2(:,2)),'k.-'); 
axis tight;legend('orignal','noised intersect','windowed','adaptive');%xlim([1,128])%�鿴��Եֵ
subplot(313);plot(t,real(s3),'b.-',t,real(s),'g',t,real(sh1(:,3)),'r.-',t,real(sh2(:,3)),'k.-'); 
axis tight;legend('orignal','noised intersect','windowed','adaptive');%xlim([1,128])%�鿴��Եֵ
figure;
subplot(141);imagesc(abs(tfr)); axis xy; 
subplot(242);imagesc(abs(tfrv1(:,:,1))); axis xy; 
subplot(243);imagesc(abs(tfrv1(:,:,2))); axis xy; 
subplot(244);imagesc(abs(tfrv1(:,:,3))); axis xy; 
subplot(246);imagesc(abs(tfrv2(:,:,1))); axis xy; 
subplot(247);imagesc(abs(tfrv2(:,:,2))); axis xy; 
subplot(248);imagesc(abs(tfrv2(:,:,3))); axis xy; 
%����ȡ���洦��ʱƵλ��
figure; oTfr = sum(tfrv2,3) - tfr.*(sum(abs(tfrv2),3)~=0); 
imagesc(abs(oTfr));axis xy;
%  ��ȡ����1�����ӵĲ���--����1
figure; 
[r,c] = find(oTfr~=0);%�ҵ����������Ϊ0�ĵط�
oTfr1 = zeros(size(tfr));oTfr1(r,c) = tfrv2(r,c,1);%ȡ����1�����ڽ�������ĵط���ֵ
imagesc(abs(oTfr1));axis xy;
%  ��ȡ����1�����ӵĲ���--����2
figure; 
oTT = sum(tfrv2,3);Tfr1 = zeros(size(tfr));
Tfr1(tfrv2(:,:,1)~=0) = oTT(tfrv2(:,:,1)~=0);%���Եõ�����1�ڸ���λ��ʵ�ʼ����Ƶ�ʷ�Χ
oTfr1 = Tfr1 - tfrv2(:,:,1); % ��ȥ��ǰ��������ķ���ֵ���ɵõ������Ӳ��ֵķ���ֵ
% Tfr1r = Tfr1 - oTfr1; %���ʵ�ʵķ���ֵ������ʵ���ǻָ���tfrv2(:,:,1)�ˡ�
imagesc(abs(oTfr1));axis xy;








