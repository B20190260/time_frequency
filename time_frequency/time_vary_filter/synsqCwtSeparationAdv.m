function [sigs,tfr,tfrv] = synsqCwtSeparationAdv(x,ifs,halfLen)
%% ����ѹ��ͬ��С���任ʱ���˲����źŷ��룬�̶������ȣ�[sigs,tfr,tfrv] = synsqCwtSeparationAdv(x,ifs,halfLen)
% ���룺x�������źţ��Ƕ�������ĵ���
%           ifs�������Ǹ���������˲ʱƵ��
%           halLen���̶������ȵĴ��볤��
% �����sigs������źţ����б�ʾһ���ź�
%           tfr����ά����ֱ��ʾ����������STFRFT��
%           tfrv����ά����ֱ��ʾ����������STFRFT��

assert(nargin>=2,'At least 2 parameter is required.');
thr = 0.1;%ʱ���˲����޶�ֵ���������йأ���ֵԽ���źŵķ���˥��Խ����Ҫ�����ȸ������ֵ��������

%������ʼ��
x = real(x(:));   tLen = length(x);  t=1:tLen; %��ȡʱ�䳤��
[~,sigN] = size(ifs);%��ȡ�źŵ�����
fLen = min([tLen, 512]);%Ƶ�����ֱ���Ϊ512
vice = round(fLen/9);% synsq_cwt_fw �任�Ľ��Ʒֿ�
% fLen = vice*9;

%% ����SCWT��
[Tx, fs,~,~,~] = synsq_cwt_fw(t,x,vice);
fLen = size(Tx,1);% �������������Ƶ�ʵ�
tfr = Tx; % �ϳ���


%% ��������
tfrv= zeros(fLen,tLen,sigN) ;
sigs = zeros(size(ifs));
for is = 1:sigN
    %% ����Tx����������ifs�����һ�����������Ϊ��ֵѰ�ҵ�ǰ�ļ�ֵ
    Txfk = zeros(fLen,tLen);
    for it = 1:tLen
        [~,ifc] = min(abs(ifs(it,is) - fs));
        tmp = tvfIter(abs(Tx(:,it)),ifc,thr,halfLen);
        kep = find(tmp>0);
%         Txfk(kep,it) = Tx(kep,it);
        % ��õķ����������ҵ���indexͨ��synsq_filter_pass������±߽�
        try
            uif(it) = fs(kep(end));dif(it) = fs(kep(1));
        catch
            if it == 1
                uif(it) = fs(5);dif(it) = fs(1);% ��һ�����ܱ���Ϊ0
            else
                uif(it) = uif(it-1);dif(it) = dif(it-1);% �����쳣ʱ������һ��ʱ�̵�ֵ���ɣ�
            end
        end
    end
    
    [Txfk,~,~] = synsq_filter_pass(Tx,fs,dif,uif);%����IF���ƾ�ȷ
    skh = synsq_cwt_iw(Txfk,fs);
    %% �����ֵ
    sigs(:,is) = hilbert(skh(:));
    tfrv(:,:,is) = Txfk;
end


end


function y = tvfIter(x, ind, thr, maxLen)
% �������Ƶ������x����ind��������������ҵ���ֵ�߽磬֮���������ݹ�0��
% �߽�Ķ��壺���ֵС����ֵedgeThr*max���Ǽ�Сֵ�ĵ㡣������ҵ��ļ�ֵ�㳬��maxLen�������
edgeThr = 0.4; %��Ե
Len = length(x);
y = zeros(size(x));%Ĭ�϶���0
y(ind) = x(ind); maxAbs = abs(x(ind));%�������ֵ
%% ��ǰ����
absp = maxAbs;
for len = 0:maxLen %ע����Ҫ����0���ȵ�
    indc = mod(ind-len,Len) + 1; %�������
    absc = abs(x(indc));
    if maxAbs<absc; maxAbs = absc; end
    if (absc < maxAbs*thr); break; end %������ֵ
    if (absc < maxAbs * edgeThr) && (absc > absp); break;  end%�߽絽������
    y(indc) = x(indc);%���ڵ�������˲��������
    absp = absc; %��¼���ڵ�ķ�ֵ
end
%% ��������
absp = maxAbs;
for len = 0:maxLen 
    indc = mod(ind+len,Len) + 1; %���ұ���
    absc = abs(x(indc));
    if maxAbs<absc; maxAbs = absc; end
    if (absc < maxAbs*thr); break; end %������ֵ
    if (absc < maxAbs * edgeThr) && (absc > absp); break;  end%�߽絽����������Ҫ��Ϊ�����ƽ������
    y(indc) = x(indc);%���ڵ�������˲��������
    absp = absc; %��¼���ڵ�ķ�ֵ
end

end
