function [sigs,tfr,tfrv] = synsqCwtSeparation(x,ifs,halfLen)
%% ����ѹ��ͬ��С���任ʱ���˲����źŷ��룬�̶������ȣ�[sigs,tfr,tfrv] = synsqCwtSeparation(x,ifs,halfLen)
% ���룺x�������źţ��Ƕ�������ĵ���
%           ifs�������Ǹ���������˲ʱƵ��
%           halLen���̶������ȵĴ��볤��
% �����sigs������źţ����б�ʾһ���ź�
%           tfr����ά����ֱ��ʾ����������STFRFT��
%           tfrv����ά����ֱ��ʾ����������STFRFT��


assert(nargin>=2,'At least 2 parameter is required.');
epsIf = 1e-2; % ��ֵ

%������ʼ��
x = real(x(:));   tLen = length(x);  t=1:tLen; %��ȡʱ�䳤��
[~,sigN] = size(ifs);%��ȡ�źŵ�����
fLen = min([tLen, 512]);%Ƶ�����ֱ���Ϊ512
vice = round(fLen/9);% synsq_cwt_fw �任�Ľ��Ʒֿ�
fLen = vice*9;
ifs = ifs * 0.498*2 + 0.002; % fs�Ǵ�0.02��ʼ�ģ�����б�Ҫ������ʼ

%% ����SCWT��
[Tx, fs,~,~,~] = synsq_cwt_fw(t,x,vice);
tfr = Tx; % �ϳ���

df = halfLen/fLen;% �̶�������ʵ���ϳ�2��

%% ��������
tfrv= zeros(fLen,tLen,sigN) ;
sigs = zeros(size(ifs));
for is = 1:sigN
    uif = ifs(:,is) .* (1+df) + epsIf;
    dif = ifs(:,is) .* (1-df) - epsIf;
    [Txfk,~,~] = synsq_filter_pass(Tx,fs,dif,uif);%����IF���ƾ�ȷ
    skh = synsq_cwt_iw(Txfk,fs);
    %% �����ֵ
    sigs(:,is) = hilbert(skh(:));
    tfrv(:,:,is) = Txfk;
end


end

% 
% function y = tvfIter(x, ind, maxLen)
% % �̶��������˲���
% Len = length(x);
% y = zeros(size(x));%Ĭ�϶���0
% y(ind) = x(ind);
% %% ��ǰ����
% for len = 0:maxLen %ע����Ҫ����0���ȵ�
%     indc = mod(ind-len,Len) + 1; %�������
%     y(indc) = x(indc);%���ڵ�������˲��������
% end
% %% ��������
% for len = 0:maxLen 
%     indc = mod(ind+len,Len) + 1; %���ұ���
%     y(indc) = x(indc);%���ڵ�������˲��������
% end
% 
% end