% ����Ƶ��100MHz������1V
% ���ű��ļ��������С�ʱƵ���������½ڡ����ͼ�����ɵ���䣬
% ĳЩ��������̫ռ�ռ��װ�����������ˣ�����鿴��ע�͡�


%% �ź���͸�������WVD��ģ�����ʾ��
clear all; close all; clc;
Fs = 100;N=256; %��λ��ӦMHz, us
s1 = fmconst(N,0.07,1) + fmlin(N,0.2,0.4,1);%tfrspwv(s);
QTFR_Compare_autoTerm_corssTerm(s1,N,Fs);%2LFM�Ľ�����չʾ
s2 = fmconst(N,0.07,1) + fmsin(N,0.2,0.4,N*2,1,0.35);%tfrspwv(s);
QTFR_Compare_autoTerm_corssTerm(s2,N,Fs);%2LFM�Ľ�����չʾ


pause
%% ��ͬ���ڲ�ͬ�����µı���
QTFR_Compare_different_Kernels();


pause
%% ��ͬ���µ�QTFR�Ա�
% QTFR_Compare_Separable_kernels_thesis();%���ǿɷ����
QTFR_Compare_different_Kernels_tfr();
QTFR_Compare_different_Kernels_perference();


pause
%% ����DGF��ת���ڲ�ͬ�Ƕ��µ�ͨ������
clear all; close all; clc
N=83; %�˴�С
endAngle=180; stepAngle=45;%�ܵĽǶȺͽǶ��ݶ�
a = 2; b = 12; %�˲���
[x,y]=meshgrid(-1:2/N:1,-1:2/N:1); %��xyֵ����
KerCell = cell(endAngle/stepAngle,1);
for k=0:endAngle/stepAngle-1
    angle=pi*k*stepAngle/endAngle;%��ǰ��ת�Ƕ�
    
    xr=x*cos(angle)-y*sin(angle);%��ʽ52�����t_theta��f_theta
    yr=x*sin(angle)+y*cos(angle);
    
    ker=exp((-1/2)*(((a*xr).^2)+(b*yr).^2));%ʽ52���㵼����ɵ�
    ker=ker.*(1-b*b*yr.^2);
    ker=ker/sum(sum(abs(ker)));
    KerCell{k+1} = ker;
    
    % % �������--�鿴��תDGF��
    % imagesc(BB{kk+1});pause(0.01)
    figure;imagesc(KerCell{k+1});axis off;colormap('hot');
end


pause
%% ��ͬTFR��ADTFR�ĶԱ�
clear all; close all;clc
Fs = 100;N=256; %��λ��ӦMHz, us
t = (0:(N-1))/Fs; f = linspace(0,Fs/2,N);
s = fmsin(N,0.1,0.3) + fmlin(N,0.35,0.1,128);
s = awgn(s,50,'measured'); %%%%%%% ���������
TFD_WVD=quadtfd(s,N-1,1,'wvd',N);
TFD_SPEC = quadtfd(s, N-1, 1, 'specx', 51, 'hamm',N);
% TFD_SM = quadtfd(s,N-1,1,'smoothed',51, 'hamm',N);
% TFD_EMBD=quadtfd(s,N-1,1,'emb',0.3,0.3,N);
TFD_CKD=tfrCKD(s);
TFD_AOK = tfrAOK(s);
TFD_AFS=tfrAFS(s);
TFD_ADTFD = tfrADTFD(s, 3, 12, 82);
figure('Name','TFD_WVD');imagesc(t,f,abs(TFD_WVD));axis xy;set_gca_style([5,5]);axis off;set(gca, 'position', [0 0 1 1 ]);
figure('Name','TFD_SPEC');imagesc(t,f,abs(TFD_SPEC));axis xy;set_gca_style([5,5]);axis off;set(gca, 'position', [0 0 1 1 ]);
figure('Name','tfrCKD');imagesc(t,f,abs(TFD_CKD));axis xy;set_gca_style([5,5]);axis off;set(gca, 'position', [0 0 1 1 ]);
figure('Name','TFD_AOK');imagesc(t,f,abs(TFD_AOK));axis xy;set_gca_style([5,5]);axis off;set(gca, 'position', [0 0 1 1 ]);
figure('Name','TFD_AFS');imagesc(t,f,abs(TFD_AFS));axis xy;set_gca_style([5,5]);axis off;set(gca, 'position', [0 0 1 1 ]);
figure('Name','TFD_ADTFD');imagesc(t,f,abs(TFD_ADTFD));axis xy;set_gca_style([5,5]);axis off;set(gca, 'position', [0 0 1 1 ]);
RWVD=sum(abs(TFD_WVD(:))>0.1*max(abs(TFD_WVD(:))))/N.^2
RSPEC=sum(abs(TFD_SPEC(:))>0.1*max(abs(TFD_SPEC(:))))/N.^2
RCKD=sum(abs(TFD_CKD(:))>0.1*max(abs(TFD_CKD(:))))/N.^2
RAOK=sum(abs(TFD_AOK(:))>0.1*max(abs(TFD_AOK(:))))/N.^2
RAFS=sum(abs(TFD_AFS(:))>0.1*max(abs(TFD_AFS(:))))/N.^2
RADTFD=sum(abs(TFD_ADTFD(:))>0.1*max(abs(TFD_ADTFD(:))))/N.^2








