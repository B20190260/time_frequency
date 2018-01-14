function [tfr,fc]= stfrftShift(tfr,fc,uc)
%% tfr= stfrftShift(tfr,fc,uc)
% У��STFRFT�����STFT���۵�ƫ��Ƶ��
% ���룺tfr����õ�ʵ��FRFT��Ƶ�ʡ�
% fc �Ǹ������STFT˲ʱƵ��ֵ��uc�Ǹ���STFRFT��˲ʱƵ��ֵ��
% �����tfr�������������TFR�ף���Ҫ�Ǳ������۹۲���FRFT�ס�
% fc���������uc����ʵ���ǽ�uc�任��fcλ����

% ����У��
[fLen,tLen] = size(tfr);
dis = round(mod(fc,fLen) - mod(uc,fLen));%����ƫ����

for k = 1:tLen
    tfr(:,k) = circshift(tfr(:,k),dis(k),1);%�����ƶ���STFT��IFλ��
end

end