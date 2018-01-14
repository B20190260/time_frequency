function [s,s_itfr,s_org,iflaw] = signalGenSS()
%% ����һ�����ӵĵ����źţ������������ʱƵ�ֲ���
% ��������ź�s�����������ʱƵ�ֲ�s_itfr
% ע���������ƿ��Բο������÷���
% a = {@fmlin, @fmconst};%�������cell��Ϊ����
% s = a{1}(60,0.3,0.1,1);%����ֵcell��Ϊ��������������
% ע�����õĽ��������ʹ�ú�����fmodany��ֻ��Ҫ���iflaw������

%�������
N = 512;%�źŲ�������
% fs = 1e6;%����Ϊ1M�����ʣ��������ڲ�������ʱ��t


%% SIN��Ƶ�źŲ���
t1=1;
[s1,if1]=fmsin(511,0.1,0.4,128,1,0.1,1);%(N,FNORMIN,FNORMAX,PERIOD,T0,FNORM0,PM1)
s_org{1} = [zeros(t1,1);s1;zeros(N-t1-length(s1),1)];
[s1,if1]= insert_signal(s1,N,t1,if1);

t2=1;
[s2,if2]=fmsin(511,0.1,0.4,128,1,0.4,1);%(N,FNORMIN,FNORMAX,PERIOD,T0,FNORM0,PM1)
s_org{2} = [zeros(t2,1);s2;zeros(N-t2-length(s2),1)];
[s2,if2]= insert_signal(s2,N,t2,if2);


%% ���
s =(s1+s2).';%
iflaw=[if1;if2].';%
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

