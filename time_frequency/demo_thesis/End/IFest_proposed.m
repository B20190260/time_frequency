function hif = IFest_proposed(tfr,delta_freq_samples,min_track_length,max_peaks,lower_prctile_limit,win1,win2)
% ��֮ǰ���㷨���Ƴ�����IF��Ϣ hif_pre �Ļ����Ϲ�����ǿͼ����hif

if nargin < 7
    win1 = 2; win2 = 5;%������ʼ��
end

Fs = 100;N=length(tfr); %��λ��ӦMHz, us
F_scale = Fs/N/2;

[beta0, beta1, beta2]= gradientVector(tfr,win1);%��ʽ6����beta0��1��2
[beta1fix, beta2fix] = vectorModify(beta1,beta2);% �ݶ���������
% [x,y] = meshgrid(1:size(tfr,2),1:size(tfr,1));%��ͼר����������
% figure('Name','ԭʼ�ݶȾ���'); quiver(x(:),y(:),beta2(:),beta1(:));
% set_gca_style([8,8]);axis equal;axis off;
% figure('Name','��ת�ݶȾ���'); quiver(x(:),y(:),beta2fix(:),beta1fix(:));
% set_gca_style([8,8]);axis equal;axis off;


% rImg1 = meanGradientRatioImgEasy(beta0, beta1, beta2, beta1fix, beta2fix,win1);
% figure('Name','�̶�����ǿ'); imagesc(rImg1); set_gca_style([6,6],'img');
rImg2 = meanGradientRatioImg(beta0, beta1, beta2, beta1fix, beta2fix, win2);
% figure('Name','����Ӧ����ǿ'); imagesc(rImg2); set_gca_style([5,5],'img');
% rBin = gradientImg2Bin(rImg2, 1000, 0.98);%imshow(rBin)
% rImg2Fix = rImg2.*rBin;imagesc(rImg2Fix);set_gca_style([6,6],'img');
img = rImg2';%ѡ��ͼ��  imagesc(img)


[hif_pre,~] = IFest_compare_algorithm(img,delta_freq_samples,min_track_length,max_peaks,lower_prctile_limit);%ֻѡ��BDIF�㷨�������Ϊ����
%% ͼ�������㷨
% IFƬ�����
label={'ro-','b.-','r^-','kv-','b^-','r<-','k<-','bpentagram-','rhexagram-','k+-','b*-','r.-','kx-'};%��ͼ����
linesInfo = curveModify(hif_pre,N,-2);%�޸����߷ֲ�����ʹ�ֱ�����ϴ��ڶ���������
% figure('Name','IFs FIT');
% for n=1:length(hif_pre) ;   hmcq=plot(hif_pre{n}(:,1)/Fs,hif_pre{n}(:,2)*F_scale,'ro-'); hold on;  end   %����IF����
% for k = 1:length(linesInfo);    hfit = plot(linesInfo{k}.line(:,1)/Fs,linesInfo{k}.line(:,2)*F_scale,'b.-');hold on;  end
% legend([hmcq,hfit],{'IFƬ��','���IFƬ��'}); set_gca_style([6,6]);grid off; ylim([0,50]);%�������ͼ��
% xlabel('ʱ��/\mus');ylabel('Ƶ��/Mhz');

% IFƬ������
linesCon = linesConnect(linesInfo,40);%����ƴ��
% figure('Name','IFs Connect');
% for k=1:length(linesCon);plot(linesCon{k}(:,1)/Fs,linesCon{k}(:,2)*F_scale,label{k});hold on; end
% set_gca_style([6,6]);grid off; ylim([0,50]);xlabel('ʱ��/\mus');ylabel('Ƶ��/Mhz');

% �������
enLen = 20;
linesFinal = curveModify(linesCon,N,enLen);%--��Ҫ����̫���Ա�������IFҲ����ȫ��
% figure('Name','IF FIT-pro');
% for k = 1:length(linesFinal);    
%     if length(linesFinal{k}.line)<(enLen*2 + 50); continue;end %% ȥ��̫�̵�IF�����ź�
%     plot(linesFinal{k}.line(1:5:end,1)/Fs,linesFinal{k}.line(1:5:end,2)*F_scale, label{k});hold on; 
% end
% set_gca_style([6,6]);grid off; ylim([0,50]);xlabel('ʱ��/\mus');ylabel('Ƶ��/Mhz');
% plot(t,sif1*Fs,'b^',t,sif2*Fs,'rv');

hif = linesFinal;



end