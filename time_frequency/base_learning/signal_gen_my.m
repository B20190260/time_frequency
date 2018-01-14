function [s,s_itfr] = signal_gen_my()
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
[s1,if1]=fmlin(300,0.25,0,1);%���Ե�Ƶ�źţ���0��λΪ��һ��������
[s1,if1] = insert_signal(s1,N,t1,if1);

t2 = 0;%LFM2��ʼ��
[s2,if2]=fmlin(200,0.2,0.5,100);%���Ե�Ƶ�źţ���0��λΪ��100��������
[s2,if2]= insert_signal(s2,N,t2,if2);

%% SIN��Ƶ�źŲ���
t3=200;
[s3,if3]=fmsin(312,0.15,0.45,200,1,0.35,1);%����Ϊ100����λ0��Ϊ1��t0����Ƶ��Ϊ0.35��Ƶ�ʷ���Ϊ��
[s3,if3]= insert_signal(s3,N,t3,if3);

%% �̶�Ƶ���źŲ���
t4 = 300;
[s4,if4]=fmconst(200,0.25);
[s4,if4]= insert_signal(s4,N,t4,if4);

t5 = 0;
[s5,if5]=fmconst(200,0.45);
[s5,if5]= insert_signal(s5,N,t5,if5);

%% ��Ƶ�ź�
Nf = 8;%10����Ƶ��
fp = randi(Nf-1,1,Nf)/Nf/2;%�������
if6 = repmat(fp,N/Nf,1);%�ظ�
if6 = if6(:);
[s6,if6] = fmodany(if6,1);%������Ƶ�ź�
[s6,if6] = insert_signal(s6,N,0,if6);

%% ���
s =(s1+s2+s3+0.1*s4+0.1*s5+0.1*s6).';%s1+s2+s3+s4+s5+s6
iflaw=[if1;if2;if3;if4;if5;if6].';
if nargout <2
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

