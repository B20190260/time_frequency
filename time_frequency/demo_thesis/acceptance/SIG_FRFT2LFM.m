%% LFM��FRFT�����ѹ���չʾ
clear,clc,close all;
N=128;      %��������
r=0.05;     %��������������ʵ�ʷ���ʱԽСԽ��ȷ
fs =1;  %����Ƶ��
f0 = 0;  fend = 0.5;
s = fmlin(N,f0,fend,1);
t = 1:N;
f = linspace(-0.5,0.5,N);%Ƶ�ʵ㡾���������������ģ�fmlinֱ�ӷ��ص�f����ȷ��
% ��ͬ�����µ�FRFT�任
a=0:r:2;    %FRFT�������ο�����2.1
G=zeros(length(a),length(s));	%��ͬ�����ı任�������
f_opt=0;        %��¼���Ƶ��
for l=1:length(a)
    T=frft_org(s,a(l));         %�����׸���Ҷ�任
    G(l,:)=abs(T(:));       %ȡ�任��ķ���
  if(f_opt<=max(abs(T(:))))     
    [f_opt,f_ind]=max(abs(T(:)));       %��ǰ�����ڵ�ǰ��ĺ������
    a_opt=a(l);                %��ǰ���ֵ��Ľ���a
  end
end
%������άͼ��
[xt,yf]=meshgrid(a,f);             %��ȡ����������
surf(xt',yf',G);               % colormap('Autumn');     %��ɫģʽ
xlabel('p');ylabel('u');%uΪ��p�����µĵ�ЧƵ��
axis tight; grid on;
%�����Ƶб��
nor_coef=(t(N)-t(1))/fs;      %���ݲ����ʼ����һ�����ӣ�ע�������ϵ�б����������Ƶ��Ϊ��λ�ģ���˹�ʽ����ȫһ��
kr=-cot(a_opt*pi/2)/nor_coef;   %k�����Ĺ���ֵ������alpha=pi*a/2
%������ʼƵ��
u0=f(f_ind);      %�����Ӧ�ĵ�ЧƵ��
f_center=u0*csc(a_opt*pi/2);  % ����Ƶ��f0�Ĺ���ֵ
fprintf('��������Ƶб��=%f�� ����Ƶ��Ϊ=%f \n',(fend-f0)/N*fs,(f0+fend)/2);
fprintf('���ƣ���Ƶб��=%f�� ����Ƶ��Ϊ=%f \n',kr,f_center);
% tfsapl(s,G,'GrayScale','on','xlabel','p','ylabel','u');%Ч��Ҳ����