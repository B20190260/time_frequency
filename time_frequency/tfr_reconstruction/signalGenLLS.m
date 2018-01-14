function [s,s_itfr,s_org,iflaw] = signalGenLLS()
%% ����һ�����ӵĵ����źţ������������ʱƵ�ֲ���
% ��������ź�s�����������ʱƵ�ֲ�s_itfr
% ע���������ƿ��Բο������÷���
% a = {@fmlin, @fmconst};%�������cell��Ϊ����
% s = a{1}(60,0.3,0.1,1);%����ֵcell��Ϊ��������������
% ע�����õĽ��������ʹ�ú�����fmodany��ֻ��Ҫ���iflaw������

%�������
N = 512;%�źŲ�������
% fs = 1e6;%����Ϊ1M�����ʣ��������ڲ�������ʱ��t

%% LFM�źţ���ͬλ�õ�����LFM�ź�
t1 = 100;%LFM1��ʼ��
[s1,if1]=fmlin(400,0.2,0.05,1);%���Ե�Ƶ�źţ���0��λΪ��һ��������
s_org{1} = [zeros(t1,1);s1;zeros(N-t1-length(s1),1)];
[s1,if1] = insert_signal(s1,N,t1,if1);


t2 = 10;%LFM2��ʼ��
[s2,if2]=fmlin(250,0.25,0.45,1);%���Ե�Ƶ�źţ���0��λΪ��1��������
s_org{2} = [zeros(t2,1);s2;zeros(N-t2-length(s2),1)];
[s2,if2]= insert_signal(s2,N,t2,if2);

%% SIN��Ƶ�źŲ���
t4=200;
[s4,if4]=fmsin(300,0.2,0.32,200,1,0.28,1);%(N,FNORMIN,FNORMAX,PERIOD,T0,FNORM0,PM1)
s_org{3} = [zeros(t4,1);s4;zeros(N-t4-length(s4),1)];
[s4,if4]= insert_signal(s4,N,t4,if4);

%% �̶�Ƶ���ź�
% t5 = 50;
% [s5,if5]=fmconst(300,0.1);
% [s5,if5]= insert_signal(s5,N,t5,if5);

%% ���
s =(s1+s2+s4).';%s =(s1+s2+s3 +s4+s5).';
iflaw=[if1;if2;if4].';%iflaw=[if1;if2;if3;if4;if5].';
if nargout < 1
    figure,tfrideal(iflaw);%�����ź�ʱƵ�ֲ�
else
    s_itfr = tfrideal(iflaw);%�����ź�ʱƵ�ֲ�
end

end


function [s,s_if] = insert_signal(sig,N,t0,sig_if)
% ���ź�sig���뵽һ��N���ȵ�0�ź��У���ʼ��Ϊt0������ź�s
if nargin < 1
    s = [];
elseif nargin < 2
    s = sig(:).';%�����źű�����һά��
elseif nargin < 3
    assert(N>=length(sig),'�źų���%d>�������,���޷����룡%d',length(sig),N);
    
    s = [sig(:),zeros(N-length(sig),1)].';%�����źű�����һά��
elseif nargin < 4
    assert(N>=length(sig),'�źų���%d>�������%d���޷����룡%d',length(sig),N);
    assert(t0<=N-length(sig),'��ʼλ��%d>�������-�źų��ȣ��޷����룡%d',t0,N-length(sig));
    
    s = [zeros(t0,1);sig(:);zeros(N-length(sig)-t0,1)].';%�����źű�����һά��
else
    assert(length(sig) == length(sig_if),'�źų��ȱ��������˲ʱƵ�ʳ��ȣ�');
    assert(N>=length(sig),'�źų���%d>�������%d���޷����룡%d',length(sig),N);
    assert(t0<=N-length(sig),'��ʼλ��%d>�������-�źų��ȣ��޷����룡%d',t0,N-length(sig));
    
    s = [zeros(t0,1);sig(:);zeros(N-length(sig)-t0,1)].';%�����źű�����һά��
    s_if = [NaN*zeros(t0,1);sig_if(:);NaN*zeros(N-length(sig)-t0,1)].';%�����źű�����һά��
end

end

