function [t,s]=cosSignalGen(f,p,a,fs,N)
% [t,s]=cosSignalGen(f,p,a,fs,N)
% ������������źŵĵ��ӣ�����f/p/a��ʾ����Ƶ��/��ʼ��λ(����)/���ȣ�fs�ǲ���Ƶ�ʣ�N�ǲ�������

t=(0:1:N-1)/fs;%����ʱ��
s=zeros(1,length(t));
for k=1:length(f)
    s=s+a(k)*sin(2*pi*t*f(k)+p(k));%ѭ�����������ź�
end

end