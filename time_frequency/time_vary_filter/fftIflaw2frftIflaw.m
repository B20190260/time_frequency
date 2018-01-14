function [fc,uc,popt] = fftIflaw2frftIflaw(iflaw,fLen)
% [fc,uc,popt] = fftIflaw2frftIflaw(iflaw,fLen)
%% ��STFT�任��˲ʱƵ��iflawת��ΪSTFRFT�任��˲ʱƵ��
% ����iflaw���źŵ�˲ʱƵ�ʣ�fLen����Ƶ�ʲ���������
% ���fc��ʾ�źŵ�˲ʱƵ�ʣ�uc��ʾ�źŵ�˲ʱ������Ƶ�ʣ�popt�Ǹ������FRFT��ѽ���
% ��Ҫע��������ﷵ�ص�fc��uc���������Ƶ������㣬Ҫʹ����Ҫ���䡾ȡ�������롿

if max(iflaw)>0.5 %�����������iflaw������Ƶ�ʵ㣬�Ƚ����һ����ʵ������Ƶ�ʵ�
    if max(iflaw)>1; iflaw = iflaw/fLen; end
    iflaw(iflaw>0.5) = iflaw(iflaw>0.5)-1;
end

% ����iflaw��ȡб�ʣ������õ�FRFT��ת�Ƕ�
kgen = diff(iflaw);% IF�ĵ�����б��k
% kgenl = [kgen(1);kgen];kgenr = [kgen;kgen(end)];
% kgen = (kgenl+kgenr)/2;
%ĳһ�����б��������б�ʺ���б�ʵľ�ֵ����ʵ����ֻȡkgenlҲӰ�첻��
popt = real(-acot(kgen*fLen)*2/pi);
% poptl = [popt(1);popt];poptr = [popt;popt(end)];
% popt = (poptl+poptr)/2;
popt = [popt(1);popt];%��Ҳ��֪��Ϊʲô��������������ĸ�����С

% ����ʵ��Ƶ�ʵ��Լ����ƫ��ֵ
fc = real(iflaw*fLen); 
uc = real(iflaw*fLen .* sin(popt*pi/2));%ʵ��FRFT��Ƶ��


end