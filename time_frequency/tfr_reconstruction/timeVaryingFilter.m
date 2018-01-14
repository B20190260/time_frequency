function sigs = timeVaryingFilter(tfr,winLen,f)
% function sigs = timeVaryingFilter(tfr,winLen,f,type,param,param2)
%% ����ʱƵ���±��˲����ĺ���
% ���룺tfr�ź�stftʱƵ�ף�Len�����ȣ�f���б�ʾ�÷�����˲ʱƵ�ʷ�����NAN��ʾ�ô���Ƶ�ʣ�
%           type �˲����Ӵ�����
% �����sigs���б�ʾ���е��ź�

[tLen,fLen] = size(tfr);%����ȷ��
if max(f(:))<=0.5 %������Ƶ�ʷ����ǹ�һ����ʱִ�еĴ���
    f = round(f*fLen);%˲ʱƵ��->Y������λ��
else%����Ƶ�ʷ������ǹ�һ���ģ����Ǵ�ͼ���еõ�����ʵƵ�ʵ�
    f = round(f/2);%�����ʹ��WVD��չ��ͼ��õ��ģ�����Ҫ����2����ΪSTFT��������
end

assert(mod(winLen,2)==0,'���봰���ȱ���Ϊż���Ա�֤�Գƣ�');

% ʱ���˲�������
Win = tftb_window(winLen,'Hamming');
baseWin = [Win; zeros(fLen-winLen,1)];%��
baseWin  = circshift(baseWin,-winLen/2,1);%plot(baseWin); axis tight
% ʱ���˲���������
amf = ones(tLen,size(f,2));%Ĭ�϶��ǷŴ�1
mainWin = zeros(tLen,fLen);%������
for n = 1:size(f,2)%ÿ������
    for k = 1:tLen%ÿ��ʱ��
        if isnan(f(k,n))%Ƶ��ֵΪnan
            win{n}(:,k) = zeros(fLen,1);%û��Ƶ��ֵ��ֵȫΪ0
        else
            win{n}(:,k) = circshift(baseWin,f(k,n),1);%��ѭ��ƽ�Ƶ�IF����
            %��������������Խ����źŵ�STFT����Ч�������ʵ���ź�Ӧ����Ҫ�޸�Ϊ���£�
            %win{n}(:,k) = circshift(baseWin,f(k,n),1) + circshift(baseWin,-f(k,n),1);%��ѭ��ƽ�Ƶ�IF����
            
            %����ʱ���˲�����������
            fadd = abs(f(k,:)-f(k,n)) + 1;%�ڸõ�����ص��ķ���
            fadd = fadd(~isnan(fadd)); %ȥ��nana��ֵ
            scale = sum(baseWin(fadd)); %���ӵķŴ�Ч��
            %amf(k,n) = 1.5-0.5*scale;%���Թ�ϵ��������2�����ź�
            %amf(k,n) = cos(2.0*pi*(scale-1)/6);%t=0:0.01:2;h=cos(2.0*pi*(t-1)/6);plot(t,h)%Hamming��h=0.54-0.46*cos(2.0*pi*(1:N)'/(N+1));
            %amf(k,n) = 1/scale;%���Թ�ϵ�������ڶ�����ź�
            mainWin(:,k) = mainWin(:,k) + win{n}(:,k)*amf(k,n);%������
        end
    end
    %surf(win{n})
end


%% ���ƴ������ͣ����Է��ִ��������Ӵ���Χ�ķŴ�����������Ҫ�����跨����
% surf(mainWin);%������ʱ���÷Ŵ�2����3����ʱ���÷Ŵ�3����



for k = 1:length(win)
    tfrk = tfr.*win{k};%Ƶ���˲�%imagesc(abs(tfrk))
    % ��Ҫ����Ƶ���ص�������ķ���
    sigs(:,k) = sum(tfrk,1)/fLen;%��ȡ����ź�
end

sigs = sigs.*amf;%���洦����У����

end


